//
//  Api.swift
//  QiitaClient
//
//  Created by kohei saito on 2019/04/20.
//  Copyright © 2019 kohei saito. All rights reserved.
//

import Moya
import RxSwift

class Api {
    static let shared = Api()
    private let provider = MoyaProvider<MultiTarget>()
    
    func request<R>(_ request: R) -> Single<R.Response> where R: QiitaApiTargetType {
        let target = MultiTarget(request)
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .map(R.Response.self)
    }
}

protocol QiitaApiTargetType: TargetType {
    associatedtype Response: Codable
}

extension QiitaApiTargetType {
    var baseURL: URL { return URL(string: "https://qiita.com/api/v2")! }
    var headers: [String : String]? { return nil }
    var sampleData: Data { return Data() }
}

enum Qiita {
    struct GetArticles: QiitaApiTargetType {
        
        typealias Response = Article
        var method: Moya.Method { return .get }
        var path: String { return "/items" }
        var task: Task { return .requestParameters(parameters: ["page": page, "per_page": perPage], encoding: URLEncoding.default) }
        var page: Int
        var perPage: Int
        
        init(page: Int, perPage: Int) {
            self.page = page
            self.perPage = perPage
        }
    }
}
