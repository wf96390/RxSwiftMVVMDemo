//
//  Movie.swift
//  RxSwiftMVVMDemo
//
//  Created by flora on 2019/2/19.
//  Copyright © 2019 flora. All rights reserved.
//

import Foundation
import SwiftyJSON

class Movie {
    let name: String
    let mid: Int
    let url: URL
    
    init(json: JSON) {
        self.name = json["title"].stringValue
        self.mid = json["id"].intValue
        self.url = URL(string: json["alt"].stringValue)!
    }
}
