//
//  ContentView.swift
//  SpotifyPie
//
//  Created by Serhii Trusov on 2023-05-17.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTerm = "6 months"
    @State var selectedCategory = "tracks"
    let terms = ["4 weeks", "6 months", "2 years"]
    let categories = ["tracks", "artists"]
    
    let spotifyGreen = Color(red: 0.114, green: 0.725, blue: 0.329) // #1db954
    let spotifyGray = Color(red: 0.129, green: 0.129, blue: 0.129) // #212121)
    
    @State private var isAuthPresented = false
    @State var accessToken : String? = nil
    @State var isPiePresented = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                
                Section{
                    Picker("category", selection: $selectedCategory){
                        ForEach(categories, id: \.self){ category in
                            Text(category)
                        }
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(spotifyGreen)
                    .tint(.white)
                } header: {
                    Text("pie based on")
                        .foregroundColor(Color.black)
                }
                
                Section{
                    Picker("term", selection: $selectedTerm){
                        ForEach(terms, id: \.self){ term in
                            Text(term)
                                .foregroundColor(Color.white)
                        }
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(spotifyGreen)
                } header: {
                    Text("within last ")
                        .foregroundColor(Color.black)
                }
                
                Spacer()
                Spacer()

                
                Section{
                    HStack{
                        Spacer()
                        if accessToken != nil{
                            Button{
                                print("PIE:")
                                isPiePresented = true
                            } label: {
                                Text("Bake!")
                            }
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(spotifyGray)
                            .tint(spotifyGreen)
                            Spacer()
                        } else {
                            Button{
                                isAuthPresented = true
                            } label: {
                                Text("Login to spotify")
                            }
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(spotifyGray)
                            .tint(spotifyGreen)
                            Spacer()
                        }
                    }
                }
                if isPiePresented{
                    ResultView(accessToken: accessToken!, term: selectedTerm, category: selectedCategory)
                }
            }.background(.white)
        }.sheet(isPresented: $isAuthPresented) {
            AuthView(isPresented: $isAuthPresented, accessToken: $accessToken)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
