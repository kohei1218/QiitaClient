//
//  String+Extension.swift
//  QiitaClient
//
//  Created by kohei saito on 2019/04/20.
//  Copyright © 2019 kohei saito. All rights reserved.
//

import UIKit

extension String {
    
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    func toUrl() -> URL {
        return URL(string: self)!
    }
    
}
