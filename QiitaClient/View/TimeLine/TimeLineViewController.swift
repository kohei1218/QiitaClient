//
//  TimeLineViewController.swift
//  QiitaClient
//
//  Created by kohei saito on 2019/04/20.
//  Copyright © 2019 kohei saito. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import IHProgressHUD

class TimeLineViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = TimeLineViewModel()
    
    private enum Section: CaseIterable {
        case item
        case pagination
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "タイムライン"
        viewModel.isLoading.subscribe(onNext: { (isLoading) in
            if isLoading {
                if self.viewModel.page == 1 {
                    IHProgressHUD.show()
                }
            } else {
                IHProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        viewModel.articles.subscribe(onNext: { [unowned self] (articles) in
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        tableView.registerNib(type: CustomViewCell.self)
        tableView.registerNib(type: PagingCell.self)
        tableView.isHidden = true
        viewModel.request(page: viewModel.page)
    }
}

extension TimeLineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section.allCases[section]
        switch section  {
        case .item:
            return viewModel.articles.value.count
        case .pagination:
            return viewModel.isLoading.value ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section.allCases[indexPath.section]
        switch  section {
        case .item:
            let cell: CustomViewCell = CustomViewCell.dequeue(from: tableView, for: indexPath, with: .init(article: viewModel.articles.value[indexPath.item]))
            return cell
        case .pagination:
            let cell = PagingCell.dequeue(from: tableView, for: indexPath)
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch Section.allCases[indexPath.section] {
        case .item:
            return
        case .pagination:
            viewModel.request(page: viewModel.page)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        switch Section.allCases[indexPath.section] {
        case .item:
            let webView = WebViewController.instantiate(with: .init(url: viewModel.articles.value[indexPath.item].url.toUrl()))
            self.navigationController?.pushViewController(webView, animated: true)
        case .pagination:
            break
        }
    }
    
}
