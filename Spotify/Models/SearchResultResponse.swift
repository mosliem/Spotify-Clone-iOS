//
//  searchResultResponse.swift
//  Spotify
//
//  Created by mohamedSliem on 3/8/22.
//

import Foundation
//
//struct NewRealesesResponse : Codable {
//    let albums :albumsResponse
//}
//
//struct albumsResponse : Codable {
//    let items : [Album]
//}


//struct Album : Codable {
//    let album_type : String
//    let artists : [Artist]
//    let id : String
//    let images : [APIImage]
//    let name :String
//    let release_date : String
//    let total_tracks :Int
//    let available_markets : [String]
//}
struct SearchResultResponse:Codable {
    let albums : SearchAlbumsResultResponse
    let artists : SearchArtistsResultResponse
    let playlists : SearchPlaylistResultResponse
    let tracks : SearchTracksDetailsResponse
}

struct SearchPlaylistResultResponse:Codable {
    let items : [Playlist]
}
struct SearchArtistsResultResponse:Codable {
    let items :[Artist]
}

struct SearchTracksDetailsResponse:Codable {
    let items:[AudioTrack]
}

struct SearchAlbumsResultResponse:Codable {
    let items:[Album]
}
