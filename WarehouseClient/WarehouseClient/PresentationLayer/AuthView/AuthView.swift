//
//  AuthView.swift
//  DreyfusQuestionnaire
//
//  Created by Matviy Suk on 05.03.2023.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject private(set) var viewModel: AuthViewModel

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Text("Авторизація")
                .font(.title)
                .padding()
                .padding(.vertical)
            
            TextField("Ім'я користувача: ", text: $viewModel.name)
                .padding()
            
            Button("Вхід") {
                withAnimation {
                    viewModel.logIn()
                }
            }.buttonStyle(BorderedButtonStyle())
            
            Spacer()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(viewModel: .init(container: .preview))
    }
}
