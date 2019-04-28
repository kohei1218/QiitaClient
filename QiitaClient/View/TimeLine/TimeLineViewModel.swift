//
//  TimeLineViewModel.swift
//  QiitaClient
//
//  Created by kohei saito on 2019/04/26.
//  Copyright © 2019 kohei saito. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class TimeLineViewModel {
    var page = 1
    let perPage = 10
    
    let disposeBag = DisposeBag()
    let provider = MoyaProvider<Qiita.GetArticles>()
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    let articles = BehaviorRelay<Article>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    func request(page: Int) {
        isLoading.accept(true)
        provider
            .rx
            .request(Qiita.GetArticles(page: page, perPage: perPage))
            .filterSuccessfulStatusAndRedirectCodes()
            .map(Article.self, atKeyPath: "article", using: decoder, failsOnEmptyData: false)
            .subscribe(onSuccess: { (article) in
                self.isLoading.accept(false)
                var articles = self.articles.value
                articles += article
                self.articles.accept(articles)
                self.page += 1
            }) { [unowned self] (error) in
                self.isLoading.accept(false)
                print("error:", error)
            }.disposed(by: disposeBag)
    }
}
