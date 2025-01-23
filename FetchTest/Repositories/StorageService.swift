//  StorageService.swift
//  FetchTest
//
//  Created by ravinder vatish on 1/20/25.
//

import SwiftUI
import Foundation

protocol StorageServiceProtocol {
    func findImage(url: String) async -> Data?
    func addImage(url: String, imageData: Data?) async
    func setLimit(_ newLimit: Int) async
 }

enum StorageServiceError : Error {
    case fileCreationFailed
    case fileNotFound
}

actor StorageService: StorageServiceProtocol {
    var lruIndex: [String] = []
    private var limit: Int = 50

    let fileManager: FileManager = FileManager.default
    let directoryURL: URL

    init(limit: Int) {
        self.limit = limit
        do {
            // Create a directory
            if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                self.directoryURL = documentDirectory.appendingPathComponent("ImageCache")
                // Ensure the directory exists
                if !fileManager.fileExists(atPath: directoryURL.path) {
                    try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                }
            } else {
                fatalError("Unable to find document directory.")
            }
        }
        catch {
            print(error)
        }
    }
    func setLimit(_ newLimit: Int) async {
        limit = newLimit
    }
    
    func findImage(url: String) async ->  Data? {
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

    func addImage(url: String, imageData: Data?) async {
        guard let imageData = imageData else { return }

        if lruIndex.count == limit {
            do {
                // Remove the least recently used image
                let oldestURL = lruIndex.removeLast()
                let oldestFilePath = directoryURL.appendingPathComponent(urlToFilename(oldestURL)).path
                try fileManager.removeItem(atPath: oldestFilePath)
            }
            catch {
                print(error)
            }
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
