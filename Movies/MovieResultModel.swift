//
//  MovieResultModel.swift
//  Movies
//
//  Created by Subashree Malla Lokanathan on 5/3/17.
//  Copyright © 2017 Subashree Malla Lokanathan. All rights reserved.
//

import UIKit
import ObjectMapper

class MovieResultModel: Mappable {
    var page : Int?
    var results : [ResultsModel]?
    var total_pages : Int?
    var total_results : Int?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        page   <- map["page"]
        results  <- map["results"]
        total_results   <- map["total_results"]
        total_pages   <- map["total_pages"]
    }
}

class ResultsModel: Mappable {
    
    var poster_path: String?
    var adult: Bool?
    var overview: String?
    var release_date: String?
    var genre_ids: [Int]?
    var id : Int?
    var original_title: String?
    var original_language: String?
    var title: String?
    var backdrop_path: String?
    var popularity: Double?
    var vote_count: Int?
    var video: Bool?
    var vote_average : Double?
    var isimageLoaded : Bool?
    var imgMovieIcon : UIImage?
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        poster_path   <- map["poster_path"]
        adult  <- map["adult"]
        overview  <- map["overview"]
        release_date  <- map["release_date"]
        genre_ids  <- map["genre_ids"]
        id <- map["id"]
        original_title  <- map["original_title"]
        original_language  <- map["original_language"]
        title  <- map["title"]
        backdrop_path  <- map["backdrop_path"]
        popularity  <- map["popularity"]
        vote_count  <- map["vote_count"]
        video  <- map["video"]
        vote_average  <- map["vote_average"]
        isimageLoaded = false
        if release_date != nil{ // handle nil vlaue for date
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let showDate = inputFormatter.date(from: release_date!)
            inputFormatter.dateFormat = "MMM d, yyyy"
            var resultString = ""
            if showDate != nil{
                resultString = inputFormatter.string(from: showDate!)
            }
            release_date = resultString
            
        }
    }
    


}
