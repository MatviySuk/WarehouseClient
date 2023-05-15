//
//  BaseView.swift
//  DreyfusQuestionnaire
//
//  Created by Matviy Suk on 05.03.2023.
//

import SwiftUI

struct BaseView: View {
    @ObservedObject private(set) var viewModel: BaseViewModel
    @State private var selectedTab: String = "Tables"
    
    var body: some View {
        if viewModel.isAuth {
            tabViews
        } else {
            AuthView(viewModel: .init(container: viewModel.container))
        }
    }
    
    private var tabViews: some View {
        TabView(selection: $selectedTab) {
            WarehouseView(viewModel: .init(container: viewModel.container))
                .tabItem {
                    Label("Tables", systemImage: "tablecells.fill")
                }
                .tag("Tables")
            WarehouseChartsView(viewModel: .init(container: viewModel.container))
                .tabItem {
                    Label("Charts", systemImage: "chart.pie.fill")
                }
                .tag("Charts")
        }
        .onAppear {
            viewModel.reloadWorks()
        }
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView(viewModel: .init(container: .preview))
    }
}
