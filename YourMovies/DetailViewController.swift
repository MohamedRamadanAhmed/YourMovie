//
//  DetailViewController.swift
//  YourMovies
//
//  Created by Esraa Hassan on 3/31/19.
//  Copyright © 2019 Esraa And Passant. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import CoreData


class DetailViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    
    
    var movie:Movie!
    var appDeleget : AppDelegate!
    var flag:Int!
    var TrailersURL : String!//("https://api.themoviedb.org/3/movie/11551/videos?api_key=9954ca5e3676dde39e5c5bc996558f2a&language=en-US")

    var trailers:Array<Trailer>?
    
    @IBOutlet weak var trailersTableView: UITableView!
    @IBOutlet weak var FavoriteBtn: UIButton!
    @IBOutlet weak var rateStar1: UIImageView!
    @IBOutlet weak var rateStar2: UIImageView!
    @IBOutlet weak var rateStar3: UIImageView!
    @IBOutlet weak var rateStar4: UIImageView!
    @IBOutlet weak var rateStare5: UIImageView!
    
    @IBAction func addToFavorite(_ sender: Any) {
        if isMovieExist(id: movie.id)
        {
            deleteMovieFromFavorite(movie: movie)
            if isTraillerExist(movieId: movie.id)
            {
                deleteMovieTrailersFromFavorite(movie: movie)
            }
            
            FavoriteBtn.setTitleColor(UIColor.black, for: .normal)
            FavoriteBtn.setTitle("Add To Favorite", for: .normal)
            

        }
        else{
        saveMovieToFavorite(movie: movie)
            if !isTraillerExist(movieId: movie.id)
            {
                saveTrailesrOfMovie(trailersArray: trailers!)
            }
            FavoriteBtn.setTitleColor(UIColor.red, for: .normal)
             FavoriteBtn.setTitle("Remove From Favorite", for: .normal)
        }
        
        
    }
    
    

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var labelRate: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var labelpreview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailers = []
        //********** rating Star **********
        let arrStars:[UIImageView] = [rateStar1,rateStar2,rateStar3,rateStar4,rateStare5]
        var stasreview:StarsReview = StarsReview()
        stasreview.drawRatingStars(rateArray: arrStars, rate: (movie.vot/2))
        
        //*********************************
        print("id = \(movie?.id as! Int)")
        TrailersURL = "https://api.themoviedb.org/3/movie/\(movie?.id as! Int)/videos?api_key=9954ca5e3676dde39e5c5bc996558f2a&language=en-US"
        //************************* get Trailer ****************
        if flag == 1
        {
            let appDeleget1 = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDeleget1.persistentContainer.viewContext
            let fechRequest = NSFetchRequest<NSManagedObject>(entityName: "Trailler")
            print("hello from feching trailers id: \(movie.id)")
            var  trailersarray:[NSManagedObject]!
            fechRequest.predicate = NSPredicate(format: "movieID = %d", movie.id as! Int)
            do{
                trailersarray = try managedContext.fetch(fechRequest)
                print("hello from feching trailers id: \(movie.id)")
                

                self.trailersTableView.reloadData()
                
            }catch let error as NSError{
                print("error code : \(error.code)")
            }
            for item in  0..<trailersarray!.count
            {
                var trailer = Trailer(MovieID: trailersarray![item].value(forKey: "movieID") as! Int, TrailerKey: trailersarray![item].value(forKey: "name") as! String, TrailerName: trailersarray![item].value(forKey: "trailerURL") as! String)
                trailers?.append(trailer)
                print("movie name \(trailers![item].name)")
            }
            self.trailersTableView.reloadData()
            
        }else{
            DispatchQueue.main.async {
                Alamofire.request(self.TrailersURL).responseJSON { (responseObject) -> Void in
                    
                    
                    if let responseValue = responseObject.result.value as! [String: Any]? {
                        if let responseFoods = responseValue["results"] as! [[String: Any]]? {
                            for item in responseFoods
                            {
                                var trailler = Trailer(MovieID: self.movie.id, TrailerKey: item["key"] as! String,TrailerName: item["name"] as! String)
                                self.trailers?.append(trailler)
                                
                                print("trailer name : \(item["name"])")
                                print("item  : \(item["poster_path"])")
                            }
                            self.trailersTableView.reloadData()
                            
                        }
                    }
                }
                
                
            }
        }
        
        //******************************************************
        if isMovieExist(id: movie.id)
        {
            FavoriteBtn.setTitle("Remove From Favorite", for: .normal)
            FavoriteBtn.setTitleColor(UIColor.red, for: .normal)
          /*  var image:UIImage = UIImage(named: "star.png")!
            FavoriteBtn.setImage(image, for: .normal)
            FavoriteBtn.contentVerticalAlignment = .fill
            FavoriteBtn.contentHorizontalAlignment = .fill
            FavoriteBtn.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1)
 */
        }else{
            FavoriteBtn.setTitle("Add To Favorite", for: .normal)
          /*  var image:UIImage = UIImage(named: "star-2.png")!
            FavoriteBtn.setImage(image, for: .normal)
            FavoriteBtn.contentVerticalAlignment = .fill
            FavoriteBtn.contentHorizontalAlignment = .fill
            FavoriteBtn.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1)*/
        }
        
        

        labelTitle.text = movie.title
        labelRate.text = String("\(movie.vot)")
        labelReleaseDate.text = movie.releasDate
        labelpreview.text = movie.overview
        language.text = movie.langauge
        imageMovie.sd_setImage(with:URL(string: movie.image), placeholderImage: UIImage(named: "placeholder.png"))
        
    }
    func saveMovieToFavorite(movie:Movie)
    {
        appDeleget = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDeleget.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteMovie", in: managedContext)
        let m = NSManagedObject(entity: entity!, insertInto: managedContext)
        m.setValue(movie.title, forKey: "title")
        m.setValue(movie.releasDate, forKey: "releaseDate")
        m.setValue(movie.overview, forKey: "overview")
        m.setValue(movie.image, forKey: "image")
        m.setValue(movie.langauge, forKey: "langauge")
        m.setValue(movie.popularity, forKey: "popularity")
        m.setValue(movie.id, forKey: "id")
        m.setValue(movie.vot, forKey: "vote")
        print("movie added")
        
    }
    
    func saveTrailesrOfMovie(trailersArray:[Trailer])
    {
        appDeleget = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDeleget.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Trailler", in: managedContext)
        let m = NSManagedObject(entity: entity!, insertInto: managedContext)
        for item in trailersArray
        {
            m.setValue(item.movieID, forKey: "movieID")
            m.setValue(item.name, forKey: "name")
            m.setValue(item.trailerURL, forKey: "trailerURL")
            print("trailler added")
        }
        
    }
    func isTraillerExist(movieId:Int)->Bool
    {
        appDeleget = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDeleget.persistentContainer.viewContext
        let fechRequest = NSFetchRequest<NSManagedObject>(entityName: "Trailler")
        fechRequest.predicate = NSPredicate(format: "movieID = %d", movieId)
        var traillers:Array<NSManagedObject>!
        do{
            traillers = try managedContext.fetch(fechRequest)
            
            
        }catch let error as NSError{
            print("error code : \(error.code)")
        }
        return traillers.count > 0
        
    }
    
    func isMovieExist(id:Int)->Bool
    {
        appDeleget = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDeleget.persistentContainer.viewContext
        let fechRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovie")
        fechRequest.predicate = NSPredicate(format: "id = %d", id)
        var movies:Array<NSManagedObject>!
        do{
            movies = try managedContext.fetch(fechRequest)
            
            
        }catch let error as NSError{
            print("error code : \(error.code)")
        }
        return movies.count > 0
    }
    
    func deleteMovieFromFavorite(movie:Movie)
    {
        appDeleget = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDeleget.persistentContainer.viewContext
        let fechRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovie")
        fechRequest.predicate = NSPredicate(format: "id = %d", movie.id)
        var movies:Array<NSManagedObject>!
        do{
            movies = try managedContext.fetch(fechRequest)
            
            
        }catch let error as NSError{
            print("error code : \(error.code)")
        }
        for obj in movies! {
            managedContext.delete(obj)
        }
        
        do {
            try managedContext.save() // <- remember to put this :)
        } catch let error as NSError {
            // Do something... fatalerror
            print("Error while deleting object : \(error.localizedDescription)")
        }
        
    }
    
    func deleteMovieTrailersFromFavorite(movie:Movie)
    {
        appDeleget = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDeleget.persistentContainer.viewContext
        let fechRequest = NSFetchRequest<NSManagedObject>(entityName: "Trailler")
        fechRequest.predicate = NSPredicate(format: "movieID = %d", movie.id)
        var movies:Array<NSManagedObject>!
        do{
            movies = try managedContext.fetch(fechRequest)
            
            
        }catch let error as NSError{
            print("error code : \(error.code)")
        }
        for obj in movies! {
            managedContext.delete(obj)
        }
        
        do {
            try managedContext.save() // <- remember to put this :)
        } catch let error as NSError {
            // Do something... fatalerror
            print("Error while deleting object : \(error.localizedDescription)")
        }
        
    }
    
    //********* TableView **********
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("trailers count : \(String(describing: trailers?.count))")
        
        return (trailers?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = trailersTableView.dequeueReusableCell(withIdentifier: "TraillerCell", for: indexPath)
        cell.textLabel?.text = trailers![indexPath.row].name
        cell.imageView?.image = UIImage(named: "youtube.jpg")
        return cell
        // cell.imageView?.sd_setImage(with: <#T##URL?#>, completed: <#T##SDExternalCompletionBlock?##SDExternalCompletionBlock?##(UIImage?, Error?, SDImageCacheType, URL?) -> Void#>)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var youtubeURl = String("https://www.youtube.com/watch?v=")
        youtubeURl.append((trailers?[indexPath.row].trailerURL)! )
        
        let YOUTUBE = NSURL(string: youtubeURl)
        
        if(UIApplication.shared.canOpenURL(YOUTUBE! as URL)){
            UIApplication.shared.open(YOUTUBE! as URL, options: [:], completionHandler: nil)
        }else{
            print("Cannot open youtube")
        }
    }
    @IBAction func seeAllReviews(_ sender: Any) {
        let reviewController = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: "reviewController") as! ReviewTableViewController
        reviewController.movie = movie
        self.navigationController?.pushViewController(reviewController, animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
