//
//  WarehouseRepository.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 08.05.2023.
//

import Foundation
import Combine

protocol WarehouseRepository: WebRepository {
    func makeFullLoad() -> AnyPublisher<LoadInfo, Error>
    func makeIncrementalLoad() -> AnyPublisher<LoadInfo, Error>
    
    func getAllWorksRecors() -> AnyPublisher<[FactWorks], Error>
}