//
//  ViewModelTest.swift
//  FetchTestTests
//
//  Created by ravinder vatish on 1/22/25.
//

import XCTest
@testable import FetchTest

final class ViewModelTest: XCTestCase {
    private var viewModel: HomeViewModel!
    private var mockUseCase: MockHomeUseCase!

    override func setUpWithError() throws {
        let expectation = XCTestExpectation(description: "initilizatoin complete")
        Task {
              await viewModel = HomeViewModel(useCase: MockHomeUseCase())
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        continueAfterFailure = false
    }
    
    func testRecpesUpdate() async throws {
        await viewModel.getRecipes()
        await MainActor.run {
            XCTAssert( viewModel.recipes.count == 2)
        }
    }
}
