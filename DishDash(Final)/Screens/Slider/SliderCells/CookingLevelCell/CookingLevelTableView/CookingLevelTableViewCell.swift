//
//  CookingLevelTableViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 28.05.24.
//

import UIKit

class CookingLevelTableViewCell: UITableViewCell {
    private let cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        return view
    }()
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    private let levelTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 16)
        return lb
    }()
    private let levelDescLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 13)
        lb.numberOfLines = 0
        return lb
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: "WhiteBeige")
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        selectionStyle = .none
        contentView.addSubview(cellView)
        cellView.addSubview(stackView)
        [
            levelTitleLabel,
            levelDescLabel
        ].forEach(stackView.addArrangedSubview)
        cellView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(28)
        }
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(17)
        }
    }
    func configure(_ item: CookingLevelItemModel){
        levelTitleLabel.text = item.levelTitle
        levelDescLabel.text = item.levelDesc
        cellView.layer.borderColor = item.isSelected ? UIColor(named: "RedPinkMain")?.cgColor : UIColor(named: "PinkBase")?.cgColor
    }
}
