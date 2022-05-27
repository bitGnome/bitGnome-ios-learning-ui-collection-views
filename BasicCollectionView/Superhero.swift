//
//  Superhero.swift
//  BasicCollectionView
//
//  Created by Brett Piatt on 5/25/22.
//

import Foundation

class Superhero: Hashable {
    var name: String

    init(name: String) {
        self.name = name
    }

    // MARK: Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    static func == (lhs: Superhero, rhs: Superhero) -> Bool {
        lhs.name == rhs.name
    }

}
