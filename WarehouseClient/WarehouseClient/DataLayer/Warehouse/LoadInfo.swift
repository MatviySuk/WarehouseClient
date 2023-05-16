//
//  LoadInfo.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 13.05.2023.
//

import Foundation

struct LoadInfo: Codable, Identifiable, Equatable {
    let id = UUID()
    let rowsAffected: Int
    let loadTime: String
}
