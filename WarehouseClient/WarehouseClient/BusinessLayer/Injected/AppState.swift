//
//  AppState.swift
//
//

import SwiftUI
import Combine

struct AppState: Equatable {
    var userData = UserData()
    var auth = Auth()
}

extension AppState {
    struct UserData: Equatable {
        var works: Loadable<[FactWorks]> = .notRequested
        var loadInfo: LoadInfo? = nil
        var oltpMetadata: OLTPMetadata? = nil
    }
}

extension AppState {
    struct Auth: Equatable {
        var user: User? = nil
        var isAuthorized: Bool {
            user != nil
        }
        
        static var mock: Auth {
            Auth(user: User(name: "Matviy"))
        }
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    lhs.auth == rhs.auth
}

extension AppState {
    static var preview: AppState {
        AppState()
    }
}
