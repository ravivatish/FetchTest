//
//  Recipe.swift
//  FetchTest
//
//  Created by ravinder vatish on 1/18/25.
//

import Foundation

struct Recipe: Codable {
    let name: String
    let cuisine: String
    let largePhotoURL: String
    let smallPhotoURL: String
    let uuid: String
    let youtubeURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case cuisine
        case largePhotoURL = "photo_url_large"
        case smallPhotoURL = "photo_url_small"
        case uuid
        case youtubeURL = "youtube_url"
    }
}
struct Recipes : Codable {
    let recipes : [Recipe]
}

