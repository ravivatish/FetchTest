//
//  HomeUseCase.swift
//  FetchTest
//
//  Created by ravinder vatish on 1/22/25.
//

import SwiftUI

protocol HomeUseCase {
    func getRecipes()  async  -> [RecipeData]
    func getImage(url: String) async -> UIImage?
}
class HomeUseCaseImp: HomeUseCase {
    var networkService : NetworkServiceProtocol
    var storageService : StorageServiceProtocol
    
    init(networkService: NetworkServiceProtocol, storageService: StorageServiceProtocol) {
        self.networkService = networkService
        self.storageService = storageService
    }
    
    func getRecipes()  async  -> [RecipeData] {
        let recipesList = await networkService.getRecipes()
       let recipes = recipesList.map { recipe in
           RecipeData(id: recipe.uuid, name: recipe.name, cuisine: recipe.cuisine, url: recipe.largePhotoURL)
        }
        return recipes
    }
    func getImage(url: String) async -> UIImage? {
        if let data = await storageService.findImage(url: url) {
            return UIImage(data: data)
        }
        else {
            if let image = await networkService.getImage(url: url) {
                await storageService.addImage(url: url, imageData: image)
                return  UIImage(data: image)
            }
        }
        return nil
    }
}

