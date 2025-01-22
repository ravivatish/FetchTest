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
    var useCase : HomeUseCase
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    func getRecipes() async {
        recipes = await useCase.getRecipes()
        //fetch the images
        for (index,recipe) in recipes.enumerated() {
            recipes[index].image = await useCase.getImage(url: recipe.url)
        }
    }
}
