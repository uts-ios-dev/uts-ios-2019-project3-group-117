//
//  AddTaskViewController.swift
//  ToDoList
//
//

import UIKit
import DateTimePicker
import EventKit

class AddTaskViewController: UIViewController{
    
    var vc:AddTaskTableViewController?
    let picker = DateTimePicker.create(minimumDate: Date(), maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 365))
    var selectLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(add))
        navigationItem.rightBarButtonItem = button
        
        picker.frame = CGRect(x: 0, y: view.frame.height/2, width: picker.frame.size.width, height: view.frame.height/2)
        picker.isHidden = true
        picker.completionHandler = { date in
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd,MMM EEE\naaKK:mm"
            self.picker.isHidden = true
            self.selectLabel?.text = dateFormat.string(from: date)
            
            if self.selectLabel == self.vc?.startLabel{
                self.vc?.startDate = date
            }else{
                self.vc?.endDate = date
            }
        }
        picker.dismissHandler = {
            self.picker.isHidden = true
        }
        view.addSubview(picker)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectStartTime(_:)))
        vc?.startLabel.addGestureRecognizer(gesture)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(selectEndTime(_:)))
        vc?.endLabel.addGestureRecognizer(gesture2)
    }
    
    @objc func add(){
        guard let name = vc?.tastNameTextField.text, let start = vc?.startDate, let end = vc?.endDate ,let type = vc?.type else {
            return
        }
        
        if vc?.switcher.isOn == true{
            LocalNotification.shared.addNotification(name: name, start: start)
        }
        
        TaskDataService.shared.addHaveTask(name: name, remark: vc?.remarkTextField.text, start: start, end: end, type: type)
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embed"{
            vc = segue.destination as? AddTaskTableViewController
        }
    }
    
    @objc func selectStartTime(_ sender:UIGestureRecognizer){
        self.view.endEditing(true)
        selectLabel = vc?.startLabel
        picker.isHidden = false
    }
    
    @objc func selectEndTime(_ sender:UIGestureRecognizer){
        self.view.endEditing(true)
        selectLabel = vc?.endLabel
        picker.isHidden = false
    }
    
    @IBAction func `import`(_ sender: UIButton) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: {
            granted, error in
            if (granted) && (error == nil) {
            
                // import all the tasks.
                let startDate = Date().addingTimeInterval(-3600*24*90)
                let endDate = Date().addingTimeInterval(3600*24*90)
                let predicate2 = eventStore.predicateForEvents(withStart: startDate,
                                                               end: endDate, calendars: nil)
                
                if let eV = eventStore.events(matching: predicate2) as [EKEvent]? {
                    for i in eV {
                        TaskDataService.shared.addHaveTask(name: i.title, remark: i.notes, start: i.startDate, end: i.endDate, type: "Calendar")
                    }
                }
            }
        })
    }
}
