//
//  AuthViewModel.swift
//  DreyfusQuestionnaire
//
//  Created by Matviy Suk on 05.03.2023.
//

import Foundation

final class AuthViewModel: ViewModel {
    @Published var name: String = ""
    
    func logIn() {
        container.services.authService.logIn(User(name: name))
        
//        switch container.services.questionnaireStore.readQuestionnaire() {
//        case .success(let questionnaire):
//            container.appState[\.questionnaire] = questionnaire
//        case .failure(let error):
//            print(error)
//        }
    }
}
