//
//  NewsDataModel.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 23/02/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsDataModel {

    let apiUrl = "http://newsapi.org/v2/everything?q=weather&from=2021-01-23&sortBy=publishedAt&apiKey=23d84b84b6ec4512949301869ddfebef"

    var description = ""
    var title = ""
    var url = ""
    var urlToImage = ""
    var image: UIImage?


}
