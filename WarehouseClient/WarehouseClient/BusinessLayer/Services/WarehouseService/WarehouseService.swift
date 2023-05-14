//
//  WarehouseService.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 13.05.2023.
//

import Foundation
import Combine

protocol WarehouseService {
    func makeFullLoad()
    func makeIncrementalLoad()
    
    func getAllWorksRecords()
}

struct MockWarehouseService: WarehouseService {
    func makeFullLoad() { }
    
    func makeIncrementalLoad() { }
    
    func getAllWorksRecords() { }
}
