//
//  NewsTableViewController.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 23/02/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import WebKit

class NewsTableViewController: UITableViewController {

    let newsDataModel = NewsDataModel()
    var item: [NewsDataModel] = []
    
    let newsURL = "http://newsapi.org/v2/everything?q=weather&sortBy=publishedAt&apiKey=23d84b84b6ec4512949301869ddfebef"
    var headlines = [String]()
    var images = [String]()
    var urls = [URL]()
    //var webView = WKWebView
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // webView = WKWebView()
        
        getNewsData(url: newsURL)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getNewsData(url: String) {
        AF.request(url, method: .get).responseJSON { (response) in
            if response.value != nil {
                let newsJSON: JSON = JSON(response.value!)
                print("newsJSON: ", newsJSON)
                
                let articles = newsJSON["articles"].arrayValue
                
                for article in articles {
                    let headlines = article["title"].stringValue
                    let images = article["urlToImage"].stringValue
                    let urls = article["url"].url

                    self.headlines.append(headlines)
                    self.images.append(images)
                    self.urls.append(urls!)
                }
                
              
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
 
    
   

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell

        cell.newsLabelCell.text = self.headlines[indexPath.row]
        cell.newsImageCell.load(urlString: self.images[indexPath.row])
       
        
        return cell
    }
}

extension UIImageView {
    func load(urlString : String) {
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

