//
//  SettingsViewController.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 25/02/2021.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
 
    @IBAction func settings(_ sender: Any) {
        openSettings()
    }
    
    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:]) { (success) in
                print("open: ", success)
            }
        }
    }
}

