//
//  HomeCollectionViewController.swift
//  YourMovies
//
//  Created by Esraa Hassan on 3/29/19.
//  Copyright © 2019 Esraa And Passant. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
//private let reuseIdentifier = "cellMovie"

class HomeCollectionViewController: UICollectionViewController {
    var strURL:String = "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=9954ca5e3676dde39e5c5bc996558f2a"
    var movies:Array<Movie>?

    
    @IBAction func sortRate(_ sender: UIBarButtonItem) {
        movies = movies?.sorted(by: {$0.vot > $1.vot})
        /*   movies = movies?.sort(by: { ( m, m2) -> Bool in
         return m.vot > m2.vot
         })*/
        self.collectionView?.reloadData()
        print("sort by rate ")

    }
    
    @IBAction func sortByPopularity(_ sender: Any) {
        /*movies?.sort(by: { ( m, m2) -> Bool in
            return m.popularity > m2.popularity
        })*/
        movies = movies?.sorted(by: {$0.vot > $1.vot})
        self.collectionView?.reloadData()
        print("sort")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello ")
        //*******************
        
   struct Storyboard {
            static let photoCell = "Grid"
            static let leftAndRightPaddings: CGFloat = 0.0
            static let numberOfItemPerRow: CGFloat = 4.0
        }
     let collectionViewWidth = collectionView?.frame.width;
        let itemWidth = (collectionViewWidth! - Storyboard.leftAndRightPaddings)/Storyboard.numberOfItemPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth+10, height: 180)
        //*******************
        movies = []
        DispatchQueue.main.async {
            Alamofire.request(self.strURL).responseJSON { (responseObject) -> Void in
                
                
                if let responseValue = responseObject.result.value as! [String: Any]? {
                    if let responseFoods = responseValue["results"] as! [[String: Any]]? {
                        for item in responseFoods
                        {
                            var mov = Movie(MovieID: item["id"] as! Int, Title: item["title"] as! String)
                            var imgurl = String("https://image.tmdb.org/t/p/w185")
                            if ((item["poster_path"] as? String) != nil)
                            {
                                imgurl.append(item["poster_path"] as? String ?? "")
                                mov.image = imgurl
                            }
                           
                            mov.releasDate = item["release_date"] as? String ?? ""
                            mov.image2 = item["backdrop_path"] as? String ?? ""
                            mov.langauge = item["original_language"] as? String ?? ""
                            mov.overview = item["overview"] as? String ?? ""
                            mov.vot = item["vote_average"] as? Double ?? 0.0
                            mov.popularity = item["popularity"] as? Double ?? 0.0
                            self.movies?.append(mov)
                            self.collectionView?.reloadData()
                            print("item  : \(item["poster_path"])")
                        }
                        
                        //print(responseFoods)
                        //self.tableView?.reloadData()
                    }
                }
        }
        
            //            if responseObject.result.isFailure {
            //                let error : NSError = responseObject.result.error!
            //                failure(error)
            //            }
            
            
        }
        //var movie = Movie(MovieID: 1, Title: "Hello")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
      //  self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("count : \(movies?.count)")
        return (movies?.count)!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellMovie", for: indexPath)
    
        // Configure the cell
        print(movies![indexPath.row].image)
        var imageview:UIImageView = cell.viewWithTag(1) as! UIImageView
        imageview.sd_setImage(with:URL(string: movies![indexPath.item].image), placeholderImage: UIImage(named: "placeholder.png"))
        
       var labelRate:UILabel = cell.viewWithTag(2) as! UILabel
        labelRate.text = ""
       // labelRate.text = String("\(movies![indexPath.item].vot)")
        var starImag1:UIImageView = cell.viewWithTag(5) as! UIImageView
        var starImag2:UIImageView = cell.viewWithTag(6) as! UIImageView
        var starImag3:UIImageView = cell.viewWithTag(7) as! UIImageView
        var starImag4:UIImageView = cell.viewWithTag(8) as! UIImageView
        var starImag5:UIImageView = cell.viewWithTag(9) as! UIImageView
        let arrStars:[UIImageView] = [starImag1,starImag2,starImag3,starImag4,starImag5]
        var stasreview:StarsReview = StarsReview()
        stasreview.drawRatingStars(rateArray: arrStars, rate: ((movies![indexPath.item].vot)/2))
        
        
    
        return cell
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        var detailController:DetailViewController = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: "detailcontroller") as! DetailViewController
        detailController.movie = movies![indexPath.row]
        detailController.flag = 2
        self.navigationController?.pushViewController(detailController, animated: true)
        
        return true
    }
 

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
