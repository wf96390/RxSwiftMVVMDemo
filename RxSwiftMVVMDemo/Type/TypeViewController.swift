//
//  TypeViewController.swift
//  RxSwiftMVVMDemo
//
//  Created by flora on 2019/2/27.
//  Copyright © 2019 flora. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Shows a list languages.
class TypeViewController: UIViewController, StoryboardInitializable {
    
    let disposeBag = DisposeBag()
    var viewModel: TypeViewModel!
    
    @IBOutlet weak var tableView: UITableView!

    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Choose a language"
        
        tableView.rowHeight = 48.0
    }
    
    private func setupBindings() {
        viewModel.types
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "TypeCell", cellType: UITableViewCell.self)) { (_, type, cell) in
                cell.textLabel?.text = type
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .bind(to: viewModel.selectType)
            .disposed(by: disposeBag)

        cancelButton.rx.tap
            .bind(to: viewModel.cancel)
            .disposed(by: disposeBag)
    }
}
