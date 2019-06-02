//
//  TaskView.swift
//  ToDoList
//
//

import UIKit
import SnapKit

protocol TaskViewDelegate:NSObjectProtocol{
    func tapTaskView(task:HaveTaskModel)
}

class TaskView: UIView{
    
    lazy var nameLabel:UILabel = UILabel()
    lazy var dateLabel:UILabel = UILabel()
    
    var model:HaveTaskModel?
    
    weak var delegate:TaskViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLabel)
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 11)
        nameLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualTo(-20)
        }
        
        addSubview(dateLabel)
        dateLabel.numberOfLines = 2
        dateLabel.font = UIFont.systemFont(ofSize: 11)
        dateLabel.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.lessThanOrEqualTo(20)
        }
        
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapView))
        addGestureRecognizer(gesture)
    }
    
    @objc func tapView(){
        delegate?.tapTaskView(task: model!)
    }
    
    func setupWith(model:HaveTaskModel){
        self.model = model
        
        nameLabel.text = model.name
        
        backgroundColor = UIColor(hexString: allColors[model.type]!)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "aaK:mm"
        dateLabel.text = dateFormat.string(from: model.startDate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
