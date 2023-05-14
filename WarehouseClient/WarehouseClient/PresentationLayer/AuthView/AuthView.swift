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
        GeometryReader { geo in
            HStack(alignment: .center) {
                Spacer()
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    Text("Authorization")
                        .font(.title)
                        .padding()
                        .padding(.vertical)
                    
                    TextField("User Name: ", text: $viewModel.name)
                        .padding()
                        .frame(maxWidth: geo.size.width * 0.5)
                    
                    Button("Log In") {
                        withAnimation {
                            viewModel.logIn()
                        }
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .padding()
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(viewModel: .init(container: .preview))
    }
}
