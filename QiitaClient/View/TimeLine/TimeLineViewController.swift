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
        
        articles
            .bind(to: tableView.rx.items) { tableView, row, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
