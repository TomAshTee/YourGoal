//
//  CreateGoalVC.swift
//  YourGoal
//
//  Created by Tomasz Jaeschke on 23.07.2018.
//  Copyright © 2018 Tomasz Jaeschke. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController {

    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var longTermBtn: UIButton!
    @IBOutlet weak var shortTermBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func shortTermBtnWasPressed(_ sender: Any) {
        
    }
    @IBAction func longTermBtnWasPressed(_ sender: Any) {
        
    }
    @IBAction func nextBtnWasPressed(_ sender: Any) {
        
    }
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetail()
    }
}
