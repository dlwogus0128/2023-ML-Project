//
//  RecipeRouter.swift
//  2023-ML-Project
//
//  Created by 몽이 누나 on 2023/05/30.
//

import Foundation
import UIKit

import Moya

enum RecipeRouter {
    case uploadImage(imageData: NSData)
}

extension RecipeRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        return "/upload"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .uploadImage(let imageData):
            let formData = MultipartFormData(provider: .data(imageData as Data), name: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            
            return .uploadCompositeMultipart([formData], urlParameters: ["image": formData])
        }
}
    
    var headers: [String : String]? {
        return ["Content-Type": "multipart/form-data"]
    }
}
