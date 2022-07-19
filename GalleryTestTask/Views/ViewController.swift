//
//  ViewController.swift
//  GalleryTestTask
//
//  Created by Дмитрий Фетюхин on 24.03.2022.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    
}

class ViewController: UIViewController, MainViewProtocol {
    
    //MARK: - Constants
    private enum Constants {
        static var newCellId: String {
            "newCellId"
        }
        
        static var loadingReusableViewId: String {
            "loadingreusableviewid"
        }
        
        static var loadingReusableViewNibName: String {
            "CollectionReusableView"
        }
        
        static var cellViewNibName: String {
            "CellView"
        }
        
        static var imageURL: String {
            "http://gallery.prod1.webant.ru/media/"
        }
    }
    
    private enum Styles {
        static var itemsPerRow: CGFloat {
            if UIDevice.current.orientation.isLandscape {
                return 5
            } else {
                return 2
            }
        }
        
        static var sectionInsets = UIEdgeInsets(
          top: 20.0,
          left: 20.0,
          bottom: 20.0,
          right: 20.0)
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var detailViewController: DetailViewController?
    
    //MARK: - Properties
    private var loadingView: CollectionReusableView?
    private var isLoading = false
    private var presenter: ImagesViewPresenter?
    private var currentView: ImagesPresenter.State?
    
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: - ViewController lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = ImagesPresenter(networkWorker: NetworkWorker())
        presenter?.refresh()
        setupCollectionView()
        setupDetailViewController()
        setupLoadingReusableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.tabBarController?.selectedIndex == 0 {
            currentView = .new
            getData()
        } else {
            currentView = .popular
            getData()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (_) in
            //self.collectionView.collectionViewLayout.invalidateLayout()
            self.getData()
        }, completion: nil)
    }
    
    
    //MARK: - Private Methods
    
    private func getData() {
        guard let currentState = self.currentView else { return }
        guard let presenter = self.presenter else { return }
        presenter.load(url: ImagesPresenter.Constants.url(state: currentState, pageNumber: presenter.pageNumber ?? 1),
                            completion: updateUIAfterNetwork,
                            completionIfNoInternet: updateUIAfterNetworkIfNoInternet)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: Constants.cellViewNibName, bundle: nil), forCellWithReuseIdentifier: Constants.newCellId)
        self.collectionView.refreshControl = self.refreshControl
    }
    
    private func setupDetailViewController() {
        detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
    }
    
    private func updateUIAfterNetwork() -> Void {
        collectionView.reloadData()
    }
    
    private func updateUIAfterNetworkIfNoInternet() -> Void {
        self.collectionView.isHidden = true
    }
    
    @objc private func onRefresh(sender: UIRefreshControl) {
        guard let presenter = self.presenter else { return }
        presenter.refresh()
        DispatchQueue.global().async {
            sleep(1)
            self.getData()
            DispatchQueue.main.async {
                sender.endRefreshing()
            }
        }
    }
    
    private func setupLoadingReusableView() -> Void {
        let loadingReusableNib = UINib(nibName: Constants.loadingReusableViewNibName, bundle: nil)
        self.collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Constants.loadingReusableViewId)
    }
    
    private func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                sleep(1)
                guard let presenter = self.presenter else { return }
                presenter.pageNumber = (presenter.pageNumber ?? 1) + 1
                self.getData()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let presenter = self.presenter else { return 0 }
        return presenter.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.newCellId, for: indexPath) as! CollectionViewCell
        guard let presenter = self.presenter else { return cell }
        guard let images = presenter.images else { return cell }
        if indexPath.row >= images.startIndex && indexPath.row <= images.endIndex {
            cell.setupCell(imageUrl: URL(string: Constants.imageURL + (presenter.images?[indexPath.row].image?.name ?? ""))!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            if self.isLoading {
                return CGSize.zero
            } else {
                return CGSize(width: collectionView.bounds.size.width, height: 55)
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionFooter {
                let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.loadingReusableViewId, for: indexPath) as! CollectionReusableView
                loadingView = aFooterView
                loadingView?.backgroundColor = UIColor.clear
                return aFooterView
            }
            return UICollectionReusableView()
        }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
            if elementKind == UICollectionView.elementKindSectionFooter {
                self.loadingView?.activityIndicator.startAnimating()
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
            if elementKind == UICollectionView.elementKindSectionFooter {
                self.loadingView?.activityIndicator.stopAnimating()
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let presenter = self.presenter else { return }
        guard let imagesCount = presenter.images?.count else { return }
        if indexPath.row == imagesCount - 1 && !self.isLoading {
                self.loadMoreData()
            }
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
      ) -> CGSize {
          let paddingSpace = Styles.sectionInsets.left * (Styles.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
          let widthPerItem = availableWidth / Styles.itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
      }
    
      func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
      ) -> UIEdgeInsets {
          return Styles.sectionInsets
      }
      
      func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
      ) -> CGFloat {
          return Styles.sectionInsets.left
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let presenter = self.presenter else { return }
        guard let images = presenter.images else { return }
        detailViewController?.imageUrl = URL(string: Constants.imageURL + (images[indexPath.row].image?.name ?? ""))
        detailViewController?.selectedTitle = images[indexPath.row].name
        detailViewController?.selectedDescription = images[indexPath.row].description
        guard let detailViewController = self.detailViewController else { return }
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
