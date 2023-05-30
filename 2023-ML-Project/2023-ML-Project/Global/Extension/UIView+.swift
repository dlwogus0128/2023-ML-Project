//
//  UIView+.swift
//  2023-ML-Project
//
//  Created by 몽이 누나 on 2023/05/30.
//


import UIKit

extension UIView {
    
    // UIView 여러 개 인자로 받아서 한 번에 addSubview
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}

