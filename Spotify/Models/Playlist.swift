//
//  Playlist.swift
//  Spotify
//
//  Created by mohamedSliem on 1/29/22.
//

import Foundation

struct Playlist : Codable {
    let name : String
    let description : String
    let external_urls : [String : String]
    let id : String
    let images : [APIImage]
    let type : String
    let owner : Owner
    let tracks : Track
}
struct Owner : Codable {
    let display_name : String
    let external_urls : [String : String]
    let id : String
}
