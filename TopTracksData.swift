//
//  TopTracksData.swift
//  SpotifyPie
//
//  Created by Serhii Trusov on 2023-05-18.
//

import Foundation

struct TopTracksData: Decodable{
    let href : String?
    let limit : Int?
    let next : String?
    let offset : Int?
    let previous : String?
    let total : Int?
    let items : [TrackObject]?
}

struct TrackObject: Decodable{
    let album: Album?
    let artists: [ArtistsObject]?
    let available_markets: [String]?
    let disc_number: Int?
    let duration_ms: Int?
    let explicit: Bool?
    let external_ids: ExternalIDs?
    let external_urls: ExternalUrls?
    let href: String?
    let id: String?
    let is_playable: Bool?
    let linked_from: String?
    let restrictions: Restriction?
    let name: String?
    let popularity: Int?
    let preview_url: String?
    let track_number: Int?
    let type: String?
    let uri: String?
    let is_local: Bool?
    
}

struct Album: Decodable{
    let album_type: String?
    let total_tracks: Int?
    let available_markets: [String]?
    let external_urls: [String: String]?
    let href: String?
    let id: String?
    let images: [SpotifyImage]?
    let name: String?
    let release_date: String?
    let release_date_precision: String?
    let restrictions: Restriction?
    let type: String?
    let uri: String?
    let copyrights: [Copyrights]?
    let external_ids: ExternalIDs?
    let genres: [String]?
    let label: String?
    let popularity: Int?
    let album_group: String?
    let artists: [SimplifiedArtistObject]
}

struct SpotifyImage: Decodable{
    let url: String?
    let height: Int?
    let width: Int?
}

struct Restriction: Decodable{
    let reason: String?
}

struct Copyrights: Decodable{
    let text: String?
    let type: String?
}

struct ExternalIDs: Decodable{
    let isrc: String?
    let ean: String?
    let upc: String?
}

struct SimplifiedArtistObject: Decodable{
    let external_urls: ExternalUrls?
    let href: String?
    let id: String?
    let name: String?
    let type: String?
    let uri: String?
}

struct ExternalUrls: Decodable{
    let spotify: String?
}

struct ArtistsObject: Decodable{
    let external_urls: ExternalUrls?
    let followers: Followers?
    let genres: [String]?
    let href: String?
    let id: String?
    let images: [SpotifyImage]?
    let name: String?
    let popularity: Int?
    let type: String?
    let uri: String?
}

struct Followers: Decodable{
    let href: String?
    let total: Int?
}
