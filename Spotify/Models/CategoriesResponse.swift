//
//  CategoryResponse.swift
//  Spotify
//
//  Created by mohamedSliem on 3/5/22.
//

import Foundation

struct CategoriesResponse:Codable {
    let categories : CategoriesObjectResponse
}

struct CategoriesObjectResponse:Codable {
  let items : [Category]
}
struct Category : Codable {
    let icons : [APIImage]
    let id : String
    let name : String
}

