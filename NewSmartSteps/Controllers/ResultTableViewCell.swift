//
//  ResultTableViewCell.swift
//  NewSmartSteps
//
//  Created by Sergey Ivanov on 31/08/2018.
//  Copyright © 2018 Sergey Ivanov. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var targetNameLabel: UILabel!
    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var finishedStepsLabel: UILabel!
    @IBOutlet weak var vectorLabel: UILabel!
    
    let calendar = Calendar.current
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with target: Target) {
        
        let steps = target.steps
        var finishedStepsCount = 0
        var vector = 0
        
        for step in steps {
            if (step.date.compare(Date())  == .orderedAscending) && !(calendar.isDateInToday(step.date)) {
                finishedStepsCount += 1
                
                switch step.mark {
                    case .notSet:
                        vector -= 1
                    case .done:
                        vector += 1
                case .notDone:
                    if vector < 0 { vector += 1 }
                }
                
            } else if (calendar.isDateInToday(step.date)) {
                
                switch step.mark {
                case .notSet:
                    break
                case .done:
                    finishedStepsCount += 1
                    vector += 1
                case .notDone:
                    finishedStepsCount += 1
                    if vector < 0 { vector += 1 }
                }
                
            } else { break }
        }
        
        
        targetNameLabel.text = target.name
        stepCountLabel.text = String(target.steps.count)
        finishedStepsLabel.text = "\(finishedStepsCount)  (\(finishedStepsCount * 100 / target.steps.count)%)"
        if vector > 0 {
            vectorLabel.text = "+\(vector)"
        } else {
            vectorLabel.text = "\(vector)"
        }
    }

}
