//
//  AddTaskTableViewController.swift
//  ToDoList
//
//

import UIKit


var allColors:[String:String] = ["Red":"#ff4949","Blue":"#5bd1d7","Calendar":"#94fc13"]

class AddTaskTableViewController: UITableViewController{
    @IBOutlet weak var dateContainerView: UITableViewCell!
    
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var remarkTextField: UITextField!
    @IBOutlet weak var tastNameTextField: UITextField!
    
    var startDate:Date = Date()
    var endDate:Date = Date().addingTimeInterval(60*60*24)
    var type:String = "Red"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let aPath = UIBezierPath()
        aPath.lineWidth = 1
        
        aPath.move(to: CGPoint(x: view.frame.width/2-10, y: 0))
        aPath.addLine(to: CGPoint(x: view.frame.width/2+10, y: 30))
        aPath.addLine(to: CGPoint(x: view.frame.width/2-10, y: 60))

        let layer = CAShapeLayer()
        layer.path = aPath.cgPath
        layer.strokeColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.fillColor = nil
        dateContainerView.layer.addSublayer(layer)
        
        startLabel.isUserInteractionEnabled = true
        endLabel.isUserInteractionEnabled = true
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd,MMM EEE\naaKK:mm"
        
        startLabel.text = dateFormat.string(from: startDate)
        endLabel.text = dateFormat.string(from: endDate)
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 , indexPath.section == 1{
            let optionMenu = UIAlertController(title: nil, message: "Choose type", preferredStyle: .actionSheet)

            allColors.forEach { (arg0) in
                let (key, _) = arg0
                let action = UIAlertAction(title: key, style: .default, handler: { (alert: UIAlertAction!) -> Void in
                    self.type = key
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.detailTextLabel?.text = key
                })
                optionMenu.addAction(action)
            }
            
            
            
            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
                
                
            })
            
            optionMenu.addAction(cancelAction)
            
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
}
