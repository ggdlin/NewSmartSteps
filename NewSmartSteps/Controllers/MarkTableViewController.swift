//
//  MarkTableViewController.swift
//  NewSmartSteps
//
//  Created by Sergey Ivanov on 02/07/2018.
//  Copyright © 2018 Sergey Ivanov. All rights reserved.
//

import UIKit

class MarkTableViewController: UITableViewController {
    
    var target: Target!

    @IBOutlet weak var targetDescriptionLabel: UILabel!
    @IBOutlet weak var markSwitch: UISwitch!
    @IBOutlet weak var performDescriptionLabel: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    @IBAction func performEditingChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        updateSaveButton()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func updateSaveButton() {
        let performText = performDescriptionLabel.text ?? ""
        saveButton.isEnabled = !performText.isEmpty
    }
    
    
    func updateView() {
        targetDescriptionLabel.text = target.description
    }

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "saveMarkUnwind" else {  return }
        let calendar = Calendar.current
        
        for step in target.steps {
            if calendar.isDateInToday(step.date) {
                step.description = performDescriptionLabel.text!
                if markSwitch.isOn {
                    step.mark = .done
                } else {
                    step.mark = .notDone
                }
            }
        }
        
    }
    

}
