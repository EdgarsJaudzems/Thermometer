//
//  ViewController.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 20/02/2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    @IBOutlet weak var thermometerImage: UIImageView!
    
    private let username = "a"
    private let password = "a"
    
    let notificationCenter = NotificationCenter.default
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if userDefaults.stringArray(forKey: "username") != nil {
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 150
            
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            
            let titleImageView = UIImageView(image: UIImage(systemName: "thermometer"))
            titleImageView.frame = CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height)
            
            navigationItem.titleView = titleView
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0  {
            self.view.frame.origin.y += 150
            
            navigationItem.titleView?.isHidden = true
        }
    }
    
    func handleLogin() {
        guard usernameTextField.text == username, passwordTextField.text == password else {
            warningPopUP(withTitle: "Invalid login", withMessage: "Please enter correct username and password")
            return
        }
        
        userDefaults.set(username, forKey: "enter username")
        userDefaults.set(password, forKey: "enter password")
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        handleLogin()
    }
    
    @IBAction func forgotUsernameButtonTapped(_ sender: Any) {
        warningPopUP(withTitle: "Ooops!", withMessage: "Your username is: \(username)")
    }
    
    @IBAction func ForgotPasswordButtonTapped(_ sender: Any) {
        warningPopUP(withTitle: "Ooops!", withMessage: "Your password is: \(password)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "LoginViewController" {
        _ = segue.destination as! WeatherViewController
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            handleLogin()
        }
        return true
    }
}


