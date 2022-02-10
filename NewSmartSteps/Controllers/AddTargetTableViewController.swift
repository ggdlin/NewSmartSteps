//
//  AddTargetTableViewController.swift
//  NewSmartSteps
//
//  Created by Sergey Ivanov on 26/06/2018.
//  Copyright © 2018 Sergey Ivanov. All rights reserved.
//

import UIKit
import UserNotifications

class AddTargetTableViewController: UITableViewController {

    var interval: Int = 1
    var tomorrowDate: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 1, to: Date())!
    }
    // добавил для тестирования
    var yesterDate: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: -1, to: Date())!
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var intervalButton1: UIButton!
    @IBOutlet weak var intervalButton2: UIButton!
    @IBOutlet weak var intervalButton3: UIButton!
    @IBOutlet weak var intervalButton4: UIButton!
    @IBAction func intervalButtonTapped(_ sender: UIButton) {
        intervalButton1.backgroundColor = nil
        intervalButton2.backgroundColor = nil
        intervalButton3.backgroundColor = nil
        intervalButton4.backgroundColor = nil
        intervalButton1.setTitleColor(.lightGray, for: .normal)
        intervalButton2.setTitleColor(.lightGray, for: .normal)
        intervalButton3.setTitleColor(.lightGray, for: .normal)
        intervalButton4.setTitleColor(.lightGray, for: .normal)
        
        sender.backgroundColor = UIColor.lightGray
        sender.setTitleColor(.white, for: .normal)
        
        switch sender {
        case intervalButton1:
            interval = 1
        case intervalButton2:
            interval = 2
        case intervalButton3:
            interval = 3
        case intervalButton4:
            interval = 4
        default:
            interval = 1
        }
        
    }
    
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
       performSegue(withIdentifier: "UnwindToTargetsTable", sender: sender)
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let target = Target(name: nameTextField.text!, description: descriptionTextField.text!, startDate: Date(), endDate: endDatePicker.date, interval: interval)
            appDelegate.targets.insert(target, at: 0)
            Target.saveToFile(targets: appDelegate.targets)
            
            //MARK: - Create notifications for morning
            var message = "Сегодня есть шаг для цели: '\(nameTextField.text!)'!"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            
                for step in target.steps {
                    var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: step.date)
                    dateComponents.hour = 8
                    //dateComponents.minute = 30
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    let morningID = step.notificationMorningId
                    let request = UNNotificationRequest(identifier: morningID, content: content, trigger: trigger)
                    let center = UNUserNotificationCenter.current()
                    center.add(request, withCompletionHandler: nil)
  
                }
            
            //MARK: - Create notifications for evening
            message = "Требуется отметка для цели: '\(nameTextField.text!)'!"
            content.body = message
            for step in target.steps {
                var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: step.date)
                dateComponents.hour = 20
                //dateComponents.minute = 7
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let eveningID = step.notificationEveningId
                let request = UNNotificationRequest(identifier: eveningID, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)

            }
            
        }
        
        performSegue(withIdentifier: "UnwindToTargetsTable", sender: sender)
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
    updateSaveButton()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButton()
        
        intervalButton1.backgroundColor = UIColor.lightGray
        intervalButton1.setTitleColor(.white, for: .normal)
        
        endDatePicker.minimumDate = tomorrowDate
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSaveButton() {
        let nameText = nameTextField.text ?? ""
        let descriptionText = descriptionTextField.text ?? ""
        saveButton.isEnabled = !nameText.isEmpty && !descriptionText.isEmpty
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
