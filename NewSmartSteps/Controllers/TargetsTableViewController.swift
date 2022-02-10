//
//  TargetsTableViewController.swift
//  NewSmartSteps
//
//  Created by Sergey Ivanov on 06/06/2018.
//  Copyright © 2018 Sergey Ivanov. All rights reserved.
//

import UIKit
import UserNotifications

class TargetsTableViewController: UITableViewController {

    var targets: [Target] = []
    let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.targets = appDelegate?.targets ?? []
        tableView.reloadData()
        print("\n [\(Date())] targets table view will appear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return targets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        if !targets.isEmpty {
            
            cell.textLabel?.text = targets[indexPath.row].name
            cell.detailTextLabel?.text = targets[indexPath.row].description
            
        }

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            //MARK: - delete notifications
            let center = UNUserNotificationCenter.current()
            let target = targets[indexPath.row]
            for step in target.steps {
                let morningID = step.notificationMorningId
                let eveningID = step.notificationEveningId
                center.removePendingNotificationRequests(withIdentifiers: [morningID, eveningID])
            }
            
            // Delete the row from the data source
            targets.remove(at: indexPath.row)
            appDelegate?.targets.remove(at: indexPath.row)
            Target.saveToFile(targets: targets)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "progressSteps", let selectedRow = tableView.indexPathForSelectedRow?.row {
            let destination = segue.destination as! ProgressTableViewController
            
            destination.target = targets[selectedRow]
        }
        
    }
    

    @IBAction func unwindForTargetsSegue(segue: UIStoryboardSegue) {
        
    }
}
