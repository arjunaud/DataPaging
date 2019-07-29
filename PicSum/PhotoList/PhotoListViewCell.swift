//
//  CollectionViewCell.swift
//  PicSum
//
//  Created by Arjuna on 09/06/19.
//  Copyright © 2019 Arjuna. All rights reserved.
//

import UIKit
import Nuke
import SDWebImage
import Kingfisher

class PhotoListViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    func setUpWith(photoItemModel:PhotoItemViewModel) {
        authorLabel.text = photoItemModel.author
        let url = URL(string: photoItemModel.downloadUrlFor(width: Int(imageView.bounds.size.width), height: Int(imageView.bounds.size.height)))
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with:url)
//        let options: SDWebImageOptions = [.retryFailed , .highPriority]
//        imageView.sd_setShowActivityIndicatorView(true)
//        imageView.sd_setIndicatorStyle(.gray)
//        imageView.sd_setImage(with: url, placeholderImage: nil, options: options, completed: nil)
        //Nuke.loadImage(with: url!, into: imageView)
    }
}
