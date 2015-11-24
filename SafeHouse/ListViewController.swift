//
//  ListViewController.swift
//  SafeHouse
//
//  Created by Ryan Voong on 11/15/15.
//  Copyright © 2015 Team SafeHouse. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    // temporary hard-coded data
    var sensorData: [Sensor] = []
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensorData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        let cell = tableView.dequeueReusableCellWithIdentifier("ListViewCell", forIndexPath: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(sensorData[indexPath.row].desc)\n(\(sensorData[indexPath.row].type))"
        cell.detailTextLabel?.textColor = UIColor.blackColor()
        switch sensorData[indexPath.row].status {
        case 0:
            cell.backgroundColor = UIColor.greenColor()
            cell.detailTextLabel?.text = "safe"
        case 1:
            cell.backgroundColor = UIColor.redColor()
            cell.detailTextLabel?.text = "ALERT!!!"
        default:
            cell.backgroundColor = UIColor.clearColor()
            cell.detailTextLabel?.text = "disconnected"
        }
        return cell
    }
    
    @IBAction func refresh(sender: AnyObject) {
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "getData", userInfo: nil, repeats: true)
    }
    
    func getData() {
        let urlPath = "http://107.170.236.50/get-sensors-ryan"
        guard let endpoint = NSURL(string: urlPath) else { print("Error creating endpoint"); return }
        let request = NSMutableURLRequest(URL:endpoint)
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            do {
                guard let dat = data else { throw JSONError.NoData }
                guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: [NSJSONReadingOptions.AllowFragments]) as? NSDictionary else { throw JSONError.ConversionFailed }
                
                if let sensors = json["sensors"] as? [AnyObject] {
                    // reset the data
                    self.sensorData = []
                    
                    // add each sensor
                    for s in sensors {
                        if let id = s["id"] as? String, type = s["type"] as? String, desc = s["description"] as? String, status = s["status"] as? Int {
                            self.sensorData.append(Sensor(ID: id, type: type, desc: desc, status: status))
                        }
                    }
                    
                    // reload the list
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                } else {
                    print("😱") // GG
                }
            } catch let error as JSONError {
                print(error.rawValue)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
}