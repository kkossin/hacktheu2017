//
//  SignUpVC.swift
//  FinTechVision
//
//  Created by Jordan Davis on 10/27/17.
//  Copyright © 2017 JDApps. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var password1Text: UITextField!
    @IBOutlet weak var password2Text: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: UITextViewDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameText.resignFirstResponder()
        password1Text.resignFirstResponder()
        password2Text.resignFirstResponder()
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameText.layer.cornerRadius = usernameText.frame.height/2
        usernameText.clipsToBounds = true
        usernameText.delegate = self
        
        password1Text.layer.cornerRadius = password1Text.frame.height/2
        password1Text.clipsToBounds = true
        password1Text.delegate = self
        
        password2Text.layer.cornerRadius = password2Text.frame.height/2
        password2Text.clipsToBounds = true
        password2Text.delegate = self
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y:0, width: signupButton.frame.width+1, height: signupButton.frame.height)
        gradient.backgroundColor = UIColor.red.cgColor
        gradient.colors = [UIColor.init(red: 69.0/255, green: 104.0/255, blue: 220.0/255, alpha: 1).cgColor, UIColor.init(red: 176.0/255, green: 106.0/255, blue: 179.0/255, alpha: 1).cgColor]
        
        gradient.startPoint = .zero
        gradient.endPoint = .init(x: 1, y:0)
        signupButton.setBackgroundImage(nil, for: .normal)
        signupButton.layer.addSublayer(gradient)
        signupButton.layer.cornerRadius = signupButton.frame.height/2
        signupButton.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        if(password1Text.text == password2Text.text && (password1Text.text != nil && usernameText.text != nil)){
            let userController = UserController.sharedInstance
            userController.currentUser = usernameText.text
            userController.currentPassword = password1Text.text
            userController.registerNewUser(username: userController.currentUser!, password: userController.currentPassword!){ (success, error) -> () in
                if(success){
                    OperationQueue.main.addOperation {
                        let cameraVC = CameraVC()
                        self.navigationController?.pushViewController(cameraVC, animated: true)
                        return
                    }
                } else {
                    print("Error durring signup " + error.debugDescription)
                    return
                }
            }
        } else {
            print("Passwords not the same!!")
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
