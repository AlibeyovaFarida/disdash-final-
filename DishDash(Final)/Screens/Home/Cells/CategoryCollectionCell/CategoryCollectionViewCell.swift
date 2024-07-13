//
//  CategoryCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 04.06.24.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    override var isSelected: Bool {
        didSet{
            changeState()
        }
    }
    private let wrapperView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12.5
        return view
    }()
    private let categoryLabel: UILabel = {
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
        contentView.addSubview(wrapperView)
        wrapperView.addSubview(categoryLabel)
        wrapperView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        categoryLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(9)
        }
    }
    private func changeState(){
        if isSelected{
            wrapperView.backgroundColor = UIColor(named: "RedPinkMain")
            categoryLabel.textColor = UIColor(named: "WhiteBeige")
        } else {
            wrapperView.backgroundColor = .clear
            categoryLabel.textColor = UIColor(named: "RedPinkMain")
        }
    }
    func configure(_ item: CategoryModel){
        categoryLabel.text = item.title        
    }
}
