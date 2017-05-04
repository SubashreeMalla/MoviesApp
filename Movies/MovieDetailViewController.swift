//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Subashree Malla Lokanathan on 5/2/17.
//  Copyright © 2017 Subashree Malla Lokanathan. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var selectedMoviesModel : ResultsModel!
    var baseURL : URL!
    @IBOutlet weak var tblVw: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func downloadImageFrom(link:String, cell: MovieImageDetailCell) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let data = data
                {
                    cell.bannerLoading.stopAnimating()
                    cell.imgCover.image = UIImage(data: data)
                }
            }
        }).resume()
    }
    func calculateHeight(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: width, height: CGFloat.greatestFiniteMagnitude) )
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    func getAttributedTextWith(mainText: String, And detailText: String) -> NSAttributedString {
        let yourAttributes = [NSForegroundColorAttributeName: UIColor.orange, NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 12.0)]
        let yourOtherAttributes = [NSForegroundColorAttributeName: UIColor.darkGray, NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 15.0)]
        let partOne = NSMutableAttributedString(string: mainText, attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: detailText, attributes: yourOtherAttributes)
        let combinationText = NSMutableAttributedString()
        combinationText.append(partOne)
        combinationText.append(partTwo)
        return combinationText
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MovieDetailViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.row {
        case 0:
            return 300.0
        case 1:
            return 20.0
        case 2:
            return 20.0
        case 3:
            return 20.0
        case 4:
            let height:CGFloat = calculateHeight(text:selectedMoviesModel.overview!, font:UIFont(name: "HelveticaNeue-Bold", size: 12.0)!, width:self.view.frame.size.width )
            return height+50.0
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: "MovieOtherDetailCell")
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailCell") as! MovieImageDetailCell
            cell.lblOriginalTitle?.text = selectedMoviesModel.original_title
            cell.imgPoster.image = selectedMoviesModel.imgMovieIcon
            if let backdroppath = self.selectedMoviesModel.backdrop_path {
                let coverimgURL = "http://image.tmdb.org/t/p/w185/"+backdroppath
                cell.bannerLoading.startAnimating()
                self.downloadImageFrom(link: coverimgURL, cell: cell)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieOtherDetailCell")
            cell?.textLabel?.attributedText = getAttributedTextWith(mainText: "ID: ", And: String(describing: self.selectedMoviesModel.id!))
            cell?.detailTextLabel?.text = selectedMoviesModel.adult! ? "R" : "G"
            return cell!
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieOtherDetailCell")
            cell?.textLabel?.attributedText = getAttributedTextWith(mainText: "Release Date: ", And:  String(describing: self.selectedMoviesModel.release_date!))
            cell?.detailTextLabel?.text = self.selectedMoviesModel.original_language!
            return cell!
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieOtherDetailCell")
            cell?.textLabel?.attributedText = getAttributedTextWith(mainText: "Popularity: ", And: String(describing: self.selectedMoviesModel.popularity!))
            cell?.detailTextLabel?.text = String(describing: self.selectedMoviesModel.vote_count!)
            return cell!
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieOverviewCell")
            cell?.detailTextLabel?.sizeToFit()
            cell?.detailTextLabel?.text = self.selectedMoviesModel.overview!
            return cell!
            
        default:
            print("No Choice")
        }
        return defaultCell!
    }
}
