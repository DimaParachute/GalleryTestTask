//
//  Styles.swift
//  GalleryTestTask
//
//  Created by Дмитрий Фетюхин on 31.03.2022.
//

import Foundation
import UIKit

enum Styles {
    static var defaultCornerRadius: CGFloat {
        15.0
    }
    
    static var defaultShadowRadius: CGFloat {
        10.0
    }
    
    static var defaultShadowOpacity: Float {
        0.5
    }
    
    static var defaultShadowColor: CGColor {
        UIColor.black.cgColor
    }
    
    static var defaultShadowOffset: CGSize {
        CGSize(width: 0, height: 5)
    }
}
