//
//  FontLiterals.swift
//  2023-ML-Project
//
//  Created by 몽이 누나 on 2023/05/29.
//

import UIKit

extension UIFont {
    @nonobjc class var semiBold16: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 16)
    }
    
    @nonobjc class var semiBold17: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 17)
    }
    
    @nonobjc class var semiBold24: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 24)
    }
    
    @nonobjc class var medium16: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 16)
    }
}

enum FontName: String {
    case pretendardBold = "Pretendard-Bold"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
}

extension UIFont {
    static func font(_ style: FontName, ofSize size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}

