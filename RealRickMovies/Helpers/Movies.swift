//
//  TMDBMovie.swift
//  RealRickMovies
//
//  Created by Ricky on 08.11.17.
//  Copyright © 2017 Ricky. All rights reserved.
//
import UIKit
import Foundation

struct Movies: Codable {
    
    var page: Int
    var total_results: Int
    var total_pages: Int
    var results: [Movie]
    
}

struct Movie: Codable {
    
    let vote_count: Int
    let id: Int
    let video: Bool
    let poster_path: String
    let release_date: String
    let title: String
    let popularity: Float
    let original_language: String
    let original_title: String
    let genre_ids: [Int]
    let backdrop_path: String
    let adult: Bool
    let overview: String
}

