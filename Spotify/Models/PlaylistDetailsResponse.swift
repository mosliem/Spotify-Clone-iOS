


import Foundation

struct PlaylistDetailsResponse :Codable {
    let description : String
    let external_urls :[String:String]
    let name : String
    let images : [APIImage]
    let id : String
    let tracks : PlaylistTracksDetailsResponse
}
struct PlaylistTracksDetailsResponse : Codable {
    let items: [PlaylistResponseItem]
}

struct PlaylistResponseItem : Codable {
    let track : AudioTrack?
}
