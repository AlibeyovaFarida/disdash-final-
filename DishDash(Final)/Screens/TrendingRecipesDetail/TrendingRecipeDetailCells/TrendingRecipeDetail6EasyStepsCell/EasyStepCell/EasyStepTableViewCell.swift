//
//  EasyStepTableViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 19.06.24.
//

import UIKit

class EasyStepTableViewCell: UITableViewCell {
    private let bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        return view
    }()
    private let stepLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "ComponenteBrownText")
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
        contentView.addSubview(bgView)
        bgView.addSubview(stepLabel)
        
        bgView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(11)
            make.height.equalTo(81)
        }
        stepLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
        }
    }
    func configure(_ item: EasyStep) {
        stepLabel.text = item.step
        bgView.backgroundColor = UIColor(named: item.bgColor)
    }
}
