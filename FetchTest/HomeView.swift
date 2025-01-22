//
//  ContentView.swift
//  FetchTest
//
//  Created by ravinder vatish on 1/18/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel : HomeViewModel
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        List {
            ForEach(viewModel.recipes) { recipe in
                VStack (alignment: .leading) {
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
                    if( recipe.image != nil ) {
                        HStack(alignment: .center) {
                            Spacer()
                            Image(uiImage: recipe.image!).resizable()
                                .scaledToFit()
                                .frame(width: 300,height: 300)
                            Spacer()
                        }
                    }
                    else {
                        HStack(alignment: .center) {
                            Spacer()
                            Image(systemName: "photo").resizable()
                                .scaledToFit()
                                .frame(width: 300,height: 300)
                            Spacer()
                            
                        }
                    }
                }
            }
            
        }
        .padding()
        .task() {
            Task {
                await viewModel.getRecipes()
            }
        }
        
    }
}


#Preview {
    HomeView(viewModel:  HomeViewModel(
        networkService:NetworkService(), storageService: StorageService(limit: 20)))
}
