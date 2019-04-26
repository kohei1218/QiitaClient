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

class TimeLineViewModel {
    let articles = BehaviorRelay<Article>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
}
