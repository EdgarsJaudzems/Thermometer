//
//  ErrorExtension.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 20/02/2021.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnterCityName(city: String)
}

extension UIViewController {
    func warningPopUP(withTitle title: String?, withMessage message: String?) {
        DispatchQueue.main.async {
            let popUP = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            popUP.addAction(okButton)
            self.present(popUP, animated: true, completion: nil)
        }
    }
}
