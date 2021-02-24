//
//  NewsTableViewCell.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 23/02/2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageCell: UIImageView!
    @IBOutlet weak var newsLabelCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
