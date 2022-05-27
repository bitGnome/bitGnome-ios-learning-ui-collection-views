//
//  Data.swift
//  BasicCollectionView
//
//  Created by Brett Piatt on 5/26/22.
//

import UIKit
import ImageIO

// A reference to the app's backing data store. This data store
// retrieves recipe data from the file system. In a real-world
// app, a data store might contain data from other sources such as
// Core Data or web services.
let dataStore = DataStore(superheros: load("superheros.json"))

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in the main bundle")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()

        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

final class ImageStore {
    typealias _ImageDictionary = [String: UIImage]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var scale = 2

    static var shared = ImageStore()

    func image(name: String) -> UIImage {
        let index = _guaranteeImage(name: name)
        return images.values[index]
    }

    static func loadImage(name: String) -> UIImage {
        return UIImage(named: name)!
    }

    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }

        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}

class DataStore {
    var allSuperheros: [Superhero]

    init(superheros: [Superhero]) {
        self.allSuperheros = superheros
    }

    func superhero(with id: Int) -> Superhero? {
        return allSuperheros.first(where: { $0.id == id })
    }
}
