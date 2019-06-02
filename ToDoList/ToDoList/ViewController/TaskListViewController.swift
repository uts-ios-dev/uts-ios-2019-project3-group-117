//
//  ViewController.swift
//  ToDoList
//
//

import UIKit
import CoreData
import DateTimePicker


class TaskListViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var haveContainerView: UIView!
    @IBOutlet weak var haveTableView: UITableView!
    @IBOutlet weak var wishTableView: UITableView!
    var nameTextField: UITextField?
    @IBOutlet weak var dateCollectionView: UICollectionView!
    var allWishTasks:[NSManagedObject]{
        get{
            return TaskDataService.shared.getAllWishTask()
        }
    }
    
    var selectIndex = 0
    
    lazy var weeks:[[Date]] = generateDate()
    
    var haveTasks:[HaveTaskModel]{
        get{
            return TaskDataService.shared.getHaveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        wishTableView.delegate = self
        wishTableView.dataSource = self
        wishTableView.tableFooterView = UIView()
        
        haveTableView.delegate = self
        haveTableView.dataSource = self
        haveContainerView.isHidden = true
        haveTableView.tableFooterView = UIView()
        haveTableView.register(WeekCell.self, forCellReuseIdentifier: "week")
        
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        dateCollectionView.register(DateCell.self, forCellWithReuseIdentifier: "date")
        dateCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 50)
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        dateCollectionView.setCollectionViewLayout(layout, animated: true)
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDo))
        navigationItem.rightBarButtonItem = rightItem
        
        setTitle(week: weeks[0])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        haveTableView.reloadData()
    }

    // function for adding the to do stuff.
    
    @objc func addToDo(){
        if segment.selectedSegmentIndex == 1{
            performSegue(withIdentifier: "add", sender: nil)
        }else{
            let optionMenu = UIAlertController(title: nil, message: "Choose type", preferredStyle: .alert)
            
            
                let action = UIAlertAction(title: "Add Task", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                    if let name = self.nameTextField?.text{
                        TaskDataService.shared.addWishTask(name: name)
                        self.wishTableView.reloadData()
                    }
                })
                optionMenu.addAction(action)
            
            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
                
                
            })
            
            optionMenu.addTextField {
                (name) -> Void in
                self.nameTextField = name
                self.nameTextField!.placeholder = "<task name here>"
            }
            
            optionMenu.addAction(cancelAction)
            
            self.present(optionMenu, animated: true, completion: nil)
        }
        
    }
    
    // function for deleting the task.
    
    @IBAction func changeValue(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1{
            haveContainerView.isHidden = false
            wishTableView.isHidden = true
        }else{
            haveContainerView.isHidden = true
            wishTableView.isHidden = false
        }
    }
    
    // add date&time for the tasks.
    
    func generateDate()->[[Date]]{
        var date = Date()
        
        var results:[[Date]] = []
        for _ in 0...100{
            var aWeek:[Date] = []
            for _ in 0...6{
                aWeek.append(date)
                date = date.addingTimeInterval(60*60*24)
            }
            results.append(aWeek)
        }
        
        return results
    }
}

