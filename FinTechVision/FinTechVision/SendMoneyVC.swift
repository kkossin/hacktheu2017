//
//  sendMoneyVC.swift
//  FinTechVision
//
//  Created by Jordan Davis on 10/28/17.
//  Copyright © 2017 JDApps. All rights reserved.
//

import UIKit

class SendMoneyVC: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountTextInput: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        nameLabel.text = "loading username..."
        
        let userController = UserController.sharedInstance
        let img = userController.convertImageTo64(image: imageView)
        userController.findRecipient(image: img){ (success, name, error) -> () in
            if(success){
                OperationQueue.main.addOperation {
                    self.nameLabel.text = name
                    return
                }
            } else {
                OperationQueue.main.addOperation {
                    self.nameLabel.text = ""
                    print("Error durring registration " + error.debugDescription)
                    return
                }
            }
        }
    }
    
    // MARK: UITextViewDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextInput.resignFirstResponder()
        amountTextInput.text = formatCurrency(value: amountTextInput.text!)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient1 = CAGradientLayer()
        gradient1.frame = CGRect(x: 0, y:0, width: sendButton.frame.width+1, height: sendButton.frame.height)
        gradient1.backgroundColor = UIColor.red.cgColor
        gradient1.colors = [UIColor.init(red: 69.0/255, green: 104.0/255, blue: 220.0/255, alpha: 1).cgColor, UIColor.init(red: 176.0/255, green: 106.0/255, blue: 179.0/255, alpha: 1).cgColor]
        
        gradient1.startPoint = .zero
        gradient1.endPoint = .init(x: 1, y:0)
        sendButton.setBackgroundImage(nil, for: .normal)
        sendButton.layer.addSublayer(gradient1)
        sendButton.layer.cornerRadius = sendButton.frame.height/2
        sendButton.clipsToBounds = true
        
        amountTextInput.keyboardType = .numbersAndPunctuation
        amountTextInput.delegate = self
        self.nameLabel.text = ""
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func retakeButtonPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if(imageView.image == nil){
            nameLabel.text = "Need a photo!"
            return
        }
        if(nameLabel.text != "No match found" && nameLabel.text != "loading username...") {
            let userController = UserController.sharedInstance
            userController.sendMoney(from: userController.currentUser!, to: nameLabel.text!, amount: amountTextInput.text!){ (success, error) -> () in
                if(success){
                    OperationQueue.main.addOperation {
                        self.navigationController?.popViewController(animated: true)
                        return
                    }
                } else {
                    print("Error payment " + error.debugDescription)
                    return
                }
            }
        }
    }
    
    
    func formatCurrency(value: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let dub = Double(value)
        if(dub == nil){
            return "0.00"
        }
        let result = formatter.string(from: dub! as NSNumber)
        return result!
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
