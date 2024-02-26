//
//  UIView + Extensions.swift
//  ScreenCaptureGuard
//
//  Created by Agatai Embeev on 26.02.2024.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
