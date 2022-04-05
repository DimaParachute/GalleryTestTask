//
//  NewCollectionViewCell.swift
//  GalleryTestTask
//
//  Created by Дмитрий Фетюхин on 24.03.2022.
//

import Foundation
import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    private enum Styles {
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
    
    @IBOutlet weak var newCellSubview: UIView!
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
    }
    
    public func setupCell(imageUrl: URL) -> Void {
        self.cellImageView.kf.setImage(with: imageUrl)
    }
}
