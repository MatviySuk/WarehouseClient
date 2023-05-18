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
    @Published var metadata: OLTPMetadata? = nil
    @Published var dates: [DimDate] = []
    @Published var selectedSortOrder: KeyPathComparator<FactWorks> = KeyPathComparator(\FactWorks.startDate)
    
    @Published var datesIndicesRange: ClosedRange<Int> = 0...1
    @Published var totalMinsRange: ClosedRange<Int> = 0...10
    @Published var estMinsRange: ClosedRange<Int> = 0...10
    @Published var delayMinsRange: ClosedRange<Int> = 0...10
    @Published var totalWorksRange: ClosedRange<Int> = 0...10
    @Published var successWorksRange: ClosedRange<Int> = 0...10
    @Published var delayWorksRange: ClosedRange<Int> = 0...10
    @Published var failedWorksRange: ClosedRange<Int> = 0...10

    
    let sortOrder: [SortOrder] = [
        .init("Time Period", KeyPathComparator(\FactWorks.startDate)),
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
                        datesIndicesRange = .zero...(dates.count - 1)
                        
                        setUpRanges()
                    default:
                        self.works = value
                    }
                }
            
            container.appState.updates(for: \.userData.loadInfo)
                .sink { [weak self] value in
                    self?.loadInfo = value
                }
            
            container.appState.updates(for: \.userData.oltpMetadata)
                .sink { [weak self] value in
                    self?.metadata = value
                }
        }
    }
    
    // MARK: - Filters
    
    func setUpRanges() {
        datesIndicesRange = datesLimit()
        totalMinsRange = limit(keyPath: \.workedTimeMinutes)
        estMinsRange = limit(keyPath: \.estimatedTimeMinutes)
        delayMinsRange = limit(keyPath: \.delayedTimeMinutes)
        totalWorksRange = limit(keyPath: \.totalWorksCount)
        successWorksRange = limit(keyPath: \.successfulWorksCount)
        delayWorksRange = limit(keyPath: \.delayedWorksCount)
        failedWorksRange = limit(keyPath: \.failedWorksCount)
    }
    
    func datesLimit() -> ClosedRange<Int> {
        let max = dates.count - 1
        return .zero...(max > 0 ? max : 1)
    }
    
    func limit<T: Numeric>(keyPath: KeyPath<FactWorks, T>) -> ClosedRange<T> {
        let values = works.value?.map { $0[keyPath: keyPath] }
        
        if let min = values?.min(),
           let max = values?.max() {
            return min...max
        }
        
        return T.zero...(T.zero + 1)
    }
    
    func filteredWorks(_ works: [FactWorks]) -> [FactWorks] {
        works
            .filter { work in
                (work.endDate <= dates[datesIndicesRange.upperBound].incrementedMonthDate)
                && (work.startDate >= dates[datesIndicesRange.lowerBound])
                && totalMinsRange.contains(work.workedTimeMinutes)
                && estMinsRange.contains(work.estimatedTimeMinutes)
                && delayMinsRange.contains(work.delayedTimeMinutes)
                && totalWorksRange.contains(work.totalWorksCount)
                && successWorksRange.contains(work.successfulWorksCount)
                && delayWorksRange.contains(work.delayedWorksCount)
                && failedWorksRange.contains(work.delayedWorksCount)
            }
    }
    
    func reloadWorks() {
        container.services.warehouseService.getAllWorksRecords(cancelBag: cancelBag)
    }
}
