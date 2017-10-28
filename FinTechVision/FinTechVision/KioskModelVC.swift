//
//  KioskModeVC.swift
//  FinTechVision
//
//  Created by Jordan Davis on 10/28/17.
//  Copyright © 2017 JDApps. All rights reserved.
//

import UIKit

class KioskModelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        self.tabelView.register(nib, forCellReuseIdentifier: "tranCell")
        self.tabelView.dataSource = self
        self.tabelView.delegate = self
        self.tabelView.separatorStyle = .none


        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userController = UserController.sharedInstance
        print(userController.currentHistory.count)
        return userController.currentHistory.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userController = UserController.sharedInstance
        let cellID = "tranCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HistoryTableViewCell
        let amount: String! = userController.currentHistory[indexPath.row].amount
        let cellName = userController.currentHistory[indexPath.row].date + "          " + amount
        cell.title.text = cellName
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
