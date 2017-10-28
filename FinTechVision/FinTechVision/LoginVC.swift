//
//  LoginVC.swift
//  FinTechVision
//
//  Created by Jordan Davis on 10/27/17.
//  Copyright © 2017 JDApps. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: UITextViewDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameText.resignFirstResponder()
        passwordText.resignFirstResponder()
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameText.layer.cornerRadius = usernameText.frame.height/2
        usernameText.clipsToBounds = true
        usernameText.delegate = self
        
        passwordText.layer.cornerRadius = passwordText.frame.height/2
        passwordText.clipsToBounds = true
        passwordText.delegate = self
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y:0, width: loginButton.frame.width+1, height: loginButton.frame.height)
        gradient.backgroundColor = UIColor.red.cgColor
        gradient.colors = [UIColor.init(red: 69.0/255, green: 104.0/255, blue: 220.0/255, alpha: 1).cgColor, UIColor.init(red: 176.0/255, green: 106.0/255, blue: 179.0/255, alpha: 1).cgColor]
        
        gradient.startPoint = .zero
        gradient.endPoint = .init(x: 1, y:0)
        loginButton.setBackgroundImage(nil, for: .normal)
        loginButton.layer.addSublayer(gradient)
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        loginButton.clipsToBounds = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if(passwordText.text != nil && usernameText.text != nil){
            let userController = UserController.sharedInstance
            userController.currentUser = usernameText.text
            userController.currentPassword = passwordText.text
            userController.loginUser(username: userController.currentUser!, password: userController.currentPassword!){ (success, error) -> () in
                if(success){
                    OperationQueue.main.addOperation {
                        let homeVC = HomeVC()
                        self.navigationController?.pushViewController(homeVC, animated: true)
                        return
                    }
                } else {
                    print("Error durring login" + error.debugDescription)
                    return
                }
            }
        } else {
            print("Invalid username / password")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
