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
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(type: CustomViewCell.self)
        decoder.dateDecodingStrategy = .iso8601
        provider.rx
            .request(Qiita.GetArticles(page: 1, perPage: 20))
            .filterSuccessfulStatusCodes()
            .map(Article.self, atKeyPath: "articles", using: decoder, failsOnEmptyData: false)
            .subscribe(onSuccess: { (article) in
                print("articles:", article)
                self.articles.accept(article)
            }) { (error) in
                print("error:", error)
            }
            .disposed(by: disposeBag)
        
        articles.subscribe(onNext: { [unowned self] (article) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
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
