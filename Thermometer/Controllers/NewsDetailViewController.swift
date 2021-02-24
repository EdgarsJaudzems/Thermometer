//
//  NewsDetailViewController.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 24/02/2021.
//

import UIKit

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
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


    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
