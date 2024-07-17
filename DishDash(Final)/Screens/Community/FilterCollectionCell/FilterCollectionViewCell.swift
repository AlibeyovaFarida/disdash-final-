//
//  FilterCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 25.06.24.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    override var isSelected: Bool{
        didSet{
            changeState()
        }
    }
    private let filterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "RedPinkMain")
        view.layer.cornerRadius = 12
        view.frame = CGRect(x: 0, y: 0, width: 81, height: 36)
        return view
    }()
    private let filterLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Regular", size: 16)
        lb.textColor = UIColor(named: "WhiteBeige")
        lb.textAlignment = .center
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(filterView)
        filterView.addSubview(filterLabel)
        
        filterView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        filterLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(9)
        }
    }
    private func changeState(){
        if isSelected{
            filterView.backgroundColor = UIColor(named: "RedPinkMain")
            filterLabel.textColor = UIColor(named: "WhiteBeige")
        } else {
            filterView.backgroundColor = .clear
            filterLabel.textColor = UIColor(named: "RedPinkMain")
        }
    }
    func configure(_ item: FilterChoiseModel){
        filterLabel.text = item.name
        filterView.backgroundColor = item.isSelected ? UIColor(named: "RedPinkMain") : .clear
        filterLabel.textColor = item.isSelected ? UIColor(named: "WhiteBeige") : UIColor(named: "RedPinkMain")
    }
}
