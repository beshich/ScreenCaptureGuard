//
//  ViewController.swift
//  ScreenCaptureGuard
//
//  Created by Agatai Embeev on 25.02.2024.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Setup Views

private extension HomeViewController {
    
    func setupViews() {
        view.backgroundColor = .white
    }
}
