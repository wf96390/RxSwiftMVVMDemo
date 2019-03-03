//
//  TypeViewModel.swift
//  RxSwiftMVVMDemo
//
//  Created by flora on 2019/2/27.
//  Copyright © 2019 flora. All rights reserved.
//

import RxSwift

class TypeViewModel {
    
    // MARK: - Inputs
    
    let selectType = PublishSubject<String>()
    let cancel = PublishSubject<Void>()
    
    // MARK: - Outputs
    
    let types: Observable<[String]>
    
    init(networkService: NetworkService = NetworkService()) {
        self.types = networkService.getTypeList()
    }
}
