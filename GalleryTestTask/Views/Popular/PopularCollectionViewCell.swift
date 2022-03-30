//
//  PopularCollectionViewCell.swift
//  GalleryTestTask
//
//  Created by Дмитрий Фетюхин on 24.03.2022.
//

import Foundation
import UIKit
import Kingfisher

class PopularCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var popularSubview: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func setupCell(imageUrl: URL) -> Void {
        self.cellImageView.kf.setImage(with: imageUrl)
    }
}
