//  StorageService.swift
//  FetchTest
//
//  Created by ravinder vatish on 1/20/25.
//

import SwiftUI
import Foundation

protocol StorageServiceProtocol {
    func findImage(url: String) -> Data?
    func addImage(url: String, imageData: Data?)
    var limit: Int { get set }
    var lruIndex: [String] { get set }
}

class StorageService: StorageServiceProtocol {
    var lruIndex: [String] = []
    var limit: Int

    let fileManager: FileManager = FileManager.default
    let directoryURL: URL

    init(limit: Int) {
        self.limit = limit
        
        // Create a directory
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            self.directoryURL = documentDirectory.appendingPathComponent("ImageCache")

            // Ensure the directory exists
            if !fileManager.fileExists(atPath: directoryURL.path) {
                try? fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            }
        } else {
            fatalError("Unable to find document directory.")
        }
    }

    func findImage(url: String) -> Data? {
        let filePath = directoryURL.appendingPathComponent(urlToFilename(url)).path

        if fileManager.fileExists(atPath: filePath),
            let imageData = fileManager.contents(atPath: filePath) {
            // Update LRU Index
            if let index = lruIndex.firstIndex(of: url) {
                lruIndex.remove(at: index)
                lruIndex.insert(url, at: 0)
            }
            return imageData
        } else {
            return nil
        }
    }

    func addImage(url: String, imageData: Data?) {
        guard let imageData = imageData else { return }

        if lruIndex.count == limit {
            // Remove the least recently used image
            let oldestURL = lruIndex.removeLast()
            let oldestFilePath = directoryURL.appendingPathComponent(urlToFilename(oldestURL)).path
            try? fileManager.removeItem(atPath: oldestFilePath)
        }

        // Save the new image
        let filePath = directoryURL.appendingPathComponent(urlToFilename(url))
        fileManager.createFile(atPath: filePath.path, contents: imageData, attributes: nil)

        // Update LRU Index
        lruIndex.insert(url, at: 0)
    }

    private func urlToFilename(_ url: String) -> String {
        return url.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
    }
}
