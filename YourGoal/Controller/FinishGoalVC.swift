//
//  FinishGoalVC.swift
//  YourGoal
//
//  Created by Tomasz Jaeschke on 24.07.2018.
//  Copyright © 2018 Tomasz Jaeschke. All rights reserved.
//

import UIKit

class FinishGoalVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var createGoalBtn: UIButton!
    @IBOutlet weak var pointsTextField: UITextField!
    
    var goalDescription: String!
    var goalType: GoalType!
    
    func initData(description: String, type: GoalType){
        self.goalDescription = description
        self.goalType = type
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointsTextField.delegate = self
        createGoalBtn.bindToKeyboard()
    }

    @IBAction func createGoalBtnWasPressed(_ sender: Any) {
        // save data to Core Data Goal Model
    }
}
