//
//  ImageLiterals.swift
//  2023-ML-Project
//
//  Created by 몽이 누나 on 2023/05/30.
//

import UIKit

enum ImageLiterals {
    static var imgBackground: UIImage { .load(named: "img_background") }
    static var imgBurger: UIImage { .load(named: "img_burger") }
    static var imgMain: UIImage { .load(named: "img_main") }
}

extension UIImage {
    static func load(named imageName: String) -> UIImage {
        guard let image = UIImage(named: imageName, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = imageName
        return image
    }
    
    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}

