//
//  TrendingRecipeDetailDetailsTableViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 19.06.24.
//

import UIKit

class TrendingRecipeDetailDetailsTableViewCell: UITableViewCell {
    private let mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 5
        return sv
    }()
    private let headerView: UIView = {
        let view = UIView()
        return view
    }()
    private let headerStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 15
        sv.alignment = .center
        return sv
    }()
    private let headerTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Details"
        lb.font = UIFont(name: "Poppins-SemiBold", size: 20)
        lb.textColor = UIColor(named: "RedPinkMain")
        lb.textAlignment = .left
        return lb
    }()
    private let timeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 7
        sv.alignment = .center
        return sv
    }()
    private let clockImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "black-clock")
        return iv
    }()
    private let timeLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "30 min"
        return lb
    }()
    private let detailsLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.numberOfLines = 0
        lb.text = "This is a quick overview of the ingredients you’ll need for this Salami Pizza recipe. Specific measurements and full recipe instructions are in the printable recipe card below."
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
        contentView.addSubview(mainStackView)
        [
            headerView,
            detailsLabel
        ].forEach(mainStackView.addArrangedSubview)
        headerView.addSubview(headerStackView)
        [
            headerTitleLabel,
            timeStackView,
            UIView()
        ].forEach(headerStackView.addArrangedSubview)
        [
            clockImageView,
            timeLabel
        ].forEach(timeStackView.addArrangedSubview)
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(31)
        }
        headerStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview()
        }
        clockImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
    }
}
