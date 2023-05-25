//
//  ResultView.swift
//  SpotifyPie
//
//  Created by Serhii Trusov on 2023-05-18.
//

import SwiftUI

class ResultViewModel: ObservableObject{
    @Published var topTracks : [String]? = nil
    @Published var topArtists : [String]? = nil
    @Published var topGenres : [String]? = nil
    @Published var topGenresCount : [Double]? = nil
    let api = API()
    
    func refreshPie(accessToken: String, term: String) async{
        let (topTracks, topArtists, topGenres, topGenresCount) = await api.getStats(accessToken: accessToken, term: term)
        await MainActor.run{
            self.topTracks = topTracks
            self.topArtists = topArtists
            self.topGenres = topGenres
            self.topGenresCount = topGenresCount
        }
    }
    
}


struct ResultView: View {
    
    @StateObject private var viewModel = ResultViewModel()
    
    let accessToken : String
    let term : String
    let category : String
    let api = API()
    let weights : [Font.Weight] = [.bold, .semibold, .medium, .regular, .regular, .regular, .regular, .regular, .regular, .regular]
    
    @State var refreshFlag: Bool = false
    
    var body: some View {
        
        ScrollView{
            
            if viewModel.topGenresCount != nil{
                PieChartView(values: Array(viewModel.topGenresCount![0...9]),
                             names: Array(viewModel.topGenres![0...9]),
                             formatter: {value in String(format: "$%.2f", value)},
                             backgroundColor: Color.white)
                .frame(height: 650)
            }
            
            if viewModel.topTracks != nil && category == "tracks"{
                Text("Top 10 Tracks").font(.title)
                ForEach((0...9), id: \.self){
                    Text(viewModel.topTracks![$0]).font(Font.caption.weight(weights[$0])).padding(1)
                }
            }
            
            if viewModel.topArtists != nil && category == "artists"{
                Text("Top 10 Artists").font(.title)
                ForEach((0...9), id: \.self){
                    Text(viewModel.topArtists![$0]).font(Font.caption.weight(weights[$0])).padding(1)
                }
                
                
            }
        }.onChange(of: term){ _ in
            refreshFlag.toggle()
        }.onChange(of: category){ _ in
            refreshFlag.toggle()
        }.onChange(of: refreshFlag){ _ in
            Task{
                await viewModel.refreshPie(accessToken: accessToken, term: term)
            }
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

