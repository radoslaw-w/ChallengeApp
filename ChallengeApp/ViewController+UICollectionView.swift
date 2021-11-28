//
//  ViewController+UICollectionView.swift
//  ChallengeApp
//
//  Created by Radosław Winkler on 28/11/2021.
//

import UIKit

extension ViewController {
    
    func setupCollectionView() {
        let nib = UINib(nibName: "Cell",bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Self.CellID)
        collectionView.collectionViewLayout = simpleLayout()
        setupDataSource()
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, CellData>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, cellData: CellData) -> UICollectionViewCell? in
            var cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: Self.CellID,
                                     for: indexPath) as? Cell
            if cell == nil {
                cell = Cell() as Cell
            }
            if let url = cellData.url,
               let data  = try? Data(contentsOf: url){
                cell?.imageView.image = UIImage(data: data)
            }
            
            return cell!
            
        }
        snapshotData()
    }
    
    private func simpleLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(  top: 4,
                                                                leading: 4,
                                                                bottom: 0,
                                                                trailing: 4)
        let groupSize = NSCollectionLayoutSize( widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .fractionalWidth(1.0))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: fullPhotoItem,
            count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

