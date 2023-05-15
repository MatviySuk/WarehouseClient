//
//  WarehouseChartsView.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 15.05.2023.
//

import SwiftUI
import Charts

struct WarehouseChartsView: View {
    @ObservedObject private(set) var viewModel: WarehouseChartsViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                worksContent
            }.navigationTitle("Charts")
        }
    }
    
    @ViewBuilder private var worksContent: some View {
        switch viewModel.works {
        case .notRequested:
            worksNotRequestedView
        case let .isLoading(last, _):
            worksLoadingView(last)
        case let .loaded(works):
            worksLoadedView(works)
        case let .failed(error):
            worksFailedView(error)
        }
    }
}

// MARK: - Loading Content

private extension WarehouseChartsView {
    var worksNotRequestedView: some View {
        Text("").onAppear(perform: self.viewModel.reloadWorks)
    }
    
    func worksLoadingView(_ previouslyLoaded: [FactWorks]?) -> some View {
        if let works = previouslyLoaded {
            return AnyView(worksLoadedView(works))
        } else {
            return AnyView(ActivityIndicatorView().padding())
        }
    }
    
    func worksFailedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            self.viewModel.reloadWorks()
        })
    }
}


// MARK: - Displaying Content

private extension WarehouseChartsView {
    func worksLoadedView(_ works: [FactWorks]) -> some View {
        func employeeWorksCountChart(_ projectWorks: [FactWorks], _ projectEmployees: [Employee]) -> some View {
            Chart {
                ForEach(projectEmployees) { employee in
                    let filterWorks = projectWorks.filter { $0.employee == employee }
                    
                    BarMark(
                        x: .value("Employee Name", employee.fullName),
                        y: .value("successfulWorksCount", filterWorks.map { $0.successfulWorksCount }.reduce(0, +))
                    ).foregroundStyle(by: .value("Work Result", "Successful Works"))
                    
                    BarMark(
                        x: .value("Employee Name", employee.fullName),
                        y: .value("failedWorksCount", filterWorks.map { $0.failedWorksCount }.reduce(0, +))
                    ).foregroundStyle(by: .value("Work Result", "Failed Works"))
                }
            }
        }
        
        func employeeDelayedTimeChart(_ projectWorks: [FactWorks], _ projectEmployees: [Employee]) -> some View {
            Chart {
                ForEach(projectEmployees) { employee in
                    let filterWorks = projectWorks.filter { $0.employee == employee }
                    
                    AreaMark(
                        x: .value("Employee Name", employee.fullName),
                        y: .value("Delayed Time Minutes", filterWorks.map { $0.delayedTimeMinutes }.reduce(0, +))
                    ).foregroundStyle(by: .value("Delayed Time Minutes", "Delayed Time Minutes"))
                }
                
                RuleMark(y: .value("Average Delay", (projectWorks.map { $0.delayedTimeMinutes }.reduce(0, +) / projectEmployees.count)))
                    .foregroundStyle(by: .value("Average Delated Time", "Average Delated Time"))
            }
        }
        
        var employeesCharts: some View {
            VStack {
                ForEach(works.map { $0.project }.unique()) { project in
                    let projectWorks = works.filter { $0.project == project }
                    let projectEmployees = projectWorks.map { $0.employee }.unique()
                    
                    VStack {
                        Text("Project - \(project.name)")
                            .font(.largeTitle)
                            .bold()
                        
                        VStack(spacing: 50) {
                            employeeWorksCountChart(projectWorks, projectEmployees)
                            
                            employeeDelayedTimeChart(projectWorks, projectEmployees)
                        }.padding(.bottom, 50)
                    }
                }
            }
        }
        
        var industriesCharts: some View {
            VStack(spacing: 50) {
                let projectIndstr = works.map { $0.project.industry }.unique()
                Text("Industries")
                    .font(.largeTitle)
                    .bold()
                
                Chart(projectIndstr) { industry in
                        BarMark(
                            x: .value("Industry", industry.name),
                            y: .value("Industry Count", works.filter { $0.project.industry == industry }.map { $0.project }.unique().count)
                        ).foregroundStyle(by: .value("Projects Count", "Projects Count"))
                    
                }
                
                Chart(projectIndstr) { industry in
                        BarMark(
                            x: .value("Industry", industry.name),
                            y: .value("Industry Count", works.filter { $0.project.industry == industry }.unique().count)
                        ).foregroundStyle(by: .value("Works Count", "Works Count"))
                    
                }
                
                Chart(projectIndstr) { industry in
                    let filterWorks = works.filter { $0.project.industry == industry }
                    
                    BarMark(
                        x: .value("Industry", industry.name),
                        y: .value("successfulWorksCount", filterWorks.map { $0.successfulWorksCount }.reduce(0, +))
                    ).foregroundStyle(by: .value("Work Result", "Successful Works"))
                    
                    BarMark(
                        x: .value("Industry", industry.name),
                        y: .value("failedWorksCount", filterWorks.map { $0.failedWorksCount }.reduce(0, +))
                    ).foregroundStyle(by: .value("Work Result", "Failed Works"))
                }
            }
        }
        
        var companyCharts: some View {
            VStack(spacing: 50) {
                Text("Total Company")
                    .font(.largeTitle)
                    .bold()
                
                Chart {
                    BarMark(
                        x: .value("successfulWorksCount", works.map { $0.successfulWorksCount }.reduce(0, +)),
                        y: .value("Successful Works", "Successful Works Count")
                    ).foregroundStyle(.blue)
                    
                    BarMark(
                        x: .value("failedWorksCount", works.map { $0.failedWorksCount }.reduce(0, +)),
                        y: .value("Failed Works Count", "Failed Works Count")
                    ).foregroundStyle(.green)
                    
                    BarMark(
                        x: .value("delayedWorksCount", works.map { $0.delayedWorksCount }.reduce(0, +)),
                        y: .value("Delayed Works Count", "Delayed Works Count")
                    ).foregroundStyle(.orange)
                }.frame(height: 200)
                
                Chart {
                    BarMark(
                        x: .value("estimatedTimeMinutes", works.map { $0.estimatedTimeMinutes }.reduce(0, +)),
                        y: .value("Estimated Time", "Estimated Time")
                    ).foregroundStyle(.blue)
                    
                    BarMark(
                        x: .value("workedTimeMinutes", works.map { $0.workedTimeMinutes }.reduce(0, +)),
                        y: .value("Worked Time", "Worked Time")
                    ).foregroundStyle(.green)
                    
                    BarMark(
                        x: .value("delayedTimeMinutes", works.map { $0.delayedTimeMinutes }.reduce(0, +)),
                        y: .value("Delayed Time", "Delayed Time")
                    ).foregroundStyle(.orange)
                }.frame(height: 200)
            }
        }
        
        return ScrollView {
            VStack(alignment: .leading) {
                companyCharts
                    .padding()
                
                industriesCharts
                    .padding()
                
                employeesCharts
                    .padding()
            }
        }
    }
}

struct WarehouseChartsView_Previews: PreviewProvider {
    static var previews: some View {
        WarehouseChartsView(viewModel: .init(container: .preview))
    }
}
