//
//  RealWarehouseService.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 13.05.2023.
//

import Foundation
import Combine

struct RealWarehouseService: WarehouseService {
    let webRepository: WarehouseRepository
    let appState: Store<AppState>
    
    init(webRepository: WarehouseRepository, appState: Store<AppState>) {
        self.webRepository = webRepository
        self.appState = appState
    }
    
    func makeFullLoad() {
        let cancelBag = CancelBag()

        webRepository.makeFullLoad()
            .sink(receiveCompletion: { comp in
                switch comp {
                case let .failure(error):
                    print(error)
                default: break
                }
            }, receiveValue: { value in
                appState[\.userData.loadInfo] = value
            })
            .store(in: cancelBag)
    }
    
    func makeIncrementalLoad() {
        let cancelBag = CancelBag()

        webRepository.makeIncrementalLoad()
            .sink(receiveCompletion: { comp in
                switch comp {
                case let .failure(error):
                    print(error)
                default: break
                }
            }, receiveValue: { value in
                appState[\.userData.loadInfo] = value
            })
            .store(in: cancelBag)
    }
    
    func getAllWorksRecords() {
        let cancelBag = CancelBag()
        
        appState[\.userData.works].setIsLoading(cancelBag: cancelBag)
        
        webRepository
            .getAllWorksRecords()
            .sinkToLoadable { works in
                appState[\.userData.works] = works
            }
            .store(in: cancelBag)
    }
}
