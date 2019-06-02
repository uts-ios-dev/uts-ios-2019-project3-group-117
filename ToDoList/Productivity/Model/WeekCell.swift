//
//  WeekCell.swift
//  ToDoList
//
//

import UIKit
import SnapKit

class WeekCell: UITableViewCell{
    
    lazy var weekLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    lazy var todayView:UIView = UIView()
    
    lazy var stackView:UIStackView = UIStackView()
    
    lazy var scrollView:UIScrollView = UIScrollView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        contentView.addSubview(weekLabel)
        weekLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
        }
        
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.equalTo(weekLabel.snp.trailing).offset(8)
            make.top.bottom.trailing.equalToSuperview()
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(scrollView)
//            make.width.equalTo(1000)
        }
        
        contentView.addSubview(todayView)
        todayView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(4)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
