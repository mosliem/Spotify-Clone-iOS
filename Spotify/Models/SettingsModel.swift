//
//  SettingsModel.swift
//  Spotify
//
//  Created by mohamedSliem on 2/7/22.
//

import Foundation

struct Section {
    
    let title : String
    let options : [Options]
}

struct  Options {
    let title : String
    let handler : () -> Void
}
