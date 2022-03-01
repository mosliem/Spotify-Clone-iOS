//
//  UserProfile.swift
//  Spotify
//
//  Created by mohamedSliem on 1/29/22.
//

import Foundation

struct UserProfile :Codable {
    let country : String
    let display_name : String
    let email : String
    let explicit_content : [String : Bool]
    let external_urls : [String : String]
    let id : String
    let product : String
    let images : [APIImage]
}


