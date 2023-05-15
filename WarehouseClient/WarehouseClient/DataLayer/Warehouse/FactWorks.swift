//
//  FactWorks.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 13.05.2023.
//

import Foundation

struct FactWorks: Codable, Identifiable, Hashable {
    let id: Int
    let project: Project
    let startDate: DimDate
    let endDate: DimDate
    let employee: Employee
    let workedTimeMinutes: Int
    let estimatedTimeMinutes: Int
    let delayedTimeMinutes: Int
    let totalWorksCount: Int
    let successfulWorksCount: Int
    let delayedWorksCount: Int
    let failedWorksCount: Int
}

extension FactWorks: Equatable {
    static func == (lhs: FactWorks, rhs: FactWorks) -> Bool {
        lhs.id == rhs.id
    }
}

extension FactWorks: Comparable {
    static func < (lhs: FactWorks, rhs: FactWorks) -> Bool {
        lhs.id < rhs.id
    }
}
