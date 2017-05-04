//
//  MovieListTableViewCell.swift
//  Movies
//
//  Created by Subashree Malla Lokanathan on 5/3/17.
//  Copyright © 2017 Subashree Malla Lokanathan. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMovieVotes: UILabel!
    @IBOutlet weak var lblOriginalTitle: UILabel!
    @IBOutlet weak var imgVwPoster: UIImageView!
    @IBOutlet weak var cellLoading: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellLoading.hidesWhenStopped = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
