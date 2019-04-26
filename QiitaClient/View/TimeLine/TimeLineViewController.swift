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

class TimeLineViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let provider = MoyaProvider<Qiita.GetArticles>()
    private let decoder = JSONDecoder()
    private let articles: BehaviorRelay<Article> = BehaviorRelay(value: [])
    private let viewModel = TimeLineViewModel()
    private let perPage = 20
    private var page = 1
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(type: CustomViewCell.self)
        decoder.dateDecodingStrategy = .iso8601
        request(page: page)
        viewModel.articles.subscribe(onNext: { [unowned self] (articles) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func request(page: Int) {
        provider
            .rx
            .request(Qiita.GetArticles(page: page, perPage: perPage))
            .filterSuccessfulStatusAndRedirectCodes()
            .map(Article.self, atKeyPath: "article", using: decoder, failsOnEmptyData: false)
            .subscribe(onSuccess: { (article) in
                self.viewModel.articles.accept(article)
            }) { (error) in
                print("error:", error)
        }.disposed(by: disposeBag)
    }
}

extension TimeLineViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomViewCell = CustomViewCell.dequeue(from: tableView, for: indexPath, with: .init(article: articles.value[indexPath.item]))
        return cell
    }
    
    
}
