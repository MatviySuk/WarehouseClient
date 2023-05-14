//
//  Employee.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 13.05.2023.
//

import Foundation

struct Employee: Codable, Identifiable {
    let id: Int
    let role: Role
    let fullName: String
    let birthday: String
    let email: String
    let phone: String
}
