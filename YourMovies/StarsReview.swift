//
//  StarsReview.swift
//  YourMovies
//
//  Created by Esraa Hassan on 4/14/19.
//  Copyright © 2019 Esraa And Passant. All rights reserved.
//

import Foundation
import UIKit
class StarsReview
{
    var imageEmpty:UIImage = UIImage(named: "star-2.png")!
    var imageFilled:UIImage = UIImage(named: "star.png")!
    var imageHalf:UIImage = UIImage(named: "star-half.png")!
    
    func drawRatingStars(rateArray:[UIImageView] , rate:Double)
    {
        for item in 0...4
        {
            rateArray[item].image = imageEmpty
        }
        var ratInt:Int = Int(rate)
        for item in 0..<ratInt
        {
            rateArray[item].image = imageFilled
        }
        
        var valdouble: Double = rate - Double(ratInt)
        if valdouble > 0.5
        {
            rateArray[ratInt].image = imageHalf
        }
        
    }


    
    init()
    {
        
    }
    
}
