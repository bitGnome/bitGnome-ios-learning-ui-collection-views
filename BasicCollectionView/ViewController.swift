//
//  ViewController.swift
//  BasicCollectionView
//
//  Created by Brett Piatt on 5/25/22.
//

import UIKit

class ViewController: UICollectionViewController {

    private enum SuperheroSection: Int {
        case main
    }

    private var superheroListDataSource: UICollectionViewDiffableDataSource<SuperheroSection, Superhero.ID>!

    let imageSize: CGFloat = 200

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        configureCollectionView()
        loadData()
    }
}

extension ViewController {
    private func configureCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.itemSize = CGSize(width: self.view.frame.size.width - 40, height: imageSize)
        collectionView.collectionViewLayout = layout
    }

    private func loadData() {
        let superheroIds = dataStore.allSuperheros.map { $0.id }
        var snapshot = NSDiffableDataSourceSnapshot<SuperheroSection, Superhero.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(superheroIds, toSection: .main)
        superheroListDataSource.applySnapshotUsingReloadData(snapshot)
    }
}

extension ViewController {

    private func configureDataSource() {
        // Create a cell registration that the diffable data source will use
        let superheroCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Superhero> { cell, indexPath, superhero in
            var contentConfiguration = UIListContentConfiguration.subtitleCell()
            contentConfiguration.text = superhero.name
            contentConfiguration.secondaryText = "Rating: \(superhero.rating)"
            contentConfiguration.image = superhero.fullImage
            contentConfiguration.imageProperties.cornerRadius = 20
            contentConfiguration.imageProperties.maximumSize = CGSize(width: self.imageSize, height: self.imageSize)

            cell.contentConfiguration = contentConfiguration
            cell.accessories = []
        }

        // Create the diffable data souce and its cell provider
        superheroListDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, identifier -> UICollectionViewCell in
            // 'identifier' is an instance of `Superhero.ID` Use it to retrieve the superhero from the data store.
            let superhero = dataStore.superhero(with: identifier)!
            return collectionView.dequeueConfiguredReusableCell(using: superheroCellRegistration, for: indexPath, item: superhero)
        }
    }
}

extension ViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("See you are learning you clicked the superhero at position: \(indexPath.row)")

        let updatedHero = dataStore.superhero(with: indexPath.row)

        if updatedHero!.rating.count == 5 {
            updatedHero!.rating = ""
        } else {
            updatedHero!.rating = updatedHero!.rating.appending("★")
        }

        var newSnapshot = superheroListDataSource.snapshot()
        newSnapshot.reconfigureItems([indexPath.row])
        superheroListDataSource.apply(newSnapshot)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
