//
//  RealWarehouseRepository.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 13.05.2023.
//

import Foundation
import Combine

struct RealWarehouseRepository: WarehouseRepository {
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    
    func makeFullLoad() -> AnyPublisher<LoadInfo, Error> {
        call(endpoint: API.fullload)
    }
    
    func makeIncrementalLoad() -> AnyPublisher<LoadInfo, Error> {
        call(endpoint: API.newload)
    }
    
    func getAllWorksRecors() -> AnyPublisher<[FactWorks], Error> {
        call(endpoint: API.allworks)
    }
}

// MARK: - Endpoints

extension RealWarehouseRepository {
    enum API: String {
        case allworks
        case fullload
        case newload
    }
}

extension RealWarehouseRepository.API: APICall {
    var path: String {
        "/warehouse/\(self.rawValue)"
    }
    
    var method: String {
        switch self {
        case .allworks:
            return "GET"
        case .fullload, .newload:
            return "POST"
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    func body() throws -> Data? {
        return nil
    }
}
