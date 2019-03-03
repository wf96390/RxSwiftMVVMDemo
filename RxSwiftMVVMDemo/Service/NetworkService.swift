//
//  NetworkService.swift
//  RxSwiftMVVMDemo
//
//  Created by flora on 2019/2/19.
//  Copyright © 2019 flora. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

class NetworkService {
    /// - Returns: a list of types from Douban.
    func getTypeList() -> Observable<[String]> {
        return Observable.just([
            "喜剧",
            "剧情",
            "惊悚",
            "动作",
            "恐怖",
            "Python",
            "C#"
            ])
    }
    
    func getMovieList(type: String) -> Observable<[Movie]> {
        return Observable.create({ (observer) -> Disposable in
            var url = "https://api.douban.com/v2/movie/search?tag=" + type
            url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let request = Alamofire.request(url, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let list = json["subjects"].arrayValue.map() { Movie.init(json: $0) }
                    observer.onNext(list)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
}
