//
//  WishViewController.swift
//  what-to-do
//
//  Created by 孟繁星 on 19/5/19.
//  Copyright © 2019 YiGu. All rights reserved.
//

import Foundation
import UIKit


var wishtodos: [WishToDoItem] = []

class WishViewController: UIViewController {
    
    
    @IBOutlet weak var wishTodo: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        wishtodos = [WishToDoItem(id: "1", title: "Go to GYM", date: dateFromString("2019-4-20")!),
                 WishToDoItem(id: "2", title: "Read a book", date: dateFromString("2019-4-20")!),
                 WishToDoItem(id: "3", title: "Go shopping", date: dateFromString("2019-4-20")!),
                 WishToDoItem(id: "4", title: "Clean clothes", date: dateFromString("2019-4-20")!)]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wishTodo.reloadData()
    }
    
    // MARK - helper func
    func setMessageLabel(_ messageLabel: UILabel, frame: CGRect, text: String, textColor: UIColor, numberOfLines: Int, textAlignment: NSTextAlignment, font: UIFont) {
        messageLabel.frame = frame
        messageLabel.text = text
        messageLabel.textColor = textColor
        messageLabel.numberOfLines = numberOfLines
        messageLabel.textAlignment = textAlignment
        messageLabel.font = font
        messageLabel.sizeToFit()
    }
    
    func setCellWithTodoItem(_ cell: UITableViewCell, todo: WishToDoItem) {
    
        let titleLabel: UILabel = cell.viewWithTag(12) as! UILabel
        let dateLabel: UILabel = cell.viewWithTag(13) as! UILabel
        
        titleLabel.text = todo.title
        dateLabel.text = stringFromDate(todo.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTodo" {
            let vc = segue.destination as! DetailViewController
            let indexPath = wishTodo.indexPathForSelectedRow
            if let indexPath = indexPath {
                vc.todo = todos[(indexPath as NSIndexPath).row]
            }
        }
    }
}

extension WishViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if todos.count != 0 {
            return todos.count
        } else {
            let messageLabel: UILabel = UILabel()
            
            setMessageLabel(messageLabel, frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), text: "No data is currently available.", textColor: UIColor.black, numberOfLines: 0, textAlignment: NSTextAlignment.center, font: UIFont(name:"Palatino-Italic", size: 20)!)
            
            self.wishTodo.backgroundView = messageLabel
            self.wishTodo.separatorStyle = UITableViewCell.SeparatorStyle.none
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "todoCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        
        return cell
    }
}

extension WishViewController: UITableViewDelegate {
    // Edit mode
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        wishTodo.setEditing(editing, animated: true)
    }
    
    // Delete the cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            todos.remove(at: (indexPath as NSIndexPath).row)
            wishTodo.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    // Move the cell
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.isEditing
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = todos.remove(at: (sourceIndexPath as NSIndexPath).row)
        todos.insert(todo, at: (destinationIndexPath as NSIndexPath).row)
    }
}
