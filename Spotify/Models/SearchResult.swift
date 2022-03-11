//
//  SearchResult.swift
//  Spotify
//
//  Created by mohamedSliem on 3/8/22.
//

import Foundation

enum SearchResults{
    case artist(model:Artist)
    case album(model : Album)
    case playlist(model : Playlist)
    case track(model : AudioTrack)
}
