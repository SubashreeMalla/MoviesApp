//
//  MovieImageDetailCell.swift
//  Movies
//
//  Created by Subashree Malla Lokanathan on 5/3/17.
//  Copyright © 2017 Subashree Malla Lokanathan. All rights reserved.
//

import UIKit

class MovieImageDetailCell: UITableViewCell {
    
    @IBOutlet weak var lblOriginalTitle: UILabel!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var bannerLoading: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgPoster.layer.borderWidth = 2.0
        self.imgPoster.layer.borderColor = UIColor.white.cgColor
        bannerLoading.hidesWhenStopped = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
