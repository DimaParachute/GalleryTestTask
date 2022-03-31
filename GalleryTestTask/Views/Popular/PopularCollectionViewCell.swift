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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = Styles.defaultCornerRadius
        contentView.layer.masksToBounds = true
        
        cellImageView.layer.cornerRadius = Styles.defaultCornerRadius
        cellImageView.layer.masksToBounds = true
                
        layer.cornerRadius = Styles.defaultCornerRadius
        layer.masksToBounds = false
                
        layer.shadowRadius = Styles.defaultShadowRadius
        layer.shadowOpacity = Styles.defaultShadowOpacity
        layer.shadowColor = Styles.defaultShadowColor
        layer.shadowOffset = Styles.defaultShadowOffset
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeFromSuperview()
    }
    
    public func setupCell(imageUrl: URL) -> Void {
        self.cellImageView.kf.setImage(with: imageUrl)
    }
}
