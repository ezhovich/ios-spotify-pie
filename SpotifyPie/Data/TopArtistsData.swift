//
//  TopArtistsData.swift
//  SpotifyPie
//
//  Created by Serhii Trusov on 2023-05-18.
//

import Foundation

struct TopArtistsData: Decodable{
    let href : String?
    let limit : Int?
    let next : String?
    let offset : Int?
    let previous : String?
    let total : Int?
    let items : [ArtistObject]?
}

struct ArtistObject: Decodable{
    let external_urls: ExternalUrls?
    let followers: Followers?
    let genres: [String]?
    let href: String?
    let id: String?
    let images : [SpotifyImage]?
    let name: String?
    let popularity: Int?
    let type : String?
    let uri: String?
}
