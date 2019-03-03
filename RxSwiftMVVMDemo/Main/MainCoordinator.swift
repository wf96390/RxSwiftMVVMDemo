//
//  MainCoordinator.swift
//  RxSwiftMVVMDemo
//
//  Created by flora on 2019/2/12.
//  Copyright © 2019 flora. All rights reserved.
//

import Foundation
import RxSwift
import SafariServices

class MainCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = MainViewModel(initialType: "喜剧")
        let viewController = MainViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        
        viewModel.showMovie
            .subscribe(onNext: { [weak self] in self?.showMovie(by: $0, in: navigationController) })
            .disposed(by: disposeBag)
        
        viewModel.showTypeList
            .flatMap { [weak self] _ -> Observable<String?> in
                guard let weakSelf = self else { return .empty() }
                return weakSelf.showTypeList(on: viewController)
            }
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: viewModel.currentType)
            .disposed(by: disposeBag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
    private func showMovie(by url: URL, in navigationController: UINavigationController) {
        let safariViewController = SFSafariViewController(url: url)
        navigationController.pushViewController(safariViewController, animated: true)
    }
    
    private func showTypeList(on rootViewController: UIViewController) -> Observable<String?> {
        let typeCoordinator = TypeCoordinator(rootViewController: rootViewController)
        return coordinate(to: typeCoordinator)
            .map { result in
                switch result {
                case .selected(let type): return type
                case .cancel: return nil
                }
        }
    }
}
