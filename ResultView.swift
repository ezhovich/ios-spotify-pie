//
//  ResultView.swift
//  SpotifyPie
//
//  Created by Serhii Trusov on 2023-05-18.
//

import SwiftUI

struct ResultView: View {
    
    let accessToken : String
    let term : String
    let category : String
    let api = API()
    let weights : [Font.Weight] = [.bold, .semibold, .medium, .regular, .regular, .regular, .regular, .regular, .regular, .regular]
    
    @State var topTracks : [String]? = nil
    @State var topArtists : [String]? = nil
    @State var topGenres : [String]? = nil
    @State var topGenresCount : [Double]? = nil
    
    @State var flag = false
    
    func refreshPie(){
        var _ = print("!!!", Date().timeIntervalSince1970)
        var _ = api.getPieStats(accessToken: accessToken, term: term){res, e in
            var tmpG : [String] = []
            var tmpC : [Double] = []
            let sortedByValueDictionary = res!.sorted { $0.1 > $1.1 }
            for (key, value) in sortedByValueDictionary{
                tmpG.append(key)
                tmpC.append(Double(value))
            }
            topGenres = tmpG
            topGenresCount = tmpC
        }
    }
    
    var body: some View {
        
        if category == "tracks"{
            var _ = api.getTopTracks(accessToken: accessToken, term: term){res, e in
                var tracks : [String] = []
                for e in res!{
                    tracks.append(e)
                }
                topArtists = nil
                topTracks = tracks
            }
            var _ = refreshPie()
        }
        
        if category == "artists"{
            var _ = api.getTopArtists(accessToken: accessToken, term: term){res, e in
                var artists : [String] = []
                for e in res!{
                    artists.append(e)
                }
                topArtists = artists
                topTracks = nil
            }
            var _ = refreshPie()
        }
        
        ScrollView{
            if topGenresCount != nil{
                PieChartView(values: Array(topGenresCount![0...9]),
                             names: Array(topGenres![0...9]),
                             formatter: {value in String(format: "$%.2f", value)},
                             backgroundColor: Color.white)
                .frame(height: 650)
            }
            
            if topTracks != nil{
                Text("Top 10 Tracks").font(.title)
                ForEach((0...9), id: \.self){
                    Text(topTracks![$0]).font(Font.caption.weight(weights[$0])).padding(1)
                }
            }
            
            if topArtists != nil{
                Text("Top 10 Artists").font(.title)
                ForEach((0...9), id: \.self){
                    Text(topArtists![$0]).font(Font.caption.weight(weights[$0])).padding(1)
                }
                
                
            }
        }
    }
    
    struct ResultView_Previews: PreviewProvider {
        static var previews: some View {
            ResultView(accessToken: "", term: "4 weeks", category: "artists")
        }
    }
}

