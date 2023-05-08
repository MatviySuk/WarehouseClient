//
//  LocalAuthService.swift
//  DreyfusQuestionnaire
//
//  Created by Matviy Suk on 05.03.2023.
//

import Foundation

struct LocalAuthService: AuthService {
    let appState: Store<AppState>
    
    init(appState: Store<AppState>) {
        self.appState = appState
    }

    func logIn(_ user: User) {
        appState[\.auth.user] = user
    }
    
    func logOut() {
        appState[\.auth.user] = nil
    }
}
