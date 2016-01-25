//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Quyen Mac on 1/6/16.
//  Copyright © 2016 Quyen Mac. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //var refreshControl: UIRefreshControl!

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var movies: [NSDictionary]?
    
    //var filteredData: [NSDictionary]!
    let refreshControl = UIRefreshControl()
    
    //var filteredData: [String]!
    //var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movie View"

        tableView.dataSource = self
        tableView.delegate = self
        //searchMovie.dataSource = self
        searchBar.delegate = self
        
        //filteredData = movies
        
        //searchController = UISearchController(searchResultsController: nil)
        //searchController.searchResultsUpdater = self
        
        refreshControl.backgroundColor = UIColor.blackColor()
        refreshControl.tintColor = UIColor.whiteColor()
        
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // return target view
        var targetView: UIView{
            return self.view
        }
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            
                            self.tableView.reloadData()
                            //self.filteredData = self.movies
                            
                            
                            //self.refreshControl.endRefreshing()
                            
                    }
                }
        });
        task.resume()
        
        
        // Do any additional setup after loading the view.
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if let filteredData = filteredData {
        if let movies = movies {
            return movies.count
        } else {// if nill
            return 0
        }
        //return movies.count
        //return filteredData.count

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        //let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500/"
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        //filteredData = title
        
        cell.posterView.setImageWithURL(imageUrl!)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        //cell.textLabel!.text = title
        print("row \(indexPath.row)")
        return cell
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    /*func onRefresh(refreshControl: UIRefreshControl) {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (data, response, error) in
                
                // Reload tableView
                self.tableView.reloadData()
                refreshControl.endRefreshing()
        });
        task.resume()
    }*/
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        movies = searchText.isEmpty ? movies : movies!.filter({ (movie: NSDictionary) -> Bool in
            return (movie["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        self.tableView.reloadData()
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
