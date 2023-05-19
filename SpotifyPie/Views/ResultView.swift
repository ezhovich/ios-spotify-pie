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
    @State var refreshFlag: Bool = false
    
    
    func refreshPie(){
        api.getPieStats(accessToken: accessToken, term: term){res, e in
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
        api.getTopTracks(accessToken: accessToken, term: term){res, e in
            var tracks : [String] = []
            for e in res!{
                tracks.append(e)
            }
            topTracks = tracks
            print(tracks)
        }
        api.getTopArtists(accessToken: accessToken, term: term){res, e in
            var artists : [String] = []
            for e in res!{
                artists.append(e)
            }
            topArtists = artists
        }
    }
    
    var body: some View {
        
        ScrollView{
            if topGenresCount != nil{
                PieChartView(values: Array(topGenresCount![0...9]),
                             names: Array(topGenres![0...9]),
                             formatter: {value in String(format: "$%.2f", value)},
                             backgroundColor: Color.white)
                .frame(height: 650)
            }
            
            if topTracks != nil && category == "tracks"{
                Text("Top 10 Tracks").font(.title)
                ForEach((0...9), id: \.self){
                    Text(topTracks![$0]).font(Font.caption.weight(weights[$0])).padding(1)
                }
            }
            
            if topArtists != nil && category == "artists"{
                Text("Top 10 Artists").font(.title)
                ForEach((0...9), id: \.self){
                    Text(topArtists![$0]).font(Font.caption.weight(weights[$0])).padding(1)
                }
                
                
            }
        }.onChange(of: term){ _ in
            refreshFlag.toggle()
        }.onChange(of: category){ _ in
            refreshFlag.toggle()
        }.onChange(of: refreshFlag){ _ in
            refreshPie()
        }
        .onAppear{
            refreshFlag.toggle()
        }
    }
    
    struct ResultView_Previews: PreviewProvider {
        static var previews: some View {
            ResultView(accessToken: "", term: "4 weeks", category: "artists")
        }
    }
}

