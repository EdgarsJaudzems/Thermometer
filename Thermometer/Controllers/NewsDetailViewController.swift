//
//  NewsDetailViewController.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 24/02/2021.
//

import UIKit
import CoreData

class NewsDetailViewController: UIViewController {
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    //Core data
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    
    var webURLString = String()
    var titleString = String()
    var contentString = String()
    var newsImages = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(webURLString)
        newsTitleLabel.text = titleString
        newsDescriptionLabel.text = contentString
        newsImage.loadImage(urlString: self.newsImages)
        
        //Core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func savedBUttonTapped(_ sender: Any) {
        // Saving to core data
        let newItem = Items(context: self.context!)
        newItem.newsTitle = titleString
        newItem.newsContent = contentString
        newItem.url = webURLString
        newItem.image = newsImages
        
        // Appending core data and save items
        self.savedItems.append(newItem)
        saveData()
    }
    
    // saving core data
    func saveData() {
        do {
            try context?.save()
        } catch {
            // alert
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let destination: WebViewController = segue.destination as! WebViewController
        // Pass the selected object to the new view controller.
        destination.urlString = webURLString
    }
}

extension UIImageView {
    func loadImage(urlString : String) {
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
