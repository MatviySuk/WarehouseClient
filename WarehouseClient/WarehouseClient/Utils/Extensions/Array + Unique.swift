//
//  Array + Unique.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 15.05.2023.
//

import Foundation

extension Array where Element: Hashable {
    func unique() -> Self {
        Array(Set(self))
    }
}
