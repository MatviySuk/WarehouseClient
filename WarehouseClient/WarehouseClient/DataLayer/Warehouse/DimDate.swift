//
//  DimDate.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 13.05.2023.
//

import Foundation

struct DimDate: Codable, Identifiable {
    let id: Int
    let year: Int
    let month: Int
    let day: Int
//    let date: Date
    
    init(id: Int, year: Int, month: Int, day: Int) {
        self.id = id
        self.year = year
        self.month = month
        self.day = day
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        guard let date = Calendar.current.date(from: dateComponents) else {
            fatalError("Invalid date components")
        }
        
//        self.date = date
    }
}
