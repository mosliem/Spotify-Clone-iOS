//
//  Album.swift
//  Spotify
//
//  Created by mohamedSliem on 2/11/22.
//

import Foundation

struct Album : Codable {
    let album_type : String
    let artists : [Artist]
    let id : String
    let images : [APIImage]
    let name :String
    let release_date : String
    let total_tracks :Int
    let available_markets : [String]
}
