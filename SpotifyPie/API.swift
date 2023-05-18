//
//  API.swift
//  SpotifyPie
//
//  Created by Serhii Trusov on 2023-05-17.
//

import Foundation

struct API{
    func getAccessToken(code: String, completionHandler: @escaping (String?, Error?) -> Void){
        let clientId = "d382f23bf98d4dd59bf022470da81d10"
        let secretKey = "61f207fd18ce4834a15e055d5fc02964"
        let authKey = "Basic \((clientId + ":" + secretKey).data(using: .utf8)!.base64EncodedString())"
        let requestHeaders: [String:String] = ["Authorization": authKey,
                                                "Content-Type": "application/x-www-form-urlencoded"]
        var requestComponents = URLComponents()
        requestComponents.queryItems = [URLQueryItem(name: "grant_type", value: "authorization_code"),
                                        URLQueryItem(name: "code", value: code),
                                        URLQueryItem(name: "redirect_uri", value: "https://pie-test-login/callback")]
        var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = requestComponents.query?.data(using: .utf8)
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let result = self.parseJSONGetAccessToken(authData: data!)
            completionHandler(result, nil)
        }.resume()
    }
    
    private func parseJSONGetAccessToken(authData: Data) -> String?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(AuthData.self, from: authData)
            return decodedData.access_token
        } catch {
            print(error)
        }
        return nil
    }
    
    func extractAuthorizationCode(from urlString: String) -> String? {
        guard let urlComponents = URLComponents(string: urlString),
              let queryItems = urlComponents.queryItems else {
            return nil
        }
        
        for queryItem in queryItems {
            if queryItem.name == "code" {
                return queryItem.value
            }
        }
        
        return nil
    }
    
    func getTopTracksData(accessToken: String, timeRange: String, completionHandler: @escaping (TopTracksData?, Error?) -> Void){
        var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/top/tracks?time_range=\(timeRange)")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let result = self.parseJSONTopTracks(topData: data!)
            completionHandler(result, nil)
        
        }.resume()
    }
    
    func getTopArtistsData(accessToken: String, timeRange: String, completionHandler: @escaping (TopArtistsData?, Error?) -> Void){
        var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/top/artists?time_range=\(timeRange)")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let result = self.parseJSONTopArtists(topData: data!)
            completionHandler(result, nil)
        
        }.resume()
    }
    
    
    private func parseJSONTopTracks(topData: Data) -> TopTracksData?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(TopTracksData.self, from: topData)
            return decodedData
        } catch {
            print(error)
        }
        return nil
    }
    
    private func parseJSONTopArtists(topData: Data) -> TopArtistsData?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(TopArtistsData.self, from: topData)
            return decodedData
        } catch {
            print(error)
        }
        return nil
    }
    
    func getTopTracks(accessToken: String, term: String, completionHandler: @escaping ([String]?, Error?) -> Void){
        var time_range = ""
        if term == "4 weeks"{
            time_range = "short_term"
        }
        if term == "6 months"{
            time_range = "medium_term"
        }
        if term == "2 years"{
            time_range = "long_term"
        }
        
        getTopTracksData(accessToken: accessToken, timeRange: time_range){res, error in
            var resTracks : [String] = []
            if let res = res{
                if let items = res.items{
                    for item in items{
                        resTracks.append((item.artists?[0].name!)! + " - " + item.name!)
                    }
                    completionHandler(resTracks, nil)
                }
                
            }
        }
    }
    
    func getTopArtists(accessToken: String, term: String, completionHandler: @escaping ([String]?, Error?) -> Void){
        var time_range = ""
        if term == "4 weeks"{
            time_range = "short_term"
        }
        if term == "6 months"{
            time_range = "medium_term"
        }
        if term == "2 years"{
            time_range = "long_term"
        }
        
        getTopArtistsData(accessToken: accessToken, timeRange: time_range){res, error in
            var resTracks : [String] = []
            if let res = res{
                if let items = res.items{
                    for item in items{
                        resTracks.append(item.name!)
                    }
                    completionHandler(resTracks, nil)
                }
                
            }
        }
    }
    
    func getPieStats(accessToken: String, term: String, completionHandler: @escaping ([String: Int]?,  Error?) -> Void){
        var time_range = ""
        if term == "4 weeks"{
            time_range = "short_term"
        }
        if term == "6 months"{
            time_range = "medium_term"
        }
        if term == "2 years"{
            time_range = "long_term"
        }
        
        getTopArtistsData(accessToken: accessToken, timeRange: time_range){res, error in
            var resGenres : [String : Int] = [:]
            if let res = res{
                if let items = res.items{
                    for item in items{
                        for genre in item.genres!{
                            if !(resGenres.keys.contains(genre)){
                                resGenres[genre] = 0
                            }
                            resGenres[genre]! += 1
                        }
                    }
                }
            }
            completionHandler(resGenres, nil)
        }
    }
    
}
