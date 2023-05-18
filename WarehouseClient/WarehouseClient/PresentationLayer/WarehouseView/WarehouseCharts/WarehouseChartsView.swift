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
    
    @ViewBuilder var worksContent: some View {
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
            }.frame(height: 200)
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
            }.frame(height: 200)
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
                }.frame(height: 200)
                
                Chart(projectIndstr) { industry in
                    BarMark(
                        x: .value("Industry", industry.name),
                        y: .value("Industry Count", works.filter { $0.project.industry == industry }.unique().count)
                    ).foregroundStyle(by: .value("Works Count", "Works Count"))
                }.frame(height: 200)
                
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
                }.frame(height: 200)
            }
        }
        
        var companyCharts: some View {
            VStack(spacing: 50) {
                Text("Total Company")
                    .font(.largeTitle)
                    .bold()
                
                Chart {
                    ForEach(works.map { $0.startDate }.unique().sorted()) { date in
                        let dateWorks = works.filter { $0.startDate == date }
                        
                        LineMark(
                            x: .value("Date", date.dateTitle),
                            y: .value("successfulWorksCount", dateWorks.map { $0.successfulWorksCount }.reduce(0, +))
                        ).symbol(by: .value("Successful Works", "Successful Works Count"))
                        .foregroundStyle(by: .value("Successful Works", "Successful Works Count"))
                        
                        LineMark(
                            x: .value("Date", date.dateTitle),
                            y: .value("failedWorksCount", dateWorks.map { $0.failedWorksCount }.reduce(0, +))
                        ).symbol(by: .value("Failed Works Count", "Failed Works Count"))
                        .foregroundStyle(by: .value("Failed Works Count", "Failed Works Count"))
                        
                        LineMark(
                            x: .value("Date", date.dateTitle),
                            y: .value("delayedWorksCount", dateWorks.map { $0.delayedWorksCount }.reduce(0, +))
                        ).symbol(by: .value("Delayed Works Count", "Delayed Works Count"))
                        .foregroundStyle(by: .value("Delayed Works Count", "Delayed Works Count"))
                    }
                }.frame(height: 200)
                
                Chart {
                    ForEach(works.map { $0.startDate }.unique().sorted()) { date in
                        let dateWorks = works.filter { $0.startDate == date }
                        
                        LineMark(
                            x: .value("Date", date.dateTitle),
                            y: .value("worked", dateWorks.map { $0.workedTimeMinutes }.reduce(0, +))
                        ).symbol(by: .value("Worked Time", "Worked Time"))
                            .foregroundStyle(by: .value("Worked Time", "Worked Time"))
                        
                        LineMark(
                            x: .value("Date", date.dateTitle),
                            y: .value("estimated", dateWorks.map { $0.estimatedTimeMinutes }.reduce(0, +))
                        ).symbol(by: .value("Estimated Time", "Estimated Time"))
                            .foregroundStyle(by: .value("Estimated Time", "Estimated Time"))
                        
                        LineMark(
                            x: .value("Date", date.dateTitle),
                            y: .value("delayed", dateWorks.map { $0.delayedTimeMinutes }.reduce(0, +))
                        ).symbol(by: .value("Delayed Time", "Delayed Time"))
                            .foregroundStyle(by: .value("Delayed Time", "Delayed Time"))
                    }
                }.frame(height: 200)
                
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
        
        var allEmployeesCharts: some View {
            VStack(spacing: 50) {
                Text("All Employees Charts")
                    .font(.largeTitle)
                    .bold()
                
                ForEach(works.map { $0.employee }.unique()) { emp in
                    VStack {
                        Text(emp.fullName)
                            .font(.largeTitle)
                        
                        Chart {
                            let empWorks = works.filter { $0.employee == emp }
                            ForEach(empWorks.map { $0.project }.unique()) { proj in
                                let projWorks = empWorks.filter { $0.project == proj }.unique()
                                
                                LineMark(
                                    x: .value("project", proj.name),
                                    y: .value("successfulWorksCount", projWorks.map { $0.successfulWorksCount }.reduce(0, +))
                                ).symbol(by: .value("Successful Works", "Successful Works Count"))
                                    .foregroundStyle(by: .value("Successful Works", "Successful Works Count"))
                                
                                LineMark(
                                    x: .value("project", proj.name),
                                    y: .value("failedWorksCount", projWorks.map { $0.failedWorksCount }.reduce(0, +))
                                ).symbol(by: .value("Failed Works Count", "Failed Works Count"))
                                    .foregroundStyle(by: .value("Failed Works Count", "Failed Works Count"))
                                
                                LineMark(
                                    x: .value("project", proj.name),
                                    y: .value("delayedWorksCount", projWorks.map { $0.delayedWorksCount }.reduce(0, +))
                                ).symbol(by: .value("Delayed Works Count", "Delayed Works Count"))
                                    .foregroundStyle(by: .value("Delayed Works Count", "Delayed Works Count"))
                            }
                        }.frame(height: 200)
                        
                        Chart {
                            let empWorks = works.filter { $0.employee == emp }
                            ForEach(empWorks.map { $0.project }.unique()) { proj in
                                let projWorks = empWorks.filter { $0.project == proj }.unique()
                                
                                LineMark(
                                    x: .value("project", proj.name),
                                    y: .value("worked", projWorks.map { $0.workedTimeMinutes }.reduce(0, +))
                                ).symbol(by: .value("Worked Time", "Worked Time"))
                                    .foregroundStyle(by: .value("Worked Time", "Worked Time"))
                                
                                LineMark(
                                    x: .value("project", proj.name),
                                    y: .value("estimated", projWorks.map { $0.estimatedTimeMinutes }.reduce(0, +))
                                ).symbol(by: .value("Estimated Time", "Estimated Time"))
                                    .foregroundStyle(by: .value("Estimated Time", "Estimated Time"))
                                
                                LineMark(
                                    x: .value("project", proj.name),
                                    y: .value("delayed", projWorks.map { $0.delayedTimeMinutes }.reduce(0, +))
                                ).symbol(by: .value("Delayed Time", "Delayed Time"))
                                    .foregroundStyle(by: .value("Delayed Time", "Delayed Time"))
                            }
                        }.frame(height: 200)
                    }
                }
            }
        }
        
        return VStack(alignment: .leading) {
            companyCharts
                .padding()
            
            industriesCharts
                .padding()
            
            employeesCharts
                .padding()
            
            allEmployeesCharts
                .padding()
        }
    }
}

struct WarehouseChartsView_Previews: PreviewProvider {
    static var previews: some View {
        WarehouseChartsView(viewModel: .init(container: .preview))
    }
}
