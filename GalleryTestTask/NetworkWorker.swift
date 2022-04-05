//
//  NetworkWorker.swift
//  GalleryTestTask
//
//  Created by Дмитрий Фетюхин on 01.04.2022.
//

import Foundation
import RxAlamofire
import RxSwift

class NetworkWorker: NSObject {
    
    func createRequest(url: URL?) -> Observable<(HTTPURLResponse, Any)> {
        var request = URLRequest(url: (url ?? URL(string: ""))!)
        request.method = .get
        request.headers = [
            "Accept": "application/json"
        ]
        
        return RxAlamofire.requestJSON(request)
    }
}
