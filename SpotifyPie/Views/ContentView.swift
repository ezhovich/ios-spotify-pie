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
    
    @State private var isPresented = false
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
                    }.pickerStyle(.segmented)
                } header: {
                    Text("pie based on")
                }
                
                Section{
                    Picker("term", selection: $selectedTerm){
                        ForEach(terms, id: \.self){ term in
                            Text(term)
                        }
                    }.pickerStyle(.segmented)
                } header: {
                    Text("within last ")
                }
                
                
                Section{
                    HStack{
                        Spacer()
                        if accessToken != nil{
                            Button{
                                print("PIE:")
                                isPiePresented = true
                            } label: {
                                HStack{
                                    Spacer()
                                    Text("Bake!")
                                    Spacer()
                                }
                            }
                        } else {
                            Button{
                                isPresented = true
                            } label: {
                                Text("Login to spotify")
                            }
                            .tint(.green)
                            Spacer()
                        }
                    }
                }
                
                if isPiePresented{
                    ResultView(accessToken: accessToken!, term: selectedTerm, category: selectedCategory)
                    var _ = print("!!")
                }
                
            
            }
        }.sheet(isPresented: $isPresented) {
            AuthView(isPresented: $isPresented, accessToken: $accessToken)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
