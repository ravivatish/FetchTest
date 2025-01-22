//
//  FetchTestApp.swift
//  FetchTest
//
//  Created by ravinder vatish on 1/18/25.
//

import SwiftUI

@main
struct FetchTestApp: App {
    var networkService = NetworkService()
    var storageService = StorageService(limit: 20)
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel(
                networkService:networkService, storageService: storageService)
            )
        }
    }
}
