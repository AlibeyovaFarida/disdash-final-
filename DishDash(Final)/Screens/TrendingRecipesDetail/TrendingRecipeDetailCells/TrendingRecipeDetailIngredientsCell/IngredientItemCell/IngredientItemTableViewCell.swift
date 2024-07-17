//
//  IngredientItemTableViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 19.06.24.
//

import UIKit

class IngredientItemTableViewCell: UITableViewCell {
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 4
        sv.alignment = .center
        return sv
    }()
    private let dotLabel: UILabel = {
        let lb = UILabel()
        lb.text = "·"
        lb.font = UIFont(name: "Poppins-Regular", size: 20)
        lb.textColor = UIColor(named: "RedPinkMain")
        return lb
    }()
    private let quantityLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 11)
        lb.textColor = UIColor(named: "RedPinkMain")
        return lb
    }()
    private let ingredientLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 11)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.numberOfLines = 0
        return lb
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(stackView)
        [
            dotLabel,
            quantityLabel,
            ingredientLabel
        ].forEach(stackView.addArrangedSubview)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configure(_ item: String){
//        quantityLabel.text = item.quantity
        ingredientLabel.text = item
    }
}
