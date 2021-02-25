//
//  SettingsViewController.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 25/02/2021.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var goToSettingsLabel: UILabel!
    @IBOutlet weak var darkModeTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelText()
    }
    
    
    @IBAction func darkModeSwitch(_ sender: Any) {
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
    
    func setLabelText() {
        var text = "Unable to specify UI style"
        if self.traitCollection.userInterfaceStyle == .dark {
            text = "Dark mode is ON"
        } else {
            text = "Dark mode is OFF"
        }
        
        darkModeTextLabel.text = text
    }
}

extension SettingsViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setLabelText()
    }
}
