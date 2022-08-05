//
//  Artist.swift
//  Spotify
//
//  Created by mohamedSliem on 1/29/22.
//

import Foundation

struct Artist : Codable {
    let id : String
    let name : String
    let type : String
    let images: [APIImage]?
    let external_urls : [String : String]
}
