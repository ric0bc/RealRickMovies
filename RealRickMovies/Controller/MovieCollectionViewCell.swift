//
//  MovieCollectionViewCell.swift
//  RealRickMovies
//
//  Created by Ricky on 14.11.17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 10)
        
        self.clipsToBounds = false
    }
    
}
