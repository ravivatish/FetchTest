//
//  HomeViewModel.swift
//  FetchTest
//
//  Created by ravinder vatish on 1/18/25.
//
import SwiftUI

struct RecipeData : Identifiable {
    let id: String
    let name: String
    let cuisine: String
    let url: String
    var image: UIImage?
}

@MainActor
class HomeViewModel : ObservableObject {
    
    @Published var recipes: [RecipeData]  = []
    
    var networkService : NetworkServiceProtocol
    var storageService : StorageServiceProtocol
    
    init(networkService: NetworkServiceProtocol, storageService: StorageServiceProtocol) {
        self.networkService = networkService
        self.storageService = storageService
    }
    
    func getRecipes()  async {
        let recipesList = await networkService.getRecipes()
       recipes = recipesList.map { recipe in
           RecipeData(id: recipe.uuid, name: recipe.name, cuisine: recipe.cuisine, url: recipe.largePhotoURL)
        }
        //fetch the images
        for (index,recipe) in recipes.enumerated() {
            recipes[index].image = await getImage(url: recipe.url)
        }
    }
    
    func getImage(url: String) async -> UIImage? {
        if let data = storageService.findImage(url: url) {
            return UIImage(data: data)
        }
        else {
            if let image = await networkService.getImage(url: url) {
                storageService.addImage(url: url, imageData: image)
               return  UIImage(data: image)
            }
        }
        return nil
    }
}
