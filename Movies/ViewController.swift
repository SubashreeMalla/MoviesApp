//
//  ViewController.swift
//  Movies
//
//  Created by Subashree Malla Lokanathan on 5/2/17.
//  Copyright © 2017 Subashree Malla Lokanathan. All rights reserved.
//

import UIKit
import ObjectMapper

class ViewController: UIViewController {
    @IBOutlet weak var tblvw: UITableView!
    @IBOutlet weak var actTableLoadIndicator: UIActivityIndicatorView!
    let searchController = UISearchController(searchResultsController: nil)
    var dataTask: URLSessionDataTask?
    var initialMoviesModel : MovieResultModel! // contains actual response from service - Movies list
    let baseURL: String = "https://api.themoviedb.org/3/search/movie?"
    let APIKey : String = "api_key=7c0db9f30c77052a21e985eac528b9d9"
    let postfixURL :String = "&language=en-US&page=1&include_adult=false&query="
    var filteredTableData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupSeachController()
        setUpNavBar()
        self.tblvw.tableHeaderView = searchController.searchBar
        self.tblvw.separatorColor = UIColor.orange
    }
    // Setup the Scope Bar
    func setUpNavBar(){
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
        self.navigationController?.navigationBar.topItem?.title = "Movies"
    }
    // Setup the Search Controller
    func setupSeachController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate=self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor.darkGray
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.barTintColor = UIColor.darkGray
        searchController.searchBar.tintColor = UIColor.orange
        searchController.searchBar.isTranslucent = true
    }
    /// Function to handle service call and map values
    func getMovies(searchString : String)
    {
        if searchString.isEmpty {
            if dataTask != nil {
                dataTask?.cancel()
            }
        }
        let searchTerm = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let strURL : String = baseURL+APIKey+postfixURL+searchTerm!
        let url:NSURL = NSURL(string: strURL)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        actTableLoadIndicator.startAnimating()
        self.dataTask = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            if error == nil {
                do{
                    let json : Any = try JSONSerialization.jsonObject (with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) // get array of values from data
                    self.initialMoviesModel = Mapper<MovieResultModel>().map(JSONObject: json)!
                    DispatchQueue.main.async {
                        if self.initialMoviesModel.results?.count == 0 {
                            self.showErrorAler(title: "No match found", message: "Please try again with a different movie name.")
                        }
                        self.actTableLoadIndicator.stopAnimating()
                        self.tblvw.reloadData()
                    }
                }
                catch{
                    self.showErrorAler(title: "Sorry", message: "Please try again.")
                }
            } else {
                self.showErrorAler(title: "Sorry", message: "Please try again.")
            }
        }
        )
        self.dataTask?.resume()
    }
    ///Alert view display Handling - failure alerts
    func showErrorAler(title: String, message: String) {
        DispatchQueue.main.async {
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertView, animated: true, completion: nil)
            self.actTableLoadIndicator.stopAnimating()
        }
    }
    func getNewsImageForCell(urlString: String, cellForRowAtIndexPath indexPath: NSIndexPath) {
        var image: UIImage?
        DispatchQueue.global(qos: .userInitiated).async {
            let baseURL = URL(string:urlString)
            do {
                let weatherData = try NSData(contentsOf: baseURL!, options: NSData.ReadingOptions())
                image =  UIImage(data: weatherData as Data)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                let cell = self.tblvw.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath as IndexPath) as! MovieListTableViewCell
                cell.imgVwPoster.image = image
                self.initialMoviesModel.results?[indexPath.row].isimageLoaded = true
                self.initialMoviesModel.results?[indexPath.row].imgMovieIcon = image ?? UIImage(named: "no_image_icon")
                self.tblvw.reloadRows(at: [indexPath as IndexPath], with: .none)
            }
        }
    }
    func configureCellImage(cell: MovieListTableViewCell,for indexPath: IndexPath){
        if initialMoviesModel.results?[indexPath.row].isimageLoaded == false {
            let url = "http://image.tmdb.org/t/p/w185/" + ((self.initialMoviesModel.results?[indexPath.row].poster_path) ?? "" )
            cell.cellLoading.startAnimating()
            cell.imgVwPoster.image = nil
            getNewsImageForCell(urlString: url, cellForRowAtIndexPath: indexPath as NSIndexPath)
        }
        else if initialMoviesModel.results?[indexPath.row].imgMovieIcon != nil{
            cell.imgVwPoster.image = initialMoviesModel.results?[indexPath.row].imgMovieIcon
        }
        else {
            cell.imgVwPoster.image = UIImage(named: "no_image_icon")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (searchController.isActive) {
            
            if self.initialMoviesModel != nil {
                return (self.initialMoviesModel.results?.count)!
            }
            return 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieListTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        configureCellImage(cell: cell, for: indexPath)
        cell.lblOriginalTitle.text = self.initialMoviesModel.results?[indexPath.row].original_title
        let yourAttributes = [NSForegroundColorAttributeName: UIColor.orange, NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 18.0)]
        let yourOtherAttributes = [NSForegroundColorAttributeName: UIColor.darkGray, NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 18.0)]
        let partOne = NSMutableAttributedString(string: "Vote Count: ", attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: String(describing: (self.initialMoviesModel.results?[indexPath.row].vote_count)!), attributes: yourOtherAttributes)
        let combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(partTwo)
        cell.lblMovieVotes.attributedText = combination
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            if let navigator = navigationController {
                viewController.selectedMoviesModel = self.initialMoviesModel.results?[indexPath.row]
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension ViewController: UISearchBarDelegate{
    /// Serach bar actions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getMovies(searchString: searchBar.text!)
    }
}

extension ViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController)
    {
        
    }
}
