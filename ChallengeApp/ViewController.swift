//
//  ViewController.swift
//  ChallengeApp
//
//  Created by Radosław Winkler on 27/11/2021.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var cancellables = Set<AnyCancellable>()
    var tracker:Tracker!
    lazy var rightBarButtonItem = {
        UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(toggleTracking))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tracker = Tracker(delegate: self)
        setupView()
        bindUI()
    }
     
    private func setupView(){
        navigationItem.rightBarButtonItem = rightBarButtonItem
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
            self.tracker.initiateTracking()
        }
    }

}

