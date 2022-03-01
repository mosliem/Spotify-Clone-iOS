//
//  FeaturedPlaylistResponse.swift
//  Spotify
//
//  Created by mohamedSliem on 2/11/22.
//

import Foundation


struct FeaturedPlaylistResponse:Codable {
    let playlists : PlaylistResponse
}

struct PlaylistResponse:Codable {
    let items : [Playlist]
}

struct Track : Codable {
    let total : Int
}

