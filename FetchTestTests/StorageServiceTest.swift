//
//  StorageServiceTest.swift
//  FetchTestTests
//
//  Created by ravinder vatish on 1/22/25.
//

import XCTest
@testable import FetchTest

final class StorageServiceTest: XCTestCase {
    
    private var storageService : StorageServiceProtocol!
    
    override func setUpWithError() throws {
        storageService = StorageService(limit: 2)
    }
    
    func testImageCaching() async throws {
        let url1 = "https://fetchTest.com/image1.jpg"
        let url2 = "https://fetchTest.com/image2.jpg"
        let url3 = "https://fetchTest.com/image3.jpg"
        
        await storageService.addImage(url: url1, imageData: Data("Image1".utf8))
        await storageService.addImage(url: url2, imageData: Data("Image2".utf8))
        await storageService.addImage(url: url3, imageData: Data("Image3".utf8))
        
        // first image should be removed from cach due to 2 limit size
       var data =  await storageService.findImage(url: url1)
       XCTAssertNil(data)
        data = await storageService.findImage(url: url2)
       XCTAssertNotNil(data)
        data = await storageService.findImage(url: url3)
       XCTAssertNotNil(data)
    }
    
    
    

}
