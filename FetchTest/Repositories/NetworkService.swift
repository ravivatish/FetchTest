//
//  NetworkService.swift
//  FetchTest
//
//  Created by ravinder vatish on 1/18/25.
//

import Foundation
import SwiftUI

enum NetworkErrors : Error {
    case parsingFailed
    case networkRequestFailed
    case invalidImageData
}

enum AppURLS : String {
    case RecipesUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    case malformedUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    case emptyUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    func appURL() -> URL  {
        return URL(string: self.rawValue)!
    }
}

protocol NetworkServiceProtocol {
    func getRecipes() async  -> [Recipe];
    func getImage(url: String) async -> Data?
}

class NetworkService : NetworkServiceProtocol {
    
    func getRecipes() async -> [Recipe] {
        do {
            let responseData =  try await URLSession.shared.data(from: AppURLS.RecipesUrl.appURL())
            guard let response = responseData.1 as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                throw NetworkErrors.networkRequestFailed
            }
            let data = try JSONDecoder().decode(Recipes.self, from: responseData.0)
            return data.recipes
        }
        catch {
            print(error)
            return []
        }
    }
    
    func getImage(url: String) async -> Data? {
        guard let stringURL = URL(string: url) else {
            return nil
        }
        do {
            let data = try await URLSession.shared.data(from: stringURL)
            guard let response = data.1 as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                throw NetworkErrors.networkRequestFailed
            }
            return data.0
        }
        catch {
            print(error)
            return nil
        }
    }
}

