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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLatestMovie()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as UITableViewCell!

        let movie = arrayMovies[(indexPath as NSIndexPath).row]
        let imagePath = movie["poster_path"] as! String

        let urlString = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)")
        if let imageData = try? Data(contentsOf: urlString!) {
            cell?.imageView!.image = UIImage(data: imageData)
        } else {
            print("error loading image")
        }

        cell?.textLabel?.text = movie["title"] as? String

        return cell!
    }
    
    
    func getLatestMovie() {
        let urlString = "https://api.themoviedb.org/3/movie/top_rated?language=de-CH&api_key=\(Constants.apiKey)&page=1"
        let requestURL = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: requestURL!) {(data, reponse, error ) in
            if error == nil {
                if let data = data {
                    let parsedResults: [String:AnyObject]!
                    do {
                        parsedResults = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                        self.arrayMovies = parsedResults["results"] as? [[String:AnyObject]]
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("An error with parsing")
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
