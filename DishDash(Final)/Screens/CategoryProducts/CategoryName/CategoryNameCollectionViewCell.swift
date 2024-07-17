//
//  CategoryNameCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 30.06.24.
//

import UIKit

class CategoryNameCollectionViewCell: UICollectionViewCell {
    private let bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()
    private let categoryNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Regular", size: 16)
        lb.textColor = UIColor(named: "RedPinkMain")
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
        contentView.addSubview(bgView)
        bgView.addSubview(categoryNameLabel)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        categoryNameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    func configure(_ item: CategoryNameItemModel){
        categoryNameLabel.text = item.name
        bgView.backgroundColor = item.isSelected ? UIColor(named: "RedPinkMain") : .clear
        categoryNameLabel.textColor = item.isSelected ? UIColor(named: "WhiteBeige") :UIColor(named: "RedPinkMain")
    }
}
