//
//  AlbumDetailsResponse.swift
//  Spotify
//
//  Created by mohamedSliem on 2/26/22.
//

import Foundation
struct AlbumDetailsResponse : Codable {
    let album_type : String
    let artists : [Artist]
    let available_markets : [String]
    let external_urls : [String : String]
    let id : String
    let images : [APIImage]
    let label : String
    let name : String
    let release_date : String
    let total_tracks : Int
    let tracks : TracksDetailsResponse
    
}

struct TracksDetailsResponse : Codable {
    let items:[AudioTrack]
}

