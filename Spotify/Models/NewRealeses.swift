//
//  NewRealeses.swift
//  Spotify
//
//  Created by mohamedSliem on 2/8/22.
//

import Foundation

struct NewRealesesResponse : Codable {
    let albums :albumsResponse
}

struct albumsResponse : Codable {
    let items : [Album]
}


