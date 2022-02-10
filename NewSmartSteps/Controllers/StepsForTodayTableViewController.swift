//
//  StepsForTodayTableViewController.swift
//  NewSmartSteps
//
//  Created by Sergey Ivanov on 29/06/2018.
//  Copyright © 2018 Sergey Ivanov. All rights reserved.
//

import UIKit

class StepsForTodayTableViewController: UITableViewController {

    var targets: [Target] = []
    var todayStepsIndexArray: [Int] = []
    let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.targets = appDelegate?.targets ?? []
        self.todayStepsIndexArray = Target.todayStepsIndexArray(in: targets)
        tableView.reloadData()
        print("\n [\(Date())] steps for today view will appear")
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
        
        return todayStepsIndexArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stepsForToday", for: indexPath)

        let targetIndex = todayStepsIndexArray[indexPath.row]
        cell.textLabel?.text = targets[targetIndex].description
        
        if let timeLeft = remainingTimeToMark() {
            cell.detailTextLabel?.text = timeLeft
        } else {
            cell.detailTextLabel?.text = "Можно отметить этот шаг!"
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if remainingTimeToMark() == nil {
            performSegue(withIdentifier: "markSegue", sender: nil)
        } else {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.detailTextLabel?.textColor = UIColor.red
        }
        
        
    }
    
    
    
    func updateMarkState() {
        
    }
    
    func remainingTimeToMark() -> String? {
        let calendar = Calendar.current
        let hourComponent = calendar.component(.hour, from: Date())
        let minuteComponent = calendar.component(.minute, from: Date())
        if hourComponent < 20 {
            return "До отметки осталось \(19 - hourComponent):\(59 - minuteComponent) времени!"
        } else {
            return nil
        }
    }

    
    // MARK: - Navigation
    
    @IBAction func unwindForStepsForToday(segue: UIStoryboardSegue) {
        
        guard segue.identifier == "saveMarkUnwind" else { return }
        let markTableViewController = segue.source as! MarkTableViewController
        guard let target = markTableViewController.target else { return }
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedTarget = todayStepsIndexArray[indexPath.row]
            targets[selectedTarget] = target
            Target.saveToFile(targets: targets)
        }
        
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "markSegue" {
            let destination = segue.destination as! MarkTableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedTarget = todayStepsIndexArray[indexPath.row]
                destination.target = targets[selectedTarget]
            }
            
        }
    }
    

}
