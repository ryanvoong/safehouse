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
        let cell = tableView.dequeueReusableCellWithIdentifier("ListViewCell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(sensorData[indexPath.row].ID) (\(sensorData[indexPath.row].type))"
        cell.detailTextLabel?.text = String(sensorData[indexPath.row].status)
        return cell
    }
    
    @IBAction func refresh(sender: AnyObject) {
        let urlPath = "http://172.20.10.3:9000/get-sensors-ryan"
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
                        if let description = s["description"] as? String, id = s["id"] as? String, status = s["status"] as? Int {
                            self.sensorData.append(Sensor(ID: id, type: description, status: status))
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