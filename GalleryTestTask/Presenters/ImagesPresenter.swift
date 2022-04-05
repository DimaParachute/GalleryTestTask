//
//  ImagesPresenter.swift
//  GalleryTestTask
//
//  Created by Дмитрий Фетюхин on 01.04.2022.
//

import Foundation
import RxSwift
import RxAlamofire

protocol ImagesViewPresenter: AnyObject {
    var pageNumber: Int? { get set }
    var images: [DataModel]? { get }
    init(/*view: MainViewProtocol, */networkWorker: NetworkWorker/*, images: [DataModel]?*/)
    func refresh()
    func load(url: URL?, completion: (() -> Void)?, completionIfNoInternet: (() -> Void)?)
}

class ImagesPresenter: ImagesViewPresenter {
    
    enum Constants {
        static func url(state: ImagesPresenter.State, pageNumber: Int) -> URL {
            if state == State.new {
                return URL(string: "http://gallery.dev.webant.ru/api/photos?new=true&page=\(String(pageNumber))&limit=10")!
            } else {
                return URL(string: "http://gallery.dev.webant.ru/api/photos?popular=true&page=\(String(pageNumber))&limit=10")!
            }
        }
    }
    
    var pageNumber: Int?
    var images: [DataModel]?
    //let view: MainViewProtocol
    
    enum State {
        case new, popular
    }
    
    var networkWorker: NetworkWorker?
    private var reachability: Reachability? = Reachability.networkReachabilityForInternetConnection()
    private let disposeBag = DisposeBag()
    
    required init(networkWorker: NetworkWorker) {
        self.networkWorker = networkWorker
    }

    func refresh() {
        pageNumber = 1
        images = []
    }
    
    func load(url: URL?, completion: (() -> Void)? = nil, completionIfNoInternet: (() -> Void)? = nil) {
        guard let r = reachability else { return }
        if r.isReachable {
            self.networkWorker?.createRequest(url: url).subscribe( onNext: { (response, any) in
                if 200..<300 ~= response.statusCode {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: any)
                        let images = try JSONDecoder().decode(Images.self, from: data)
                        self.images?.append(contentsOf: images.data ?? [])
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
