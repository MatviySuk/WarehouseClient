//
//  OLTPMetadata.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 18.05.2023.
//

import Foundation

struct OLTPMetadata: Codable, Equatable {
    let dbName: String
    let isConnected: Bool
    let tablesInfo: [String : Int]
}
