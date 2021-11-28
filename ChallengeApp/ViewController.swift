//
//  ViewController.swift
//  ChallengeApp
//
//  Created by Radosław Winkler on 27/11/2021.
//

import UIKit
import Combine

class ViewController: UIViewController {
    static let CellID = "CellID"
    static let photosPath = "Photos"
    static let apiKey = "c3c38861c3e034fe2649635e7a18826e"
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, CellData>!
    var cancellables = Set<AnyCancellable>()
    var tracker:Tracker!
    
    lazy var session:URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        return session
    }()

    lazy var documentsURL:URL = {
        var documentsURL:URL
        do {
            documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: true)
                .appendingPathComponent(Self.photosPath, isDirectory: true)
            try FileManager.default.createDirectory(atPath: documentsURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            fatalError("Error: \(error)")
        }
        return documentsURL
    }()
    
    lazy private var rightBarButtonItem = {
        UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(toggleTracking))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tracker = Tracker(delegate: self)
        setupView()
        bindUI()
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
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: false)
      }
    }
    
    
    private func setupView(){
        navigationItem.rightBarButtonItem = rightBarButtonItem
        setupCollectionView()
        
    }
    
    private func bindUI(){
        self.tracker.$isTracking
            .map{$0 ? "Stop":"Start"}
            .assign(to: \.title, on: rightBarButtonItem)
            .store(in: &cancellables)
    }
    
    @objc
    private func toggleTracking() {
        if self.tracker.isTracking{
            self.tracker.stopTracking()
        }    else{
            self.tracker.startTracking()
        }
    }
    
}


