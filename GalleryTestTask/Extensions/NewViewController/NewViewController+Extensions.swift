//
//  NewViewController+Extensions.swift
//  GalleryTestTask
//
//  Created by Дмитрий Фетюхин on 30.03.2022.
//

import Foundation
import UIKit

extension NewViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageInfo.newImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.newCellId, for: indexPath) as! NewCollectionViewCell
        print(indexPath.row)
        if indexPath.row >= imageInfo.newImages.startIndex && indexPath.row <= imageInfo.newImages.endIndex {
            cell.setupCell(imageUrl: URL(string: Constants.imageURL + (imageInfo.newImages[indexPath.row].image?.name ?? ""))!)
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
        if indexPath.row == imageInfo.newImages.count - 1 && !self.isLoading {
                loadMoreData()
            }
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
      ) -> CGSize {
          let paddingSpace = Constants.sectionInsets.left * (Constants.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
          let widthPerItem = availableWidth / Constants.itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
      }
    
      func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
      ) -> UIEdgeInsets {
          return Constants.sectionInsets
      }
      
      func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
      ) -> CGFloat {
          return Constants.sectionInsets.left
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        detailViewController.imageUrl = URL(string: Constants.imageURL + (imageInfo.newImages[indexPath.row].image?.name ?? ""))
        detailViewController.selectedTitle = imageInfo.newImages[indexPath.row].name
        detailViewController.selectedDescription = imageInfo.newImages[indexPath.row].description
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

