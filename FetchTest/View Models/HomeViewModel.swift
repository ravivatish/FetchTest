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
class HomeViewModel: ObservableObject {
    @Published var recipes: [RecipeData] = []
    @Published var showError: Bool = false
    var useCase: HomeUseCase

    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }

    func getRecipes() async {
        if let data = await useCase.getRecipes() {
            recipes = data
            
            await withTaskGroup(of: (Int, UIImage?).self) { group in
                for (index, recipe) in recipes.enumerated() {
                    group.addTask {
                        let imageData = await self.useCase.getImage(url: recipe.url)
                        return (index, imageData)
                    }
                }
                for await (index, imageData) in group {
                    if let imageData = imageData {
                        recipes[index].image = imageData
                    }
                }
            }
        } else {
            showError = true
        }
    }

}
