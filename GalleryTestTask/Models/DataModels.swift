//
//  ImagesAPI.swift
//  GalleryTestTask
//
//  Created by Дмитрий Фетюхин on 25.03.2022.
//

import Foundation

class Images: Codable {
    var data: [DataModel]?
}

struct DataModel: Codable {
    var name: String?
    var description: String?
    var new: Bool?
    var popular: Bool?
    var image: ImageData?
}

struct ImageData: Codable {
    var name: String?
}
