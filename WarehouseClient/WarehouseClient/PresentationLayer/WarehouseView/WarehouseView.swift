//
//  WarehouseView.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 13.05.2023.
//

import SwiftUI

struct WarehouseView: View {
    @ObservedObject private(set) var viewModel: WarehouseViewModel
    let inspection = Inspection<Self>()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                self.worksContent
                    .navigationBarTitle("Works")
                    .animation(.easeOut(duration: 0.3))
            }
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }

    
    @ViewBuilder private var worksContent: some View {
        switch viewModel.works {
        case .notRequested:
            worksNotRequestedView
        case let .isLoading(last, _):
            worksLoadingView(last)
        case let .loaded(countries):
            worksLoadedView(countries, showSearch: true, showLoading: false)
        case let .failed(error):
            worksFailedView(error)
        }
    }
}

// MARK: - Loading Content

private extension WarehouseView {
    var worksNotRequestedView: some View {
        Text("d").onAppear(perform: self.viewModel.reloadWorks)
    }
    
    func worksLoadingView(_ previouslyLoaded: [FactWorks]?) -> some View {
        if let works = previouslyLoaded {
            return AnyView(worksLoadedView(works, showSearch: true, showLoading: true))
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
    func worksLoadedView(_ works: [FactWorks], showSearch: Bool, showLoading: Bool) -> some View {
        List(works) { work in
            Text(String(work.id))
        }
    }
}

struct WarehouseView_Previews: PreviewProvider {
    static var previews: some View {
        WarehouseView(viewModel: .init(container: .preview))
    }
}
