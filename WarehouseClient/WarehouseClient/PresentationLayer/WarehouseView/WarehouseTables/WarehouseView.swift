//
//  WarehouseView.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 13.05.2023.
//

import SwiftUI

struct WarehouseView: View {    
    @ObservedObject private(set) var viewModel: WarehouseViewModel
    @State private var reversedSort = false
    @State private var columnsVisibility: NavigationSplitViewVisibility = .detailOnly
        
    let inspection = Inspection<Self>()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationSplitView(columnVisibility: $columnsVisibility, sidebar: {
                sidebarView
            })  {
                self.worksContent
                    .navigationTitle("Tables")
                    .animation(.easeInOut(duration: 0.2), value: viewModel.works)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Picker("Sort Records", selection: $viewModel.selectedSortOrder, content: {
                                ForEach(viewModel.sortOrder, id: \.self) { value in
                                    Text(value.name)
                                        .tag(value.order)
                                }
                            }).pickerStyle(.menu)
                            
                            Toggle("Reversed Sort", isOn: $reversedSort)
                            
                            Picker("Dates", selection: $viewModel.selectedDate, content: {
                                ForEach(viewModel.dates) { date in
                                    Text("\(date.dateTitle)")
                                        .tag(date)
                                }
                            })
                            .pickerStyle(.menu)
                        }
                    }
            }
        }.onReceive(inspection.notice) { self.inspection.visit(self, $0) }
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
    
    private var sidebarView: some View {
        VStack {
            Text("Sidebar")
        }
    }
}

// MARK: - Loading Content

private extension WarehouseView {
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

private extension WarehouseView {
    func worksLoadedView(_ works: [FactWorks]) -> some View {
        var factTable: some View {
            VStack(alignment: .leading) {
                Text("Works")
                    .font(.largeTitle)
                
                Table(works.filter {
                    ($0.startDate >= viewModel.selectedDate) &&
                    ($0.endDate <= viewModel.selectedDate.incrementedMonthDate)
                }) {
                    Group {
                        TableColumn("Project Name", value: \FactWorks.project.name)
                        TableColumn("Employee", value: \FactWorks.employee.fullName)
                    }
                    
                    Group {
                        TableColumn("Total mins") { (work: FactWorks) in Text("\(work.workedTimeMinutes)") }
                        TableColumn("Est. mins") { work in Text("\(work.estimatedTimeMinutes)") }
                        TableColumn("Delayed mins") { work in Text("\(work.delayedTimeMinutes)") }
                        TableColumn("Total works") { work in Text("\(work.totalWorksCount)") }
                        TableColumn("Successful works") { work in Text("\(work.successfulWorksCount)") }
                        TableColumn("Failed works") { work in Text("\(work.failedWorksCount)") }
                        TableColumn("Delayed works") { work in Text("\(work.delayedWorksCount)") }
                    }
                }
                .onChange(of: viewModel.selectedSortOrder) { order in
                    viewModel.works = reversedSort
                    ? .loaded(works.sorted(using: order).reversed())
                    : .loaded(works.sorted(using: order))
                }
                .onChange(of: reversedSort) { isReversed in
                    viewModel.works = .loaded(works.reversed())
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
        
        var dimProjects: some View {
            VStack(alignment: .leading) {
                Text("Projects")
                    .font(.largeTitle)
                Table(works.map { $0.project }.unique()) {
                    TableColumn("Name", value: \.name)
                    TableColumn("Industry", value: \.industry.name)
                    TableColumn("Manager", value: \.projectManager.fullName)
                    TableColumn("Description", value: \.description)
                    TableColumn("Category", value: \.category)
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
        
        var dimEmployees: some View {
            VStack(alignment: .leading) {
                Text("Employees")
                    .font(.largeTitle)
                Table(works.flatMap { [$0.employee, $0.project.projectManager] }.unique()) {
                    TableColumn("Full Name", value: \.fullName)
                    TableColumn("Birthday", value: \.birthday)
                    TableColumn("Email", value: \.email)
                    TableColumn("Phone", value: \.phone)
                    TableColumn("Role", value: \.role.name)
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
        
        var dimRolesAndIndustries: some View {
            GeometryReader { geo in
                HStack(alignment: .top, spacing: geo.size.width * 0.05) {
                    VStack(alignment: .leading) {
                        Text("Roles")
                            .font(.largeTitle)
                        Table(works.flatMap { [$0.employee.role, $0.project.projectManager.role] }.unique()) {
                            TableColumn("Role Type", value: \.name)
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    
                    VStack(alignment: .leading) {
                        Text("Industries")
                            .font(.largeTitle)
                        Table(works.map { $0.project.industry }.unique()) {
                            TableColumn("Industry", value: \.name)
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                .padding(.horizontal)
            }
        }

        
        return GeometryReader { geo in
            ScrollView {
                VStack(spacing: 100) {
                    factTable
                        .frame(height: geo.size.height * 0.9)
                    dimProjects
                        .frame(height: geo.size.height * 0.4)
                    dimEmployees
                        .frame(height: geo.size.height * 0.4)
                    dimRolesAndIndustries
                        .frame(height: geo.size.height * 0.55)
                }
                .padding(.horizontal)
                .padding(.bottom, geo.size.height * 0.1)
            }
        }
    }
        
}

struct WarehouseView_Previews: PreviewProvider {
    static var previews: some View {
        WarehouseView(viewModel: .init(container: .preview))
    }
}