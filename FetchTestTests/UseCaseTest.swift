//
//  UseCaseTest.swift
//  FetchTestTests
//
//  Created by ravinder vatish on 1/22/25.
//

import XCTest
import UIKit
@testable import FetchTest

final class UseCaseTest: XCTestCase {
    
    private var useCase: HomeUseCase!
    private var mockNetworkService: MockNetworkService!
    private var mockStorageService: MockStorageService!
    override func setUpWithError() throws {
        mockNetworkService = MockNetworkService()
        mockStorageService = MockStorageService()
        useCase = HomeUseCaseImp(networkService: mockNetworkService, storageService: mockStorageService )
        continueAfterFailure = false
    }
    
    func testNoImageFound() async {
      let image =  await useCase.getImage(url: "https://fetchTest.com/pasta")
        // we don't have a pasta image in storge and also not available at network
        // so it should return nil
        XCTAssertNil(image)
    }

    
    func testImageInStorage() async {
        //chicken curry image only exist in storage
        let image =  await useCase.getImage(url: "https://fetchTest.com/chicken_curry")?.pngData()
        let storedImage = UIImage(named: "chickenCurry")?.pngData()
        XCTAssertEqual(image,storedImage)
        
    }
    
    func testImageFromNetwork() async {
        //ribeye image only exist in the network
        let image =  await useCase.getImage(url: "https://fetchTest.com/ribeye")?.pngData()
        
        let storedImage = UIImage(named: "ribeye")?.pngData()
        XCTAssertEqual(image,storedImage)
    }
}
