//
//  TaskDetailViewController.swift
//  ToDoList
//
//

import UIKit

class TaskDetailViewController: UIViewController{
    var model:HaveTaskModel?
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var remarkField: UITextView!
    @IBOutlet weak var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let model = model else{
            return
        }
        
        nameField.text = model.name
        remarkField.text = model.remark
        typeLabel.text = model.type
        
        typeView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectType))
        typeView.addGestureRecognizer(gesture)
    }
    
    @objc func selectType(){
        let optionMenu = UIAlertController(title: nil, message: "Choose type", preferredStyle: .actionSheet)
        
        allColors.forEach { (arg0) in
            let (key, _) = arg0
            let action = UIAlertAction(title: key, style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self.typeLabel.text = key
            })
            optionMenu.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteTask(_ sender: UIButton) {
        TaskDataService.shared.deleteHaveTask(taskModel: model!)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func modify(_ sender: UIButton) {
        model = TaskDataService.shared.modifyTask(taskModel: model!, name: nameField.text!, type: typeLabel.text!, remark: remarkField.text!)
    }
}
