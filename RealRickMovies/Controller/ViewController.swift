//
//  ViewController.swift
//  RealRickMovies
//
//  Created by Ricky on 03.11.17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var requestToken: String!
    var usernameText: String!
    var passwdText: String!
    
    // Delegate
    let textFieldDelegate = LoginTextFieldsDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = textFieldDelegate
        passwdTextField.delegate = textFieldDelegate
        
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.frame.size = CGSize(width: Double(loginButton.frame.width), height: Double(loginButton.frame.height * 2))
        
        activityIndicatorView.hidesWhenStopped = true
    }
    
    func getRequestToken() {
        
        activityIndicatorView.startAnimating()
        
        let token = TMDBConstants.tmdbAuthURL + "token/new?api_key=\(TMDBConstants.apiKey)"
        let tokenURL = URL(string: token)
//        let request = URLRequest(url: tokenURL!)
        let task = URLSession.shared.dataTask(with: tokenURL!) { (data, response, error) in
            if error == nil {
                if let data = data {
                    let parsedResults: [String:AnyObject]!
                    do {
                        parsedResults = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    } catch {
                        print("An error with parsing")
                        return
                    }
                    if let requestToken = parsedResults["request_token"] as? String {
                        self.requestToken = requestToken
                    }
                }
            } else {
                print("there was an error: \(error!)")
            }
            self.loginWithToken()
        }
        task.resume()
    }
    
    func loginWithToken() {
        let session = TMDBConstants.tmdbAuthURL + "token/validate_with_login?api_key=\(TMDBConstants.apiKey)&username=\(usernameText!)&password=\(passwdText!)&request_token=\(requestToken!)"
        let sessionURL = URL(string: session)
        let request = URLRequest(url: sessionURL!)
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 400 else {
                DispatchQueue.main.async {
                    self.errorLabel.text = "Authentication failed"
                    self.activityIndicatorView.stopAnimating()
                }
                return
            }
            
            if error == nil {
                if let data = data {
                    let parsedData: [String:AnyObject]!
                    do {
                        parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                        if let requestToken = parsedData["request_token"] as? String {
                            self.requestToken = requestToken
                        }
                    } catch {
                        print("Error with parsing")
                    }
                    
                }
            } else {
                print("There was an error: \(error!)")
            }
            self.getSessionID(self.requestToken)
        }
        task.resume()
    }

    func getSessionID(_ requestToken: String) {
        let session = TMDBConstants.tmdbAuthURL + "session/new?api_key=\(TMDBConstants.apiKey)&request_token=\(requestToken)"
        let sessionURL = URL(string: session)
        let request = URLRequest(url: sessionURL!)
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error == nil {
                if let data = data {
                    let parsedData: [String:AnyObject]!
                    do {
                        parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                        if let sessionID = parsedData["session_id"] as? String {
                            TMDBConstants.sessionID = sessionID
                            self.completeLogin()
                        }
                    } catch {
                        print("Error with parsing")
                    }
                }
            } else {
                print("There was an error: \(error!)")
            }
        }
        task.resume()
    }
    
    func completeLogin() {
        let NavigationViewController = storyboard?.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        activityIndicatorView.stopAnimating()
        present(NavigationViewController, animated: true, completion: nil)
    }
    
    @IBAction func login(){
        usernameTextField.resignFirstResponder()
        passwdTextField.resignFirstResponder()
        usernameText = usernameTextField.text!
        passwdText = passwdTextField.text!
//        getRequestToken()
        activityIndicatorView.startAnimating()
        
        let url = URL(string: TMDBConstants.tmdbAuthURL + "token/new?api_key=\(TMDBConstants.apiKey)")!
        
        TMDBClient.getRequest(for: url){(json) in
            if let json = json  {
                let rToken = json["request_token"] as? String
                
                let requestTokenURL = URL(string: "\(TMDBConstants.tmdbAuthURL)token/validate_with_login?api_key=\(TMDBConstants.apiKey)&username=\(self.usernameText!)&password=\(self.passwdText!)&request_token=\(rToken!)")!
                
                TMDBClient.getRequest(for: requestTokenURL){ (json) in
                    if let json = json {
                        let rToken = json["request_token"] as? String
                        
                        let sessionIDURL = URL(string: "\(TMDBConstants.tmdbAuthURL)session/new?api_key=\(TMDBConstants.apiKey)&request_token=\(rToken!)")!
                        
                        TMDBClient.getRequest(for: sessionIDURL){(json) in
                            if let json = json {
                                TMDBConstants.sessionID = json["session_id"] as! String
                                self.completeLogin()
                            }
                        }
                    }
                }
            }
        }
    }
}

