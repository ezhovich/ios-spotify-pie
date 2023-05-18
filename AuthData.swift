//
//  AuthData.swift
//  SpotifyPie
//
//  Created by Serhii Trusov on 2023-05-17.
//

import Foundation

struct AuthData: Decodable {
    let access_token : String
    let token_type : String
    
}
