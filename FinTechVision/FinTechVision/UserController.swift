//
//  UserController.swift
//  FinTechVision
//
//  Created by Jordan Davis on 10/28/17.
//  Copyright © 2017 JDApps. All rights reserved.
//

import Foundation
import UIKit

class UserController: NSObject {
    
    var host = "http://128.110.64.166:50000/facePay/"
    //var host = "http://155.99.175.57:50000/facePay/"

    var currentUser: String?
    var currentPassword: String?
    var currentImages: String?
    var currentAccountBalance: String?
    var currentHistory: [Transaction] = []
    
    static let sharedInstance = UserController()
    
    fileprivate override init() {
        currentHistory = []
    }
    
    // MARK: - Networkings
    
    func registerNewUser(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: host + "newUser")!)
        request.httpMethod = "POST"
        let postString = "{\"Username\":\"" + username + "\", \"UserPassword\":\"" + password + "\"}"
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("registration statusCode should be 200, but is \(httpStatus.statusCode)")
                completionHandler(false, error)
                return
            } else {
                completionHandler(true, nil)
                return
            }
        }
        task.resume()
    }
    
    func loginUser(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: host + "login")!)
        request.httpMethod = "POST"
        let postString = "{\"Username\":\"" + username + "\", \"UserPassword\":\"" + password + "\"}"
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("registration statusCode should be 200, but is \(httpStatus.statusCode)")
                completionHandler(false, error)
                return
            } else {
                completionHandler(true, nil)
                return
            }
        }
        task.resume()
    }
    
    func sendImage(username: String, image: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: host + "enroll")!)
        request.httpMethod = "POST"
        let postString = "{\"Username\":\"" + username + "\", \"Images\":\"" + image + "\"}"
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                completionHandler(false, error)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("registration statusCode should be 200, but is \(httpStatus.statusCode)")
                completionHandler(false, error)
                return
            }
            
            do{ // Parse Json Object and Get User Token
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    if let token = json["UserToken"] as? String {
                        self.currentUser = token
                        completionHandler(true, nil)
                        return
                    }
                }
            }catch{
                print("Unable to parse json object durring registration")
            }
            completionHandler(false, error)
            return
        }
        task.resume()
    }
    
    func getBalance(username: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: host + "getBalance")!)
        request.httpMethod = "POST"
        let postString = "{\"Username\":\"" + username + "\"}"
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                completionHandler(false, error)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("registration statusCode should be 200, but is \(httpStatus.statusCode)")
                completionHandler(false, error)
                return
            }
            
            do{ // Parse Json Object and Get User Token
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    if let balance = json["UserToken"] as? String {
                        self.currentAccountBalance = balance
                        completionHandler(true, nil)
                        return
                    }
                }
            }catch{
                print("Unable to parse json object durring registration")
            }
            completionHandler(false, error)
            return
        }
        task.resume()
    }
    
    func findRecipient(image: String, completionHandler: @escaping (Bool, String, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: host + "recognize")!)
        request.httpMethod = "POST"
        let postString = "{\"Image\":\"" + image + "\"}"
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                completionHandler(false, "", error)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("recognize statusCode should be 200, but is \(httpStatus.statusCode)")
                completionHandler(false, "Error: Try Again", error)
                return
            }
            
            do{ // Parse Json Object and Get User Token
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    if let token = json["UserToken"] as? String {
                        print(token)
                        completionHandler(true,token,nil)
                        return
                    }
                }
            }catch{
                print("Unable to parse json object durring registration")
            }
            completionHandler(false, "", error)
            return
        }
        task.resume()
    }
    
    func sendMoney(from: String, to: String, amount: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: host + "pay")!)
        request.httpMethod = "POST"
        var money = 0.00
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let number = formatter.number(from: amount) {
            money = number.doubleValue
            print(amount)
        }
        print(money)
        let postString = "{\"From\":\"\(from)\", \"To\":\"\(to)\", \"Amount\":\"\(money)\"}"
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                completionHandler(false, error)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("pay statusCode should be 200, but is \(httpStatus.statusCode)")
                completionHandler(false, error)
                return
            }
            
            do{ // Parse Json Object and Get User Token
                completionHandler(true, nil)
            }catch{
                print("Unable to parse json object durring registration")
            }
            completionHandler(false, error)
            return
        }
        task.resume()
    }
    
    func addFunds(username: String, amount: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: host + "addFunds")!)
        request.httpMethod = "POST"
        var money = 0.00
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let number = formatter.number(from: amount) {
            money = number.doubleValue
            print(amount)
        }
        print(money)
        let postString = "{\"Username\":\"\(username)\", \"Amount\":\"\(money)\"}"
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                completionHandler(false, error)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("addFunds statusCode should be 200, but is \(httpStatus.statusCode)")
                completionHandler(false, error)
                return
            }
            
            do{ // Parse Json Object and Get User Token
                completionHandler(true, nil)
            }catch{
                print("Unable to parse json object durring addFunds")
            }
            completionHandler(false, error)
            return
        }
        task.resume()
    }
    
    func getHistory(username: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: host + "getHistory")!)
        request.httpMethod = "POST"
        let postString = "{\"Username\":\"\(username)\"}"
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                completionHandler(false, error)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("addFunds statusCode should be 200, but is \(httpStatus.statusCode)")
                completionHandler(false, error)
                return
            }
            
            do{ // Parse Json Object and Get User Token
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    if let token = json["Transactions"] as? [[String: Any]] {
                        for t in token {
                            
                            let trans:Transaction! = Transaction()
                            trans!.date = (t["Date"] as? String)!
                            trans!.amount = String(describing: t["Amount"] as! Double)
                            self.currentHistory.append(trans!)
                        }
                        completionHandler(true,nil)
                        return
                    }
                }
            }catch{
                print("Unable to parse json object durring addFunds")
            }
            completionHandler(false, error)
            return
        }
        task.resume()
    }
    
    func convertImageTo64(image: UIImageView) -> String {
        let img = UIImageJPEGRepresentation(image.image!, 0.50)?.base64EncodedString()
        return img!
    }
    
    
}
