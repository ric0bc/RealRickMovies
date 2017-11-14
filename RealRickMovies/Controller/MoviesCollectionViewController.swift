//
//  MoviesCollectionViewController.swift
//  RealRickMovies
//
//  Created by Ricky on 14.11.17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MoviesCollectionViewController: UICollectionViewController {

    @IBOutlet weak var imageView: UIImageView!
    var movies: Movies!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getLatestMovie()
    }
    
    func getLatestMovie() {
        let urlString = "https://api.themoviedb.org/3/movie/top_rated?language=de-CH&api_key=\(TMDBConstants.apiKey)&page=1"
        let requestURL = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: requestURL!) {(data, reponse, error ) in
            if error == nil {
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let movie = try decoder.decode(Movies.self, from: data)
                        self.movies = movie
                        DispatchQueue.main.async { self.collectionView?.reloadData() }
                    } catch let decodeError as NSError {
                        print(decodeError.localizedDescription)
                        return
                    }
                }
            } else {
                print("there was an error: \(error!)")
            }
        }
        task.resume()
    }
    
    func showImage(for movie: Movie) -> UIImage? {
        let urlString = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)")
        if let imageData = try? Data(contentsOf: urlString!) {
            return UIImage(data: imageData)
        } else {
            print("error loading image")
            return nil
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movies = movies?.results else {
            return 0
        }
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieItem", for: indexPath) as! MovieCollectionViewCell
    
        let movie = movies.results[(indexPath as NSIndexPath).row]
        
        let posterImage = showImage(for: movie)
        
        guard posterImage != nil else {
            return cell
        }

        cell.imageView.image = posterImage
        
        return cell
    }
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension MoviesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = 80 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
        
        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    }
    
}
