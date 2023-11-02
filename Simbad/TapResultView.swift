//
//  TapResultView.swift
//  Simbad
//
//  Created by Behrouz Safari on 04/10/2023.
//

import SwiftUI

struct TapResultView: View {
    @Binding var sqlString: String
    @Binding var enableConnection: Bool
    @Binding var results: [[String: String]]
    @Binding var columns: [String]
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(results, id: \.self) { dc in
                    ForEach(columns, id: \.self) { k in
                        HStack {
                            Text("\(k)")
                                .font(.headline)
                                .frame(alignment: .leading)
                            Text("\(dc[k, default: "NA"])")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .listRowSeparator(.hidden)
                    }
                    Divider()
                }
            }
            .environment(\.defaultMinListRowHeight, 0)
            
            .navigationTitle("Query results: \(results.count)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Dismiss")
                    }
                }
            }
            
        }
    }
}

/*
#Preview {
    TapResultView(results: results)
}

*/
