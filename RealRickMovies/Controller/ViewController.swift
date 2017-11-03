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
    
    var requestToken: String!
    var usernameText: String!
    var passwdText: String!
    
    // Delegate
    let textFieldDelegate = LoginTextFieldsDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = textFieldDelegate
        passwdTextField.delegate = textFieldDelegate
        activityIndicatorView.hidesWhenStopped = true
    }
    
    func getRequestToken() {
        
        activityIndicatorView.startAnimating()
        
        let token = Constants.tmdbURL + "token/new?api_key=\(Constants.apiKey)"
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
//        let password = "d00msday"
        let session = Constants.tmdbURL + "token/validate_with_login?api_key=\(Constants.apiKey)&username=\(usernameText!)&password=\(passwdText!)&request_token=\(requestToken!)"
        let sessionURL = URL(string: session)
        let request = URLRequest(url: sessionURL!)
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
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
        let session = Constants.tmdbURL + "session/new?api_key=\(Constants.apiKey)&request_token=\(requestToken)"
        let sessionURL = URL(string: session)
        let request = URLRequest(url: sessionURL!)
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error == nil {
                if let data = data {
                    let parsedData: [String:AnyObject]!
                    do {
                        parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                        if let sessionID = parsedData["session_id"] as? String {
                            Constants.sessionID = sessionID
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
        getRequestToken()
    }
}

