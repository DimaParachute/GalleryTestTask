//
//  PopularViewController.swift
//  GalleryTestTask
//
//  Created by Дмитрий Фетюхин on 24.03.2022.
//

import UIKit

class PopularViewController: UIViewController {
    
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
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
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        self.popularCollectionView.register(UINib(nibName: "PopularView", bundle: nil), forCellWithReuseIdentifier: Constants.popularCellId)
        networkWorker.load(forVC: "popular",
                           url: Constants.url(pageNumber: imageInfo.pageNumberForPopular),
                           completion: self.updateUIAfterNetwork,
                           completionIfNoInternet: self.updateUIAfterNetworkIfNoInternet)
        self.popularCollectionView.refreshControl = self.refreshControl
        setupLoadingReusableView()
    }
    
    private func updateUIAfterNetwork() -> Void {
        self.popularCollectionView.reloadData()
        imageInfo.pageNumberForPopular += 1
        print(imageInfo.pageNumberForPopular)
    }
    
    private func updateUIAfterNetworkIfNoInternet() -> Void {
        self.popularCollectionView.isHidden = true
    }
    
    @objc private func onRefresh(sender: UIRefreshControl) {
        imageInfo.popularImages = []
        imageInfo.pageNumberForPopular = 1
        networkWorker.load(forVC: "popular",
                           url: Constants.url(pageNumber: imageInfo.pageNumberForPopular),
                           completion: self.updateUIAfterNetwork,
                           completionIfNoInternet: self.updateUIAfterNetworkIfNoInternet)
        sender.endRefreshing()
    }
    
    private func setupLoadingReusableView() -> Void {
        let loadingReusableNib = UINib(nibName: "CollectionReusableView", bundle: nil)
        self.popularCollectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Constants.loadingReusableViewId)
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                sleep(2)
                // Download more data here
                self.networkWorker.load(forVC: "popular",
                                        url: Constants.url(pageNumber: self.imageInfo.pageNumberForPopular),
                                        completion: self.updateUIAfterNetwork,
                                        completionIfNoInternet: self.updateUIAfterNetworkIfNoInternet)
                DispatchQueue.main.async {
                    self.popularCollectionView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
    enum Constants {
        static var popularCellId: String {
            "popularCellId"
        }
        
        static var loadingReusableViewId: String {
            "loadingreusableviewid"
        }
        
        static func url(pageNumber: Int) -> URL {
            URL(string: "http://gallery.dev.webant.ru/api/photos?popular=true&page=\(String(pageNumber))&limit=10")!
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
