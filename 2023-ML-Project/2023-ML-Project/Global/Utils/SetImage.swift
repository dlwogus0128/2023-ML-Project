//
//  SetImage.swift
//  2023-ML-Project
//
//  Created by 몽이 누나 on 2023/05/31.
//

import UIKit
import Kingfisher

public extension UIImageView {
    func setImage(with urlString: String, placeholder: String? = nil, completion: ((UIImage?) -> Void)? = nil) {
        let cache = ImageCache.default
        if urlString.isEmpty {
            // URL이 비어있을 경우 기본 이미지로 설정
            self.image = UIImage()
        } else {
            cache.retrieveImage(forKey: urlString) { result in
                switch result {
                case .success(let imageCache):
                    if let image = imageCache.image {
                        self.image = image
                        completion?(image)
                    } else {
                        self.setNewImage(with: urlString, placeholder: placeholder, completion: completion)
                    }
                case .failure(_):
                    self.setNewImage(with: urlString, placeholder: placeholder, completion: completion)
                }
            }
        }
    }
    
    private func setNewImage(with urlString: String, placeholder: String? = "img_placeholder", completion: ((UIImage?) -> Void)? = nil) {
        guard let url = URL(string: urlString) else { return }
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        let placeholderImage = UIImage(named: placeholder ?? "img_placeholder")
        let options: KingfisherOptionsInfo = [
            .scaleFactor(UIScreen.main.scale/4),
            .transition(.fade(0.5)),
            .cacheOriginalImage
        ]
        
        self.kf.setImage(
            with: resource,
            placeholder: placeholderImage,
            options: options,
            completionHandler: { result in
                switch result {
                case .success(let imageResult):
                    completion?(imageResult.image)
                case .failure(_):
                    completion?(nil)
                }
            }
        )
    }
}
