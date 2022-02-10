//
//  InfoViewController.swift
//  NewSmartSteps
//
//  Created by Sergey Ivanov on 09/08/2018.
//  Copyright © 2018 Sergey Ivanov. All rights reserved.
//

import UIKit
import UserNotifications

class InfoViewController: UIViewController {

    @IBAction func getNotifiButtonTapped(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (notifiRequests) in
            if !notifiRequests.isEmpty {
                for request in notifiRequests {
                    print("\(request.trigger!) - \(request.identifier)")
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
