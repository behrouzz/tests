//
//  TapView.swift
//  Simbad
//
//  Created by Behrouz Safari on 04/10/2023.
//

import SwiftUI

struct TapView: View {
    @State private var sqlString = "SELECT TOP 10 \nmain_id, ra, dec \nFROM basic"
    @State private var enableConnection = false
    @State private var showTapResults = false
    @State private var results = [[String: String]]()
    @State private var columns = [String]()
    @State private var selectedCatalog = "Simbad"
    
    let catalogNames = ["Simbad", "Gaia", "SDSS"]
    
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Catalog", selection: $selectedCatalog) {
                    ForEach(catalogNames, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                
                TextEditor(text: $sqlString)
                    .padding()
                    .foregroundColor(.black)
                    //.font(.custom("HelveticaNeue", size: 15))
                    .font(.system(size: 15, design: .monospaced))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.blue, lineWidth: 4)
                    )
                    .padding()
                
                NavigationLink {
                    // more to come
                } label: {
                    Text("Schema")
                }
            }
            
            .navigationTitle("ADQL Query")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        enableConnection = true
                        Task {
                            await callSimbad()
                        }
                    } label: {
                        Text("Submit")
                    }
                    .sheet(isPresented: $showTapResults) {
                        TapResultView(sqlString: $sqlString, enableConnection: $enableConnection, results: $results, columns: $columns)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        sqlString = ""
                    } label: {
                        Text("Clear")
                    }
                }
            }
        } //NavigationView
    } //body
    
    func callSimbad() async {
        if enableConnection {
            let contents = download(sql: sqlString)
            let a = decodeResults(contents: contents)
            columns = a.0
            results = a.1
            print(results)
            showTapResults.toggle()
        }
    }
    
}

#Preview {
    TapView()
}
