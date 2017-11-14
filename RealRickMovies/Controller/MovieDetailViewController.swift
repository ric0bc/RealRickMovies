//
//  MovieDetailViewController.swift
//  RealRickMovies
//
//  Created by Ricky on 14.11.17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = movie.title
        
        let image = showImage()
        posterImage.image = image
        
    }
    
    func showImage() -> UIImage? {
        let urlString = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)")
        if let imageData = try? Data(contentsOf: urlString!) {
            return UIImage(data: imageData)
        } else {
            print("error loading image")
            return nil
        }
    }

}
