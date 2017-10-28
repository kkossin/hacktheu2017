//
//  CameraVC.swift
//  FinTechVision
//
//  Created by Jordan Davis on 10/27/17.
//  Copyright © 2017 JDApps. All rights reserved.
//

import UIKit

class CameraVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var openCameraButton: UIButton!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    // MARK: UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)

        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let userController = UserController.sharedInstance
        
        if(imageView1.image == nil){
            imageView1.image = image
            openCameraButton.setTitle("1/4 Open Camera", for: .normal)
            userController.sendImage(username: userController.currentUser!, image: userController.convertImageTo64(image: imageView1) ){ (success, error) -> () in
                if(success){
                    return
                } else {
                    print("Error durring image enroll 1 " + error.debugDescription)
                    return
                }
            }
            return
        } else if (imageView2.image == nil){
            imageView2.image = image
            openCameraButton.setTitle("2/4 Open Camera", for: .normal)
            userController.sendImage(username: userController.currentUser!, image: userController.convertImageTo64(image: imageView2) ){ (success, error) -> () in
                if(success){
                    return
                } else {
                    print("Error durring image enroll 2 " + error.debugDescription)
                    return
                }
            }
            return
        } else if (imageView3.image == nil){
            imageView3.image = image
            openCameraButton.setTitle("3/4 Open Camera", for: .normal)
            userController.sendImage(username: userController.currentUser!, image: userController.convertImageTo64(image: imageView3) ){ (success, error) -> () in
                if(success){
                    return
                } else {
                    print("Error durring image enroll 3 " + error.debugDescription)
                    return
                }
            }
            return
        } else if (imageView4.image == nil){
            imageView4.image = image
            openCameraButton.setTitle("4/4 Continue", for: .normal)
            userController.sendImage(username: userController.currentUser!, image: userController.convertImageTo64(image: imageView4) ){ (success, error) -> () in
                if(success){
                    return
                } else {
                    print("Error durring image enroll 4 " + error.debugDescription)
                    return
                }
            }
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y:0, width: openCameraButton.frame.width+1, height: openCameraButton.frame.height)
        gradient.backgroundColor = UIColor.red.cgColor
        gradient.colors = [UIColor.init(red: 69.0/255, green: 104.0/255, blue: 220.0/255, alpha: 1).cgColor, UIColor.init(red: 176.0/255, green: 106.0/255, blue: 179.0/255, alpha: 1).cgColor]
        
        gradient.startPoint = .zero
        gradient.endPoint = .init(x: 1, y:0)
        openCameraButton.setBackgroundImage(nil, for: .normal)
        openCameraButton.layer.addSublayer(gradient)
        openCameraButton.layer.cornerRadius = openCameraButton.frame.height/2
        openCameraButton.clipsToBounds = true
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openCameraButtonPressed(_ sender: Any) {
        if(imageView4.image != nil) {
            let homeVC = HomeVC()
            self.navigationController?.pushViewController(homeVC, animated: true)
            return
        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            present(picker, animated: true)
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
