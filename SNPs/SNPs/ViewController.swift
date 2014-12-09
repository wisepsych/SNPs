//
//  ViewController.swift
//  SNPs
//
//  Created by Sarah Anderson on 12/6/14.
//  Copyright (c) 2014 Sarah Anderson. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var mTHFRC667TCall: UILabel!
    @IBOutlet weak var mTHFRA1298CCall: UILabel!
    
    
    var services = ["TwentyThreeAndMe"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
  //      self.navigationItem.title = "23andMe"
  //      let tableView: UITableView = UITableView(frame: self.view.bounds, style: .Plain)
  //      tableView.delegate = self
  //      tableView.dataSource = self
  //      self.view.addSubview(tableView);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func signInButtonPressed(sender: AnyObject) {
        doOAuth23andMe()
    }
    
    func doOAuth23andMe(){
        let oauthswift = OAuth2Swift(
            consumerKey:    TwentyThreeAndMe["consumerKey"]!,
            consumerSecret: TwentyThreeAndMe["consumerSecret"]!,
            authorizeUrl:   "https://api.23andme.com/authorize",
            responseType:   "code"
        )
        println("1")
        oauthswift.authorizeWithCallbackURL( NSURL(string: "http://aloftlabs.com")!, scope: "rs1801133%20rs1801131%20basic", state: "", success: {
            credential, response in
            println("2")
            //self.showAlertView("23andMe", message: "oauth_token:\(credential.oauth_token)")
            let authorization = "Authorization: Bearer \(credential.oauth_token)"
            let url: String = "https://api.23andme.com/1/user/"
            let parameters: Dictionary = [
                "Authorization": "Bearer \(credential.oauth_token)",
                "access_token" : "\(credential.oauth_token)"
            ]
            //Send token to get client id
            oauthswift.client.get(url, parameters: parameters, success: {
                data, response in
                let jsonDict: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                println(jsonDict)
                
        //        self.showAlertView("Client Info", message: "\(jsonDict)")
                
                if let profile = jsonDict["profiles"]! as? NSArray  {
                    println("profile: \(profile)")
                    
                    if let profileDict = profile[0] as? NSDictionary {
                        println("profileDict: \(profileDict)")
                    
                        if let clientID: AnyObject = profileDict["id"]  {
                            println(clientID)
                        
                        let genotypeGetURL: String = "https://api.23andme.com/1/genotypes/\(clientID)/?locations=rs1801133%20rs1801131&format=embedded"
                            let parameters: Dictionary = [
                                "Authorization": "Bearer \(credential.oauth_token)",
                                "access_token" : "\(credential.oauth_token)"
                            ]
                            oauthswift.client.get(genotypeGetURL, parameters: parameters, success: {
                                data, response in
                                let geneDictionary: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
                                println(geneDictionary)
                               // self.showAlertView("Genotype Results", message: "\(geneDictionary)")
                                
                                if let genotypesArray = geneDictionary["genotypes"]! as? NSArray {
                                    if let rs1801133Result = genotypesArray[0] as? NSDictionary {
                                        self.mTHFRA1298CCall.text = rs1801133Result["call"]! as? String
                                        if self.mTHFRA1298CCall.text == "GG" {
                                            self.mTHFRA1298CCall.backgroundColor = UIColor(red: 1.000, green: 0.106, blue: 0.000, alpha: 1.00)
                                        } else if self.mTHFRA1298CCall.text == "AG" {
                                            self.mTHFRA1298CCall.backgroundColor = UIColor(red: 1.000, green: 0.980, blue: 0.196, alpha: 1.00)
                                        } else {
                                            self.mTHFRA1298CCall.backgroundColor = UIColor(red: 0.000, green: 0.976, blue: 0.204, alpha: 1.00)
                                        }
                                    }
                                    if let rs1801131Result = genotypesArray[1] as? NSDictionary {
                                        self.mTHFRC667TCall.text = rs1801131Result["call"]! as? String
                                        if self.mTHFRC667TCall.text == "TT" {
                                            self.mTHFRC667TCall.backgroundColor = UIColor(red: 1.000, green: 0.106, blue: 0.000, alpha: 1.00)
                                        } else if self.mTHFRC667TCall.text == "GT" {
                                            self.mTHFRC667TCall.backgroundColor = UIColor(red: 1.000, green: 0.980, blue: 0.196, alpha: 1.00)
                                        } else {
                                            self.mTHFRC667TCall.backgroundColor = UIColor(red: 0.000, green: 0.976, blue: 0.204, alpha: 1.00)
                                        }
                                    }
                                }
                                }, failure: {(error:NSError!) -> Void in
                                    println(error.localizedDescription)
                        })
                        }}
                }
        
                
                }, failure: {(error:NSError!) -> Void in
                    println(error.localizedDescription)
            })
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
        
        
    }
    
    func showAlertView(title: String, message: String) {
        println("3")
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return services.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = services[indexPath.row]
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        var service: String = services[indexPath.row]
        switch service {
        case "TwentyThreeAndMe":
            doOAuth23andMe()
            println("4")
        default:
            println("default (check ViewController tableView)")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    
}


