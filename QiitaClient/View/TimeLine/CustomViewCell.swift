//
//  CustomViewCell.swift
//  QiitaClient
//
//  Created by kohei saito on 2019/04/20.
//  Copyright © 2019 kohei saito. All rights reserved.
//

import UIKit
import Kingfisher
import Instantiate
import InstantiateStandard

class CustomViewCell: UITableViewCell, Reusable, NibType {
    
    struct Dependency {
        var article: ArticleElement
    }
    
    func inject(_ dependency: CustomViewCell.Dependency) {
        
        userImageView.kf.setImage(with: dependency.article.user.profileImageURL.toUrl())
        userNameView.text = dependency.article.user.name
        titleLabel.text = dependency.article.title
        let names = dependency.article.tags.compactMap { $0.name }
        tagLabel.text = names.joined(separator: ", ")
    }

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameView: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(article: ArticleElement) {
        userImageView.kf.setImage(with: article.user.profileImageURL.toUrl())
        userNameView.text = article.user.name
        titleLabel.text = article.title
        let names = article.tags.compactMap { $0.name }
        tagLabel.text = names.joined(separator: ", ")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
