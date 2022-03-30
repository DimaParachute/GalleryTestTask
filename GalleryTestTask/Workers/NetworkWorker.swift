//
//  NetworkWorker.swift
//  GalleryTestTask
//
//  Created by Дмитрий Фетюхин on 28.03.2022.
//

import Foundation
import RxSwift
import RxAlamofire

class NetworkWorker: NSObject {
    
    private var images = Images()
    private var imageInfo = ImageInfo.sharedInstance()
    
    private var reachability: Reachability? = Reachability.networkReachabilityForInternetConnection()
    
    private let disposeBag = DisposeBag()
    
    public func load(forVC: String, url: URL?, completion: (() -> Void)? = nil, completionIfNoInternet: (() -> Void)? = nil) {
        var request = URLRequest(url: (url ?? URL(string: ""))!)
        request.method = .get
        request.headers = [
            "Accept": "application/json"
        ]
        guard let r = reachability else { return }
        if r.isReachable {
            RxAlamofire.requestJSON(request).subscribe(onNext: {(response, any)  in
                print(response.statusCode)
                if 200..<300 ~= response.statusCode {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: any)
                        self.images = try JSONDecoder().decode(Images.self, from: data)
                        if forVC == "new" {
                            self.imageInfo.newImages.append(contentsOf: self.images.data!)
                        } else if forVC == "popular" {
                            self.imageInfo.popularImages.append(contentsOf: self.images.data!)
                        } else { return }
                        DispatchQueue.main.async {
                            completion?()
                        }
                    } catch {
                        print(error)
                    }
                }
            }).disposed(by: disposeBag)
        } else {
            completionIfNoInternet?()
        }
    }
}
