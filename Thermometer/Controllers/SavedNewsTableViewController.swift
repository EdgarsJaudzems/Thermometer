//
//  SavedNewsTableViewController.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 24/02/2021.
//

import UIKit
import CoreData

class SavedNewsTableViewController: UITableViewController {
    
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        warningPopUP(withTitle: "Saved for later", withMessage: "You can read saved for later articles")
    }
    
    func loadData(){
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        
        do{
            savedItems = try (context?.fetch(request))!
        }catch{
            warningPopUP(withTitle: "Nothing to load", withMessage: "Reading list is empty")
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func saveData() {
        do {
            try self.context?.save()
        } catch {
            fatalError(error.localizedDescription)
        }
        loadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedFeedCell", for: indexPath) as? NewsTableViewCell else{
            return UITableViewCell()
        }
        
        let item = savedItems[indexPath.row]
        
        cell.newsLabelCell.text = item.newsTitle
        cell.newsImageCell.loadImageFromUrl(urlString: item.image ?? "No image")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {_ in
                
                let item = self.savedItems[indexPath.row]
                
                self.context?.delete(item)
                self.saveData()
                
            }))
            self.present(alert, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "WebKitController") as? WebViewController else {
            return
        }
        
        vc.urlString = savedItems[indexPath.row].url!
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIImageView {
    func loadImageFromUrl(urlString : String) {
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
