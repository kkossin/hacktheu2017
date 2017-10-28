//
//  SplashVC.swift
//  FinTechVision
//
//  Created by Jordan Davis on 10/27/17.
//  Copyright © 2017 JDApps. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emojiView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y:0, width: signupButton.frame.width+1, height: signupButton.frame.height)
        gradient.backgroundColor = UIColor.red.cgColor
        gradient.colors = [UIColor.init(red: 69.0/255, green: 104.0/255, blue: 220.0/255, alpha: 1).cgColor, UIColor.init(red: 176.0/255, green: 106.0/255, blue: 179.0/255, alpha: 1).cgColor]
        
        gradient.startPoint = .zero
        gradient.endPoint = .init(x: 1, y:0)
        
        let gradient1 = CAGradientLayer()
        gradient1.frame = CGRect(x: 0, y:0, width: loginButton.frame.width+1, height: signupButton.frame.height)
        gradient1.backgroundColor = UIColor.red.cgColor
        gradient1.colors = [UIColor.init(red: 1, green: 153.0/255, blue: 102.0/255, alpha: 1).cgColor, UIColor.init(red: 1, green: 94.0/255, blue: 98.0/255, alpha: 1).cgColor]
        gradient1.startPoint = .zero
        gradient1.endPoint = .init(x: 1, y:0)
        
        signupButton.setBackgroundImage(nil, for: .normal)
        signupButton.layer.addSublayer(gradient)
        signupButton.layer.cornerRadius = signupButton.frame.height/2
        signupButton.clipsToBounds = true
        
        
        loginButton.setBackgroundImage(nil, for: .normal)
        loginButton.layer.addSublayer(gradient1)
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        loginButton.clipsToBounds = true
        
        let bundlePath = Bundle.main.path(forResource: "Money_Face_Emoji", ofType: "png")
        emojiView.image = UIImage.init(contentsOfFile: bundlePath!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signupButtonPressed(_ sender: Any) {
        let signUpVC = SignUpVC()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let loginVC = LoginVC()
        self.navigationController?.pushViewController(loginVC, animated: true)
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
