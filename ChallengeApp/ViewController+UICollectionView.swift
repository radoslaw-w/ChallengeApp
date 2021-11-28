//
//  ViewController+UICollectionView.swift
//  ChallengeApp
//
//  Created by Radosław Winkler on 28/11/2021.
//

import UIKit
struct CellData: Codable, Hashable {
    let identifier = UUID()
    public let url: URL?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    private enum CodingKeys: String, CodingKey {
        case url
    }
    
    static func == (lhs: CellData, rhs: CellData) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension ViewController {
    func setupCollectionView() {
        let frameworkBundle = Bundle(for: Self.self)
        collectionView.register(UINib(nibName: "Cell", bundle: frameworkBundle),
                                forCellWithReuseIdentifier: Self.CellID)
        collectionView.collectionViewLayout = generateLayout()
        setupDataSource()
    }
    private func getCell(cellData: CellData, for indexPath: IndexPath) -> UICollectionViewCell {
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
    func snapshotData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellData>()
        
        if let files = try? FileManager.default.contentsOfDirectory(atPath: documentsURL.path){
            snapshot.appendSections([0])
            let items = files.sorted(by: >)
                .map { documentsURL.appendingPathComponent($0)}
                .map { CellData(url:$0)}
            snapshot.appendItems(items)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func setupDataSource() {
        // swiftlint:disable:next line_length
        dataSource = UICollectionViewDiffableDataSource<Int, CellData>(collectionView: collectionView) { [weak self](_: UICollectionView, indexPath: IndexPath, cellData: CellData) -> UICollectionViewCell? in
            return self?.getCell(cellData: cellData, for: indexPath)
            
        }
        snapshotData()
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        //1
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(
            top: 4,
            leading: 4,
            bottom: 0,
            trailing: 4)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: fullPhotoItem,
            count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    private func gridSection(withColumns columns: Int) -> NSCollectionLayoutSection {
        assert(columns > 0, "Number of columns for a section must be larger than 0.")
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(200))
        let spacing:CGFloat = 12
        var subitems = [NSCollectionLayoutItem]()
        
        
        let singleItem = NSCollectionLayoutItem(layoutSize: itemSize)
        singleItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: 0, bottom: spacing, trailing: 0)
        subitems.append(singleItem)
        
        
        let groupHeight = NSCollectionLayoutDimension.fractionalWidth(1.0 / CGFloat(columns))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: subitems)
        
        let headerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
        )
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(44))
        
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return section
    }
    
}

