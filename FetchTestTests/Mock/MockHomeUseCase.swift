//
//  MockHomeUseCase.swift
//  FetchTest
//
//  Created by ravinder vatish on 1/22/25.
//

@testable import FetchTest
import UIKit

class MockHomeUseCase: HomeUseCase {
    func getRecipes() async -> [FetchTest.RecipeData]? {
       return  [
        RecipeData(id: "1", name: "chicken curry", cuisine: "indian", url: "https://fetchTest.com/chicken_curry"),
        RecipeData(id: "2", name: "Medium Rare Ribeye", cuisine: "American", url: "https://fetchTest.com/ribeye")
        ]
    }
    func getImage(url: String) async -> UIImage? {
        UIImage(named: "chickenCurry")
    }
}
