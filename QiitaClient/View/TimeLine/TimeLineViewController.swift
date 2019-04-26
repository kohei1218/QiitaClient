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
    private let provider = MoyaProvider<Qiita.GetArticles>()
    private let decoder = JSONDecoder()
    private let viewModel = TimeLineViewModel()
    private let perPage = 20
    private var page = 1
    
    private enum Section: CaseIterable {
        case item
        case pagination
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.isLoading.subscribe(onNext: { (isLoading) in
            if isLoading {
                IHProgressHUD.show()
            } else {
                IHProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        tableView.registerNib(type: CustomViewCell.self)
        tableView.registerNib(type: PagingCell.self)
        tableView.isHidden = true
        decoder.dateDecodingStrategy = .iso8601
        request(page: page)
        viewModel.articles.subscribe(onNext: { [unowned self] (articles) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func request(page: Int) {
        viewModel.isLoading.accept(true)
        provider
            .rx
            .request(Qiita.GetArticles(page: page, perPage: perPage))
            .filterSuccessfulStatusAndRedirectCodes()
            .map(Article.self, atKeyPath: "article", using: decoder, failsOnEmptyData: false)
            .subscribe(onSuccess: { (article) in
                self.viewModel.articles.accept(article)
                self.viewModel.isLoading.accept(false)
                self.page += 1
                self.tableView.isHidden = false
            }) { [unowned self] (error) in
                self.viewModel.isLoading.accept(false)
                print("error:", error)
        }.disposed(by: disposeBag)
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
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section.allCases[indexPath.section]
        switch  section {
        case .item:
            let cell: CustomViewCell = CustomViewCell.dequeue(from: tableView, for: indexPath, with: .init(article: viewModel.articles.value[indexPath.item]))
            return cell
        case .pagination:
            return PagingCell.dequeue(from: tableView, for: indexPath)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch Section.allCases[indexPath.section] {
        case .item:
            break
        case .pagination:
            request(page: page)
        }
    }
    
}
