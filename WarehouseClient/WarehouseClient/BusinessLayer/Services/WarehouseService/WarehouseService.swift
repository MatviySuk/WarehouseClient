//
//  WarehouseService.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 13.05.2023.
//

import Foundation
import Combine

protocol WarehouseService {
    func makeFullLoad(cancelBag: CancelBag)
    func makeIncrementalLoad(cancelBag: CancelBag)
    func makeCleanUp(cancelBag: CancelBag)
    
    func getAllWorksRecords(cancelBag: CancelBag)
}

struct MockWarehouseService: WarehouseService {
    func makeFullLoad(cancelBag: CancelBag) { }
    
    func makeIncrementalLoad(cancelBag: CancelBag) { }
    
    func makeCleanUp(cancelBag: CancelBag) { }
    
    func getAllWorksRecords(cancelBag: CancelBag) { }
}
