//
//  ViewController.swift
//  GalleryTestTask
//
//  Created by Дмитрий Фетюхин on 24.03.2022.
//

import UIKit

class NewViewController: UIViewController {
    
    @IBOutlet weak var newCollectionView: UICollectionView!
    
    lazy var detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
    
    private var networkWorker = NetworkWorker()
    var imageInfo = ImageInfo.sharedInstance()
    var loadingView: CollectionReusableView?
    
    var isLoading = false
    
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCollectionView.delegate = self
        newCollectionView.dataSource = self
        self.newCollectionView.register(UINib(nibName: "NewView", bundle: nil), forCellWithReuseIdentifier: Constants.newCellId)
        networkWorker.load(forVC: "new",
                           url: Constants.url(pageNumber: imageInfo.pageNumberForNew),
                           completion: self.updateUIAfterNetwork,
                           completionIfNoInternet: self.updateUIAfterNetworkIfNoInternet)
        self.newCollectionView.refreshControl = self.refreshControl
        setupLoadingReusableView()
    }
    
    private func updateUIAfterNetwork() -> Void {
        newCollectionView.reloadData()
        imageInfo.pageNumberForNew += 1
        print(imageInfo.pageNumberForNew)
    }
    
    private func updateUIAfterNetworkIfNoInternet() -> Void {
        self.newCollectionView.isHidden = true
    }
    
    @objc private func onRefresh(sender: UIRefreshControl) {
        imageInfo.newImages = []
        imageInfo.pageNumberForNew = 1
        networkWorker.load(forVC: "new",
                           url: Constants.url(pageNumber: imageInfo.pageNumberForNew),
                           completion: self.updateUIAfterNetwork,
                           completionIfNoInternet: self.updateUIAfterNetworkIfNoInternet)
        sender.endRefreshing()
    }
    
    private func setupLoadingReusableView() -> Void {
        let loadingReusableNib = UINib(nibName: "CollectionReusableView", bundle: nil)
        self.newCollectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Constants.loadingReusableViewId)
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                sleep(2)
                self.networkWorker.load(forVC: "new",
                                        url: Constants.url(pageNumber: self.imageInfo.pageNumberForNew),
                                        completion: self.updateUIAfterNetwork,
                                        completionIfNoInternet: self.updateUIAfterNetworkIfNoInternet)
                DispatchQueue.main.async {
                    self.newCollectionView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }

    enum Constants {
        static var newCellId: String {
            "newCellId"
        }
        
        static var loadingReusableViewId: String {
            "loadingreusableviewid"
        }
        
        static func url(pageNumber: Int) -> URL {
            URL(string: "http://gallery.dev.webant.ru/api/photos?new=true&page=\(String(pageNumber))&limit=10")!
        }
        
        static var imageURL: String {
            "http://gallery.dev.webant.ru/media/"
        }
        
        static var itemsPerRow: CGFloat {
            2
        }
        
        static var sectionInsets = UIEdgeInsets(
          top: 50.0,
          left: 20.0,
          bottom: 50.0,
          right: 20.0)
    }

}

