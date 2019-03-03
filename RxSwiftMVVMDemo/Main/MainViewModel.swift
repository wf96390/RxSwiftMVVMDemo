//
//  MainViewModel.swift
//  RxSwiftMVVMDemo
//
//  Created by flora on 2019/2/12.
//  Copyright © 2019 flora. All rights reserved.
//

import Foundation
import RxSwift

class MainViewModel {
    
    let currentType: BehaviorSubject<String>
    
    /// Call to open repository page.
    let selectMovie: AnyObserver<Movie>
    
    /// Call to reload repositories.
    let reload = PublishSubject<Void>()
    
    // MARK: - Outputs
    
    /// Emits an array of fetched repositories.
    let movies: Observable<[Movie]>
    
    /// Emits a formatted title for a navigation item.
    let title: Observable<String>
    
    /// Emits an error messages to be shown.
    let alertMessage = PublishSubject<String>()
    
    /// Emits an url of repository page to be shown.
    let showMovie: Observable<URL>
    
    /// Emits when we should show language list.
    let showTypeList = PublishSubject<Void>()
    
    init(initialType: String, networkService: NetworkService = NetworkService()) {
        self.currentType = BehaviorSubject<String>(value: initialType)
        
        self.title = currentType.asObservable().map { "\($0)" }
        
        let _selectMovie = PublishSubject<Movie>()
        self.selectMovie = _selectMovie.asObserver()
        self.showMovie = _selectMovie.asObservable()
            .map { $0.url }
        
        let _alertMessage = alertMessage.asObserver()
        self.movies = Observable.combineLatest( reload, currentType) { _, type in type }
            .flatMapLatest { type in
                networkService.getMovieList(type: type)
                    .catchError { error in
                        _alertMessage.onNext(error.localizedDescription)
                        return Observable.empty()
                }
        }
    }
}
