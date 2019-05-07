//
//  FavoriteCollectionViewController.swift
//  YourMovies
//
//  Created by Esraa Hassan on 4/3/19.
//  Copyright © 2019 Esraa And Passant. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SDWebImage

private let reuseIdentifier = "cell"
var appDeleget:AppDelegate!
var movies:[NSManagedObject]!

class FavoriteCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        appDeleget = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDeleget.persistentContainer.viewContext
        let fechRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovie")
        do{
            movies = try managedContext.fetch(fechRequest)
            self.collectionView?.reloadData()
            
        }catch let error as NSError{
            print("error code : \(error.code)")
        }
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> FavoriteViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavoriteViewCell
    
        // Configure the cell
        let s = movies![indexPath.item].value(forKey: "image") as! String
        print(s)
        
        cell.IVFavoriteImage.sd_setImage(with:URL(string: movies![indexPath.item].value(forKey: "image") as! String), placeholderImage: UIImage(named: "placeholder.png"))
        cell.labelRate.text = "\(movies?[indexPath.item].value(forKey: "vote") as! Double)"
    
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let detailController:DetailViewController = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: "detailcontroller") as! DetailViewController
        var movie = Movie(MovieID: movies![indexPath.item].value(forKey: "id") as! Int, Title: movies![indexPath.item].value(forKey: "title") as! String)
        movie.image = movies![indexPath.item].value(forKey: "image") as! String
        movie.overview = movies![indexPath.item].value(forKey: "overview") as! String
        movie.releasDate = movies![indexPath.item].value(forKey: "releaseDate") as! String
        movie.vot = Double(movies![indexPath.item].value(forKey: "vote") as! Double)
        movie.popularity = Double(movies![indexPath.item].value(forKey: "popularity") as! Double)
        detailController.movie = movie
        detailController.flag = 1
        self.navigationController?.pushViewController(detailController, animated: true)
        
        return true
    }
   

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */

    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

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
