//
//  Movie.swift
//  YourMovies
//
//  Created by Esraa Hassan on 3/30/19.
//  Copyright © 2019 Esraa And Passant. All rights reserved.
//

import Foundation
public struct Movie
{
    var id:Int!
    var title:String!
    //computed
    var image:String!
    //computed
    var image2:String{
        set (img){
            
           // self.image2 = img
          
        }
        get{
            var fullURL = "http://image.tmdb.org/t/p/w185/"
            fullURL += image2
            return  fullURL
        }
    }
    var langauge:String
    var releasDate:String
    var overview:String
    var vot:Double
    var popularity:Double
    init(MovieID id:Int ,Title title:String) {
        langauge = "en"
        releasDate = ""
        overview = ""
        vot = -1
        popularity = 0.0
        self.image = "http://image.tmdb.org/t/p/w185/nBNZadXqJSdt05SHLqgT0HuC5Gm.jpg"
        self.image2="nBNZadXqJSdt05SHLqgT0HuC5Gm.jpg"
        self.id=id
        self.title = title
        
    }
    
    
    
}
