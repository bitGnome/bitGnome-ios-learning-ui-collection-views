//
//  ColorWay.swift
//  BasicCollectionView
//
//  Created by Brett Piatt on 5/25/22.
//

import UIKit

class Superhero: Identifiable, Codable {
    var id: Int
    var name: String
    var rating: String
    fileprivate var imageNames: [String]
}

extension Superhero {
    var fullImage: UIImage {
        guard let name = imageNames.last else { return #imageLiteral(resourceName: "placeholder") }
        return ImageStore.shared.image(name: name)
    }
}


