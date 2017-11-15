//
//  HomeViewController.swift
//  RealRickMovies
//
//  Created by Ricky on 03.11.17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    var arrayMovies: Array<[String:AnyObject]>! = []
    var movies: Movies!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top rated"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                        DispatchQueue.main.async { self.tableView.reloadData() }
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
}

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard movies != nil else {
            return 0
        }
        return self.movies.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as UITableViewCell!
        
        let movie = movies.results[(indexPath as NSIndexPath).row]
        let imagePath = movie.poster_path
        
        let urlString = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)")
        if let imageData = try? Data(contentsOf: urlString!) {
            cell?.imageView!.image = UIImage(data: imageData)
        } else {
            print("error loading image")
        }
        
        cell?.textLabel?.text = movie.title
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = storyboard!.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        detailView.movie = movies.results[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(detailView, animated: true)
    }
    
}
