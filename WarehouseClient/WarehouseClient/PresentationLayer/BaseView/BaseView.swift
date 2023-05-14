//
//  BaseView.swift
//  DreyfusQuestionnaire
//
//  Created by Matviy Suk on 05.03.2023.
//

import SwiftUI

struct BaseView: View {
    @ObservedObject private(set) var viewModel: BaseViewModel
    
    var body: some View {
        NavigationStack {
            if viewModel.isAuth {
                WarehouseView(viewModel: .init(container: viewModel.container))
            } else {
                AuthView(viewModel: .init(container: viewModel.container))
            }
        }
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView(viewModel: .init(container: .preview))
    }
}
