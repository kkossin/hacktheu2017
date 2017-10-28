//
//  HomeVC.swift
//  FinTechVision
//
//  Created by Jordan Davis on 10/27/17.
//  Copyright © 2017 JDApps. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var moneyTextFeild: UITextField!
    
    @IBOutlet weak var fillAccountButton: UIButton!
    @IBOutlet weak var sendMoneyButton: UIButton!
    @IBOutlet weak var kioskModeButton: UIButton!
    
    let userController = UserController.sharedInstance
    
    // MARK: UITextViewDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moneyTextFeild.resignFirstResponder()
        moneyTextFeild.text = formatCurrency(value: moneyTextFeild.text!)
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        moneyTextFeild.keyboardType = .numbersAndPunctuation
        moneyTextFeild.delegate = self
        
        userController.getBalance(username: userController.currentUser!){ (success, error) -> () in
            if(success){
                OperationQueue.main.addOperation {
                    self.infoLabel.text = self.formatCurrency(value: self.userController.currentAccountBalance!)
                    return
                }
            } else {
                print("error getting balance")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.layer.cornerRadius = 20
        infoLabel.clipsToBounds = true
        
        usernameLabel.text = userController.currentUser
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y:0, width: fillAccountButton.frame.width+1, height: fillAccountButton.frame.height)
        gradient.backgroundColor = UIColor.red.cgColor
        gradient.colors = [UIColor.init(red: 69.0/255, green: 104.0/255, blue: 220.0/255, alpha: 1).cgColor, UIColor.init(red: 176.0/255, green: 106.0/255, blue: 179.0/255, alpha: 1).cgColor]
        
        gradient.startPoint = .zero
        gradient.endPoint = .init(x: 1, y:0)
        fillAccountButton.setBackgroundImage(nil, for: .normal)
        fillAccountButton.layer.addSublayer(gradient)
        fillAccountButton.layer.cornerRadius = fillAccountButton.frame.height/2
        fillAccountButton.clipsToBounds = true
        
        let gradient1 = CAGradientLayer()
        gradient1.frame = CGRect(x: 0, y:0, width: sendMoneyButton.frame.width+1, height: sendMoneyButton.frame.height)
        gradient1.backgroundColor = UIColor.red.cgColor
        gradient1.colors = [UIColor.init(red: 69.0/255, green: 104.0/255, blue: 220.0/255, alpha: 1).cgColor, UIColor.init(red: 176.0/255, green: 106.0/255, blue: 179.0/255, alpha: 1).cgColor]
        
        gradient1.startPoint = .zero
        gradient1.endPoint = .init(x: 1, y:0)
        sendMoneyButton.setBackgroundImage(nil, for: .normal)
        sendMoneyButton.layer.addSublayer(gradient1)
        sendMoneyButton.layer.cornerRadius = sendMoneyButton.frame.height/2
        sendMoneyButton.clipsToBounds = true
        
        let gradient2 = CAGradientLayer()
        gradient2.frame = CGRect(x: 0, y:0, width: kioskModeButton.frame.width+1, height: kioskModeButton.frame.height)
        gradient2.backgroundColor = UIColor.red.cgColor
        gradient2.colors = [UIColor.init(red: 69.0/255, green: 104.0/255, blue: 220.0/255, alpha: 1).cgColor, UIColor.init(red: 176.0/255, green: 106.0/255, blue: 179.0/255, alpha: 1).cgColor]
        
        gradient2.startPoint = .zero
        gradient2.endPoint = .init(x: 1, y:0)
        kioskModeButton.setBackgroundImage(nil, for: .normal)
        kioskModeButton.layer.addSublayer(gradient2)
        kioskModeButton.layer.cornerRadius = kioskModeButton.frame.height/2
        kioskModeButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fillAccountButtonPressed(_ sender: Any) {
        if(moneyTextFeild.text != nil && moneyTextFeild.text != ""){
            if(!(moneyTextFeild.text?.contains("$"))!){
                moneyTextFeild.text = "$" + moneyTextFeild.text!
            }
            userController.addFunds(username: userController.currentUser!, amount: moneyTextFeild.text!){ (success, error) -> () in
                if(success){
                    OperationQueue.main.addOperation {
                        self.userController.getBalance(username: self.userController.currentUser!){ (success, error) -> () in
                            if(success){
                                OperationQueue.main.addOperation {
                                    self.moneyTextFeild.text = ""
                                    self.infoLabel.text = self.formatCurrency(value: self.userController.currentAccountBalance!)
                                    return
                                }
                            } else {
                                print("error getting balance")
                            }
                        }
                    }
                } else {
                    print("Error payment " + error.debugDescription)
                    return
                }
            }
        }
    }
    
    @IBAction func sendMoneyButtonPressed(_ sender: Any) {
        let sendMoneyVC = SendMoneyVC()
        self.navigationController?.pushViewController(sendMoneyVC, animated: true)
    }
    
    @IBAction func kioskModeButtonPressed(_ sender: Any) {
        let kioskModelVC = KioskModelVC()
        self.navigationController?.pushViewController(kioskModelVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func formatCurrency(value: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let dub = Double(value)
        if(dub == nil){
            return "$0.00"
        }
        let result = formatter.string(from: dub! as NSNumber)
        return result!
    }

}
