//
//  MetadataView.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 18.05.2023.
//

import SwiftUI

struct MetadataView: View {
    let meta: OLTPMetadata
    
    var body: some View {
        Form {
            Section {
                Text("Database Name: \(meta.dbName)")
                Text("Is Connected: \(meta.isConnected ? "True" : "False")")
                
                ForEach(Array(meta.tablesInfo.keys), id: \.self) { key in
                    Text("\(key): \(meta.tablesInfo[key] ?? .zero)")
                }
            }
        }
    }
}

//struct MetadataView_Previews: PreviewProvider {
//    static var previews: some View {
//        MetadataView()
//    }
//}
