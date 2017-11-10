//
//  TMDBClient.swift
//  RealRickMovies
//
//  Created by Ricky on 10.11.17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import Foundation

class TMDBClient: NSObject {
    
    class func getRequest(for url: URL, completion: @escaping (_ json: [String:Any]?) -> Void){
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) -> Void in
            
            guard (error == nil) else {
                print("Error while fetching the request token: \(error!)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data was returned!")
                completion(nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 400 else {
                print("Authentification failed")
                completion(nil)
                return
            }
            
            var parsedData: [String: Any]!
            do {
                parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                completion(parsedData)
            } catch {
                print("Error while serializing JSON")
                completion(nil)
                return
            }
            
        }
        task.resume()
    }
}
