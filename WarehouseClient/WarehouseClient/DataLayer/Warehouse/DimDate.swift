//
//  DimDate.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 13.05.2023.
//

import Foundation

struct DimDate: Codable, Identifiable, Hashable {
    let id: Int
    let year: Int
    let month: Int
    let day: Int
    
    var date: Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        guard let date = Calendar.current.date(from: dateComponents) else {
            fatalError("Invalid date components")
        }
        
        return date
    }
    
    var incrementedMonthDate: DimDate {
        var month = self.month
        var year = self.year
        
        if month == 12 {
            month = 1
            year += 1
        } else {
            month += 1
        }
        
        return .init(id: id, year: year, month: month, day: self.day)
    }
    
    var dateTitle: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL YYYY"
        return dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date)
    }
    
    var text: String {
        "\(day < 10 ? "0" : "")\(day).\(month < 10 ? "0" : "")\(month).\(year)"
    }
    
    init(id: Int, year: Int, month: Int, day: Int) {
        self.id = id
        self.year = year
        self.month = month
        self.day = day
    }
}

extension DimDate: Comparable {
    static func < (lhs: DimDate, rhs: DimDate) -> Bool {
        (lhs.year < rhs.year)
        || ((lhs.year == rhs.year) && (lhs.month < rhs.month))
        || ((lhs.year == rhs.year) && (lhs.month == rhs.month) && (lhs.day < rhs.day))
    }
}
