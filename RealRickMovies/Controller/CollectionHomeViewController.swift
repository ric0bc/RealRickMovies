//
//  CollectionHomeViewController.swift
//  RealRickMovies
//
//  Created by Ricky on 15.11.17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

class CollectionHomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movies: Movies!
    let cellScaling: CGFloat = 0.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight = floor(screenSize.height * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2
        let insetY = (view.bounds.height - cellHeight) / 2
        
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
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
}

extension CollectionHomeViewController: UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let moviesArray = movies?.results else {
            return 0
        }
        return moviesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie = movies.results[indexPath.item]
        let posterImage = showImage(for: movie)
        
        guard posterImage != nil else {
            return cell
        }
        
        cell.imageView.image = posterImage
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        
    }
}
