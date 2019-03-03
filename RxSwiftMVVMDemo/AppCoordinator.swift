//
//  AppCoordinator.swift
//  RxSwiftMVVMDemo
//
//  Created by flora on 2019/2/28.
//  Copyright © 2019 flora. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let mainCoordinator = MainCoordinator(window: window)
        return coordinate(to: mainCoordinator)
    }
}
