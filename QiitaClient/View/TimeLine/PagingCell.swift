//
//  PagingCell.swift
//  QiitaClient
//
//  Created by kohei saito on 2019/04/26.
//  Copyright © 2019 kohei saito. All rights reserved.
//

import UIKit
import Instantiate
import InstantiateStandard

class PagingCell: UITableViewCell, NibType, Reusable {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
