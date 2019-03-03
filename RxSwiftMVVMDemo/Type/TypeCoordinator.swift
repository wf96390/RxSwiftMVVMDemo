//
//  TypeCoordinator.swift
//  RxSwiftMVVMDemo
//
//  Created by flora on 2019/2/27.
//  Copyright © 2019 flora. All rights reserved.
//

import Foundation
import RxSwift

/// - selected: Type was choosen.
/// - cancel: Cancel button was tapped.
enum TypeCoordinationResult {
    case selected(String)
    case cancel
}

class TypeCoordinator: BaseCoordinator<TypeCoordinationResult> {
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<CoordinationResult> {
        let viewController = TypeViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let viewModel = TypeViewModel()
        viewController.viewModel = viewModel
        
        let cancel = viewModel.cancel.map { _ in CoordinationResult.cancel }
        let language = viewModel.selectType.map { CoordinationResult.selected($0) }
        
        rootViewController.present(navigationController, animated: true)
        
        return Observable.merge(cancel, language)
            .take(1)
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
    }
}

