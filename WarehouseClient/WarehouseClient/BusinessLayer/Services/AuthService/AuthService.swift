//
//  AuthService.swift
//  DreyfusQuestionnaire
//
//  Created by Matviy Suk on 05.03.2023.
//

import Foundation

protocol AuthService {
    func logIn(_ user: User)
    func logOut()
}