extension TaskListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == wishTableView{
            return allWishTasks.count
        }else{
            return 7
        }
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == haveTableView{
            let cell = WeekCell(style: .default, reuseIdentifier: "week")
            
            let day = weeks[selectIndex][indexPath.row]
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "EEE\ndd"
            cell.weekLabel.text = dateFormat.string(from: day)
            
            let ca = Calendar.current
            let dateComponents1 = ca.dateComponents([.month,.day, .hour, .minute, .second, .nanosecond, .timeZone, .weekday, .weekdayOrdinal], from: day)
            let dateComponents2 = ca.dateComponents([.month,.day, .hour, .minute, .second, .nanosecond, .timeZone, .weekday, .weekdayOrdinal], from: Date())
            
            if dateComponents1.day == dateComponents2.day && dateComponents1.month == dateComponents2.month && dateComponents1.year == dateComponents2.year{
                cell.weekLabel.textColor = UIColor(hexString: "#296acd")
                cell.todayView.backgroundColor = UIColor(hexString: "#296acd")
            }else{
                cell.todayView.backgroundColor = .white
            }
            
            let tasks = haveTasks.filter { (model) -> Bool in
                let dateComponents1 = ca.dateComponents([.month,.day, .hour, .minute, .second, .nanosecond, .timeZone, .weekday, .weekdayOrdinal], from: day)
                let dateComponents2 = ca.dateComponents([.month,.day, .hour, .minute, .second, .nanosecond, .timeZone, .weekday, .weekdayOrdinal], from: model.startDate)
                return dateComponents1.day == dateComponents2.day && dateComponents1.month == dateComponents2.month && dateComponents1.year == dateComponents2.year
                }.sorted { (model1, model2) -> Bool in
                    return model1.startDate < model2.startDate
            }
            
            
            cell.stackView.arrangedSubviews.forEach{$0.removeFromSuperview()}
            tasks.forEach { (model) in
                let v = TaskView(frame: .zero)
                v.setupWith(model: model)
                v.delegate = self
                cell.stackView.addArrangedSubview(v)
                v.snp.makeConstraints { (make) in
                    make.width.equalTo(50)
                }
            }
            
            return cell
        }else{
            let cell = UITableViewCell(style: .default, reuseIdentifier: "wish")
            cell.textLabel?.text = allWishTasks[indexPath.row].value(forKey: "name") as? String
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == wishTableView{
            return 44
        }else{
            return haveTableView.frame.height/7
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        TaskDataService.shared.deleteWishTask(object: allWishTasks[indexPath.row])
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == wishTableView{
            return true
        }
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTask"{
            let vc = segue.destination as? TaskDetailViewController
            vc?.model = sender as? HaveTaskModel
        }
    }
}

extension TaskListViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "date", for: indexPath) as? DateCell
        
        if cell == nil{
            cell = DateCell()
        }
        
        let ca = Calendar.current
        
        let week = weeks[indexPath.row]
        cell?.week = week
        
        let dateComponents1 = ca.dateComponents([.month,.day, .hour, .minute, .second, .nanosecond, .timeZone, .weekday, .weekdayOrdinal], from: week[0])
        let dateComponents2 = ca.dateComponents([.month,.day, .hour, .minute, .second, .nanosecond, .timeZone, .weekday, .weekdayOrdinal], from: week[6])
        
        if dateComponents1.month == dateComponents2.month{
            cell?.label.text = "\(ca.shortMonthSymbols[dateComponents1.month!-1])\n\(dateComponents1.day!)-\(dateComponents2.day!)"
        }else{
            cell?.label.text = "\(ca.shortMonthSymbols[dateComponents1.month!-1])-\(ca.shortMonthSymbols[dateComponents2.month!-1])\n\(dateComponents1.day!)-\(dateComponents2.day!)"
        }
        
        if selectIndex == indexPath.row{
            cell?.contentView.backgroundColor = UIColor(hexString: "#529CFE")
            cell?.label.textColor = .white
        }else{
            cell?.contentView.backgroundColor = .white
            cell?.label.textColor = .black
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let week = weeks[indexPath.row]
        setTitle(week: week)
        
        selectIndex = indexPath.row
        collectionView.reloadData()
        haveTableView.reloadData()
        
    }
    
    func setTitle(week:[Date]){
        let ca = Calendar.current
        
        let dateComponents1 = ca.dateComponents([.year,.month,.day, .hour, .minute, .second, .nanosecond, .timeZone, .weekday, .weekdayOrdinal], from: week[0])
        let dateComponents2 = ca.dateComponents([.year,.month,.day, .hour, .minute, .second, .nanosecond, .timeZone, .weekday, .weekdayOrdinal], from: week[6])
        
        if dateComponents1.month == dateComponents2.month{
            titleLabel.text = "\(dateComponents1.day!)-\(dateComponents2.day!), \(ca.shortMonthSymbols[dateComponents1.month!-1]), \(dateComponents1.year!)"
        }else{
            titleLabel.text = "\(dateComponents1.day!)-\(dateComponents2.day!), \(ca.shortMonthSymbols[dateComponents1.month!-1])-\(ca.shortMonthSymbols[dateComponents2.month!-1]), \(dateComponents1.year!)"
        }
    }
}

extension TaskListViewController: TaskViewDelegate{
    func tapTaskView(task: HaveTaskModel) {
        performSegue(withIdentifier: "showTask", sender: task)
    }
}

