//
//  Project.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 13.05.2023.
//

import Foundation

struct Project: Codable, Identifiable {
    let id: Int
    let projectManager: Employee
    let industry: Industry
    let name: String
    let description: String
    let category: String
}
