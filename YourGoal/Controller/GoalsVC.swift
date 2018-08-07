//
//  ViewController.swift
//  YourGoal
//
//  Created by Tomasz Jaeschke on 17.07.2018.
//  Copyright © 2018 Tomasz Jaeschke. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var undoView: UIView!
    
    var goals: [Goal] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchCoreDataObject()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Hide Undo View and Button under scren for animation when its necessary
        //self.undoView.frame.origin.y += 40
    }
    
    override func viewDidLayoutSubviews() {
        
        // Hide Undo View and Button under scren for animation when its necessary
        self.undoView.frame.origin.y += 40
    }
    
    func fetchCoreDataObject() {
        self.fetch { (complete) in
            if complete {
                if goals.count >= 1 {
                    tableView.isHidden = false
                } else {
                    tableView.isHidden = true
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addGoalBtnWasPressed(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else {
            return
        }
        presentDetail(createGoalVC)
    }
    @IBAction func undoBtnWasPressed(_ sender: Any) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
        managedContext.undoManager?.undo()
        
//        do {
//            try managedContext.save()
//            print("Successfully restored goal.")
//        } catch {
//            debugPrint("Could not restored goal: \(error.localizedDescription)")
//        }
        
        fetchCoreDataObject()
        tableView.reloadData()
        moveDownUndoview()
        
    }
    
}

extension GoalsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else {
            return UITableViewCell()
        }
        let goal = goals[indexPath.row]
        
        cell.configureCell(goal: goal)
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
           
            self.removeGoal(atIndexPath: indexPath)
            self.fetchCoreDataObject()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.moveUpUndoView()
        }
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.setProgrss(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.3936358094, green: 0.9765090346, blue: 0.6821135879, alpha: 1)
        
        return [deleteAction, addAction]
    }
}


extension GoalsVC {
    
    func moveUpUndoView(){
        UIView.animate(withDuration: 1, animations: {
            if self.view.frame.height <= self.undoView.frame.origin.y {
               self.undoView.frame.origin.y -= 40
            }
        }, completion: nil)
    }
    
    func moveDownUndoview() {
        UIView.animate(withDuration: 0.2, animations: {
            self.undoView.frame.origin.y += 40
        }, completion: nil)
    }
    
    func setProgrss(atIndexPath indexPath: IndexPath){
        guard let managetContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
        let chosenGoal = goals[indexPath.row]
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress += 1
        } else {
            return
        }
        do {
            try managetContext.save()
            print("Successfully set progress.")
        } catch  {
            debugPrint("Could not set progress: \(error.localizedDescription)")
        }
    }
    
    func removeGoal(atIndexPath indexPath: IndexPath) {
        guard let managetContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
        managetContext.undoManager = UndoManager()
        managetContext.delete(goals[indexPath.row])
        
        do {
            try managetContext.save()
            print("Successfully remove goal.")
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    func fetch(completion: (_ complete: Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return}
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        
        do {
            goals = try managedContext.fetch(featchRequest) as! [Goal]
            print("Successfully fetched data.")
            completion(true)
        } catch  {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
}













