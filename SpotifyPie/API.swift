//
//  API.swift
//  SpotifyPie
//
//  Created by Serhii Trusov on 2023-05-17.
//

import Foundation

struct API{
    func getAccessToken(code: String, completionHandler: @escaping (String?, Error?) -> Void){
        let clientId = ""
        let secretKey = ""
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
    
    
    func getStats(accessToken: String, term: String) async -> ([String], [String], [String], [Double]){
        var timeRange = ""
        if term == "4 weeks"{
            timeRange = "short_term"
        }
        if term == "6 months"{
            timeRange = "medium_term"
        }
        if term == "2 years"{
            timeRange = "long_term"
        }
        
        var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/top/artists?time_range=\(timeRange)")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let (dataArtists, _) = try! await URLSession.shared.data(for: request)
        
        request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/top/tracks?time_range=\(timeRange)")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let (dataTracks, _) = try! await URLSession.shared.data(for: request)
        
        var topTracks : [String] = []
        let tracksEncoded = self.parseJSONTopTracks(topData: dataTracks)
        if let items = tracksEncoded?.items{
            for item in items{
                topTracks.append((item.artists?[0].name!)! + " - " + item.name!)
            }
        }
        
        var topArtists : [String] = []
        var topGenresDict : [String : Int] = [:]
        let artistsEncoded = self.parseJSONTopArtists(topData: dataArtists)
        if let items = artistsEncoded?.items{
            for item in items {
                topArtists.append(item.name!)
                for genre in item.genres!{
                    if !(topGenresDict.keys.contains(genre)){
                        topGenresDict[genre] = 0
                    }
                    topGenresDict[genre]! += 1
                }
            }
        }
        
        var topGenres : [String] = []
        var topGenresCount : [Double] = []
        let sortedByValueDictionary = topGenresDict.sorted { $0.1 > $1.1 }
        for (key, value) in sortedByValueDictionary{
            topGenres.append(key)
            topGenresCount.append(Double(value))
        }
        
        return (topTracks, topArtists, topGenres, topGenresCount)
        
    }
}
