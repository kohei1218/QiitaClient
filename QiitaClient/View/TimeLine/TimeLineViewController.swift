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
            }) { [unowned self] (error) in
                self.viewModel.isLoading.accept(false)
                print("error:", error)
        }.disposed(by: disposeBag)
    }
}

extension TimeLineViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomViewCell = CustomViewCell.dequeue(from: tableView, for: indexPath, with: .init(article: viewModel.articles.value[indexPath.item]))
        return cell
    }
    
    
}
