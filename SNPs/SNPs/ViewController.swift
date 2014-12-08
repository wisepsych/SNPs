//
//  ViewController.swift
//  SNPs
//
//  Created by Sarah Anderson on 12/6/14.
//  Copyright (c) 2014 Sarah Anderson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var services = ["AndMe"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "OAuth"
        let tableView: UITableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func doOAuth23andMe(){
        let oauthswift = OAuth2Swift(
            consumerKey:    AndMe["consumerKey"]!,
            consumerSecret: AndMe["consumerSecret"]!,
            authorizeUrl:   "https://api.23andme.com/authorize",
            responseType:   "code"
        )
        println("1")
        oauthswift.authorizeWithCallbackURL( NSURL(string: "http://aloftlabs.com")!, scope: "basic", state: "", success: {
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
                let jsonDict: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
                println(jsonDict)
                self.showAlertView("Client Info", message: "\(jsonDict)")}, failure: {(error:NSError!) -> Void in
                    println(error.localizedDescription)
            })
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
        //Send client id to get genotype info
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
        case "AndMe":
            doOAuth23andMe()
            println("4")
        default:
            println("default (check ViewController tableView)")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    
}


