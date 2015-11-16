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
    var sensorData: [Sensor] = [
        Sensor(ID: "Front Door", type: "Door Sensor", status: 0),
        Sensor(ID: "Window", type: "Window Sensor", status: 1),
        Sensor(ID: "Back Door", type: "Door Sensor", status: 1)
    ]
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensorData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListViewCell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(sensorData[indexPath.row].ID) (\(sensorData[indexPath.row].type))"
        cell.detailTextLabel?.text = String(sensorData[indexPath.row].status)
        return cell
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        
    }
}