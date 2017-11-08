//
//  HomeViewController.swift
//  RealRickMovies
//
//  Created by Ricky on 03.11.17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    var imageBackdrop: UIImage!
    var arrayMovies: Array<[String:AnyObject]>!
    var imageString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLatestMovie()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as UITableViewCell!
        cell?.imageView!.image = imageBackdrop
//        let movie = array[(indexPath as NSIndexPath).row]
//        cell?.textLabel?.text = movie["title"] as? String
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
                        print(parsedResults)
                        self.arrayMovies = parsedResults["results"] as? [[String:AnyObject]]
                    } catch {
                        print("An error with parsing")
                        return
                    }
                }
            } else {
                print("there was an error: \(error!)")
            }
            self.getImage()
        }
        task.resume()
    }
    func getImage(){
        let urlString = URL(string: "https://image.tmdb.org/t/p/w500/kqjL17yufvn9OVLyXYpvtyrFfak.jpg")
        if let imageData = try? Data(contentsOf: urlString!) {
            DispatchQueue.main.async {
                self.imageBackdrop = UIImage(data: imageData)
                self.tableView.reloadData()
            }
        } else {
            print("error loading image")
        }
        
    }
}
