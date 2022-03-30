//
//  imageInfo.swift
//  GalleryTestTask
//
//  Created by Дмитрий Фетюхин on 28.03.2022.
//

import Foundation

class ImageInfo {
    
    static var _sharedInstance: ImageInfo?
    class func sharedInstance() -> ImageInfo {
        if _sharedInstance == nil {
            _sharedInstance = ImageInfo()
        }
        return _sharedInstance!
    }
    
    var pageNumberForNew = 1
    var pageNumberForPopular = 1
    
    var newImages: [DataModel] = []
    var popularImages: [DataModel] = []
}
