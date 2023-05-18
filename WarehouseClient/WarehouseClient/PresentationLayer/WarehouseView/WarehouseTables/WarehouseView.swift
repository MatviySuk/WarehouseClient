//
//  WarehouseView.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 13.05.2023.
//

import SwiftUI
import PDFKit

struct WarehouseView: View {    
    @ObservedObject private(set) var viewModel: WarehouseViewModel
    @State private var reversedSort = false
    @State private var showFilters = false
    @State private var showMetadata = false
    @State private var columnsVisibility: NavigationSplitViewVisibility = .detailOnly
    @State private var selectedWork: FactWorks? = nil
        
    let inspection = Inspection<Self>()
    
    var body: some View {
        GeometryReader { geo in
            NavigationSplitView(columnVisibility: $columnsVisibility, sidebar: {
                sidebarView
            })  {
                self.worksContent
                    .navigationTitle("Tables")
                    .animation(.easeInOut(duration: 0.2), value: viewModel.works)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            if viewModel.metadata != nil {
                                Button("OLTP DB Metadata") {
                                    showMetadata.toggle()
                                }
                            }
                        }
                        
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button("Filters") {
                                showFilters.toggle()
                            }.popover(isPresented: $showFilters, content: {
                                factFiltersView
                                    .frame(maxWidth: geo.size.width * 0.4, maxHeight: geo.size.height * 0.4)
                            })
                            
                            Picker("Sort Records", selection: $viewModel.selectedSortOrder, content: {
                                ForEach(viewModel.sortOrder, id: \.self) { value in
                                    Text(value.name)
                                        .tag(value.order)
                                }
                            }).pickerStyle(.menu)
                            
                            Toggle("Reversed Sort", isOn: $reversedSort)
                        }
                    }
                    .sheet(item: $selectedWork) { work in WorkDetailedView(work: work) }
                    .sheet(isPresented: $showMetadata) {
                        if let meta = viewModel.metadata {
                            MetadataView(meta: meta)
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
    
    private var factFiltersView: some View {
        ScrollView {
            VStack(spacing: .zero) {
                VStack {
                    Button("Reset All") {
                        viewModel.setUpRanges()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical, 20)
                    
                    Divider()
                }.padding(.horizontal)
                
                DimDateRangePicker(title: "Dates Range", limit: viewModel.datesLimit(), dates: $viewModel.dates, range: $viewModel.datesIndicesRange)
                
                RangePickerView(title: "Total Minutes", limit: viewModel.limit(keyPath: \.workedTimeMinutes), range: $viewModel.totalMinsRange)
                
                RangePickerView(title: "Estimated Minutes", limit: viewModel.limit(keyPath: \.estimatedTimeMinutes), range: $viewModel.estMinsRange)
                
                RangePickerView(title: "Delayed Minutes", limit: viewModel.limit(keyPath: \.delayedTimeMinutes), range: $viewModel.delayMinsRange)

                RangePickerView(title: "Total Works", limit: viewModel.limit(keyPath: \.totalWorksCount), range: $viewModel.totalWorksRange)

                RangePickerView(title: "Successful Works", limit: viewModel.limit(keyPath: \.successfulWorksCount), range: $viewModel.successWorksRange)

                RangePickerView(title: "Delayed Works", limit: viewModel.limit(keyPath: \.delayedWorksCount), range: $viewModel.delayWorksRange)

                RangePickerView(title: "Failed Works", limit: viewModel.limit(keyPath: \.failedWorksCount), range: $viewModel.failedWorksRange)
            }
        }
    }

    private var sidebarView: some View {
        VStack(spacing: 30) {
            if let info = viewModel.loadInfo {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Last Load: \(info.loadTime)")
                        Text("Rows Affected: \(info.rowsAffected)")
                    }
                    .bold()
                    .padding()
                    
                    Spacer()
                }
            }
            
            Button("Full Load") {
                viewModel.container.services.warehouseService.makeFullLoad(cancelBag: viewModel.cancelBag)
            }.buttonStyle(.borderedProminent)
            
            Button("Incremental Load") {
                viewModel.container.services.warehouseService.makeIncrementalLoad(cancelBag: viewModel.cancelBag)
            }.buttonStyle(.borderedProminent)
            
            Button("Warehouse Clean Up") {
                viewModel.container.services.warehouseService.makeCleanUp(cancelBag: viewModel.cancelBag)
            }.buttonStyle(.borderedProminent)
            
            ShareLink("Export PDF", item: render())
                .buttonStyle(.bordered)
            
            Spacer()
        }.padding(.vertical)
        .navigationTitle("ITCompanyWHS")
    }
        
    private func render() -> URL {
        let renderer = ImageRenderer(content: VStack {
            WarehouseChartsView(viewModel: .init(container: viewModel.container)).worksContent
        })
                
        let url = URL.documentsDirectory.appending(path: "warehouseCharts.pdf")
        
        renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            
            pdf.beginPDFPage(nil)
            
            context(pdf)
            
            pdf.endPDFPage()
            pdf.closePDF()
        }
        
        return url
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

                VStack {
                    WorkHeaderView()
                        .frame(height: 70)
                    
                    Divider()
                    
                    ScrollView {
                        ForEach(viewModel.filteredWorks(works)) { work in
                            Button(action: {
                                selectedWork = work
                            }) {
                                WorkItemView(work: work)
                                    .frame(minHeight: 50, maxHeight: 100, alignment: .center)
                            }.tint(.black)
                            
                            Divider()
                        }
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
