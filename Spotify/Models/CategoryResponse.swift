//
//  CategoryResponse.swift
//  Spotify
//
//  Created by mohamedSliem on 3/5/22.
//

import Foundation

struct CategoryResponse:Codable {
    let categories : CategoryObjectResponse
}

struct CategoryObjectResponse:Codable {
  let items : [ObjectItemsResponse]
}
struct ObjectItemsResponse : Codable {
    let icons : [APIImage]
    let id : String
    let name : String
}

