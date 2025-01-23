//
//  MockNetetworkService.swift
//  FetchTest
//
//  Created by ravinder vatish on 1/22/25.
//

@testable import FetchTest
import Foundation
import SwiftUI

class MockNetworkService : NetworkServiceProtocol {
    let url1 = "https://fetchTest.com/image1.jpg"
    let url2 = "https://fetchTest.com/image2.jpg"
    let url3 = "https://fetchTest.com/image3.jpg"
    
    func getRecipes() async -> [Recipe] {
       [
        Recipe(name: "chicken curry", cuisine: "Indian", largePhotoURL: "https://fetchTest.com/chicken_curry", smallPhotoURL: "", uuid: "1", youtubeURL: ""),
        Recipe(name: "Medium Rare Ribeye", cuisine: "American", largePhotoURL: "https://fetchTest.com/ribeye", smallPhotoURL: "", uuid: "1", youtubeURL: "")
        ]
    }

    func getImage(url: String) async -> Data? {
        if( url == "https://fetchTest.com/ribeye") {
            return UIImage(named: "ribeye")?.pngData()
        }
        else {
            return nil
        }
    }
}
