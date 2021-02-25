//
//  NewsTableViewController.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 23/02/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsTableViewController: UITableViewController {

    let newsDataModel = NewsDataModel()
    var item: [NewsDataModel] = []
    
    let newsURL = "http://newsapi.org/v2/everything?q=weather&sortBy=publishedAt&apiKey=23d84b84b6ec4512949301869ddfebef"
    var headlines = [String]()
    var images = [String]()
    var content = [String]()
    var urls = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNewsData(url: newsURL)

    }
    @IBAction func infoButtonTapped(_ sender: Any) {
        warningPopUP(withTitle: "Weather News", withMessage: "Find out latest weather news in your feed")
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
                    let content = article["description"].stringValue
                    let urls = article["url"].stringValue

                    self.headlines.append(headlines)
                    self.images.append(images)
                    self.content.append(content)
                    self.urls.append(urls)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "NewsDetailViewController") as? NewsDetailViewController else {
            return
        }
       
        vc.titleString = headlines[indexPath.row]
        vc.contentString = content[indexPath.row]
        vc.webURLString = urls[indexPath.row]
        vc.newsImages = images[indexPath.row]
        
            
        navigationController?.pushViewController(vc, animated: true)
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

