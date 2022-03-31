//
//  NewDetailViewController.swift
//  GalleryTestTask
//
//  Created by Дмитрий Фетюхин on 30.03.2022.
//

import Foundation
import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    var imageUrl: URL!
    var selectedTitle: String!
    var selectedDescription: String!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var imageDescription: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        imageTitle.text = selectedTitle
        imageDescription.text = selectedDescription
        self.image.kf.setImage(with: imageUrl)
    }
}
