//
//  ViewController.swift
//  Instagram
//
//  Created by N Manisha Reddy on 2/14/18.
//  Copyright © 2018 N Manisha Reddy. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
   var signUp = false

    @IBOutlet weak var switchMode: UIButton!
    @IBOutlet weak var loginOrSignUp: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    func displayAlert(title:String,message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
 
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        switchMode.buttonShape()
        loginOrSignUp.buttonShape()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "showTable", sender: self)

        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func switchButton(_ sender: Any) {
        if signUp {
            signUp = false
            loginOrSignUp.setTitle("login", for: [])
            switchMode.setTitle("signUp", for: [])
            
        } else {
            signUp = true
            loginOrSignUp.setTitle("signUp", for: [])
            switchMode.setTitle("login", for: [])
            
        }
        
        
    }
    @IBAction func loginOrSignUpButton(_ sender: Any) {
        if userNameTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "ALERT", message: "please enter username and/or password")
           
                   }
        else {
            if signUp {
                print ("signing up")
                let user = PFUser()
                user.username = userNameTextField.text
                user.password = passwordTextField.text
                user.email = userNameTextField.text
                user.signUpInBackground(block: { (success, error) in
                    if let error = error {
                        self.displayAlert(title: "Error in signing up", message: error.localizedDescription)
                        print(error)
                    }
                    else {
                        print("signing up")
                        self.performSegue(withIdentifier: "showTable", sender: self)
                    }
                })
                
           
            } else {
                PFUser.logInWithUsername(inBackground: userNameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    if user != nil {
                        print("login successful")
                        self.performSegue(withIdentifier: "showTable", sender: self)

                        
                    } else {
                        if let error = error {
                              self.displayAlert(title: "Error in loginig in", message: error.localizedDescription)
                        }
                    }
                    
                })
            }
        }
            
        }
    
        
        
    }

extension UIButton {
    func buttonShape() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}

















