//
//  Trailer.swift
//  YourMovies
//
//  Created by Esraa Hassan on 4/7/19.
//  Copyright © 2019 Esraa And Passant. All rights reserved.
//

import Foundation
struct Trailer {
    var movieID:Int!
    var trailerURL:String!
    var name:String!
    init(MovieID id:Int ,TrailerKey key:String,TrailerName name1:String) {
        
        self.movieID = id
        self.trailerURL = key
        self.name = name1
        
    }
}

