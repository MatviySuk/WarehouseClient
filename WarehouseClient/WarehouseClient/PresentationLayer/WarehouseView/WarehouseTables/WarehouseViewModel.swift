//
//  WarehouseViewModel.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 13.05.2023.
//

import Foundation

final class WarehouseViewModel: ViewModel {
    // MARK: - Types
    
    struct SortOrder<T>: Hashable, Identifiable {
        let id = UUID()
        let name: String
        let order: KeyPathComparator<T>
        
        init(_ name: String, _ order: KeyPathComparator<T>) {
            self.name = name
            self.order = order
        }
        
        static func == (lhs: WarehouseViewModel.SortOrder<Any>, rhs: WarehouseViewModel.SortOrder<Any>) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    @Published var works: Loadable<[FactWorks]> = .notRequested
    @Published var loadInfo: LoadInfo? = nil
    @Published var selectedDate: DimDate = DimDate(id: 0, year: 2023, month: 1, day: 1)
    @Published var dates: [DimDate] = []
    @Published var selectedSortOrder: KeyPathComparator<FactWorks> = KeyPathComparator(\FactWorks.project.name)

    
    let sortOrder: [SortOrder] = [
        .init("Project Name", KeyPathComparator(\FactWorks.project.name)),
        .init("Employee Name", KeyPathComparator(\FactWorks.employee.fullName)),
        .init("Total Minutes", KeyPathComparator(\FactWorks.workedTimeMinutes)),
        .init("Estimated Minutes", KeyPathComparator(\FactWorks.estimatedTimeMinutes)),
        .init("Delayed Minutes", KeyPathComparator(\FactWorks.delayedTimeMinutes)),
        .init("Total Works", KeyPathComparator(\FactWorks.totalWorksCount)),
        .init("Successful Works", KeyPathComparator(\FactWorks.successfulWorksCount)),
        .init("Delayed Works", KeyPathComparator(\FactWorks.delayedWorksCount)),
        .init("Failed Works", KeyPathComparator(\FactWorks.failedWorksCount))
    ]

    override init(container: DIContainer) {
        super.init(container: container)
        
        cancelBag.collect {
            container.appState.updates(for: \.userData.works)
                .sink { [weak self] value in
                    guard let self = self else { return }
                    
                    switch value {
                    case let .loaded(works):
                        self.works = .loaded(works.sorted(using: self.selectedSortOrder))
                        self.dates = Array(Set(works.flatMap { [$0.startDate, $0.endDate] })).sorted().dropLast(1)
                        if let last = self.dates.last {
                            self.selectedDate = last
                        }
                    default:
                        self.works = value
                    }
                }
            
            container.appState.updates(for: \.userData.loadInfo)
                .sink { [weak self] value in
                    self?.loadInfo = value
                }
        }
    }
    
    func reloadWorks() {
        container.services.warehouseService.getAllWorksRecords(cancelBag: cancelBag)
    }
}
