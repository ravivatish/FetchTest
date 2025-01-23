//
//  ContentView.swift
//  FetchTest
//
//  Created by ravinder vatish on 1/18/25.
//
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            Group {
                if(viewModel.recipes.isEmpty) {
                    Text("No Recipes to display")
                }
                else {
                    List {
                        ForEach(viewModel.recipes) { recipe in
                            RecipeRow(recipe: recipe)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Recipes")
            .alert("Something went wrong", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {
                    viewModel.showError = false
                }
            } message: {
                Text("Please try again later.")
            }
            .task {
                await viewModel.getRecipes()
            }
        }
    }
}

struct RecipeRow: View {
    let recipe: RecipeData
    var body: some View {
        VStack(alignment: .leading) {
            RecipeDetails(recipe: recipe)
            RecipeImage(image: recipe.image)
        }
    }
}

struct RecipeDetails: View {
    let recipe: RecipeData
    var body: some View {
        Grid(alignment: .leading) {
            GridRow {
                Text("Name:")
                Text(recipe.name)
            }
            GridRow {
                Text("Cuisine:")
                Text(recipe.cuisine)
            }
        }
    }
}

struct RecipeImage: View {
    let image: UIImage?
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
            Spacer()
        }
    }
}

#Preview {
    let useCase = HomeUseCaseImp(networkService: NetworkService(), storageService: StorageService(limit: 40))
    HomeView(viewModel: HomeViewModel(useCase: useCase))
}
