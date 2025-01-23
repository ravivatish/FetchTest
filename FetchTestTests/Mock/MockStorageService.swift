//
//  MockStorageService.swift
//  FetchTest
//
//  Created by ravinder vatish on 1/22/25.
//

@testable import FetchTest
import SwiftUI
import Foundation

class MockStorageService : StorageServiceProtocol {
    func findImage(url: String) async -> Data? {
        if( url == "https://fetchTest.com/chicken_curry") {
            return UIImage(named: "chickenCurry")?.pngData()
        }
        else {
            return nil
        }
    }
    
    func addImage(url: String, imageData: Data?) async {
    }
    
    func setLimit(_ newLimit: Int) async {}
    
}

