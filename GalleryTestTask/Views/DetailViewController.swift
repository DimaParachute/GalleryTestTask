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
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        imageTitle.text = selectedTitle
        imageDescription.text = selectedDescription
        self.image.kf.setImage(with: imageUrl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //setupScrollView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //setupScrollView()
    }
    
    /*private func setupScrollView() {
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
    }*/
}
