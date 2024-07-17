//
//  TrendingRecipeDetailAuthorTableViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 19.06.24.
//

import UIKit

class TrendingRecipeDetailAuthorTableViewCell: UITableViewCell {
    
    private let mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        return sv
    }()
    private let authorDetailsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        return sv
    }()
    private let chefImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 31.5
//        iv.image = UIImage(named: "john_doe")
        return iv
    }()
    private let chefAccountDetailStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    private let chefUsernameLabel: UILabel = {
        let lb = UILabel()
//        lb.text = "@John_Doe"
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "RedPinkMain")
        return lb
    }()
    private let chefNameLabel: UILabel = {
        let lb = UILabel()
//        lb.text = "John Doe-Chef"
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 14)
        return lb
    }()
    private let buttonsView: UIView = {
        let view = UIView()
        return view
    }()
    private let buttonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 9
        return sv
    }()
    private let followButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(named: "PinkBase")
        btn.layer.cornerRadius = 8
        btn.setTitleColor(UIColor(named: "PinkSubColor"), for: .normal)
        btn.setTitle("Following", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        return btn
    }()
    private let threeDotButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "three-dot"), for: .normal)
        return btn
    }()
    private let bottomLineImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bottom-line")
        return iv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        selectionStyle = .none
        contentView.addSubview(mainStackView)
        [
            authorDetailsStackView,
            bottomLineImageView
        ].forEach(mainStackView.addArrangedSubview)
        [
            chefImageView,
            chefAccountDetailStackView,
            buttonsView
        ].forEach(authorDetailsStackView.addArrangedSubview)
        [
            chefUsernameLabel,
            chefNameLabel
        ].forEach(chefAccountDetailStackView.addArrangedSubview)
        buttonsView.addSubview(buttonsStackView)
        [
            followButton,
            threeDotButton
        ].forEach(buttonsStackView.addArrangedSubview)
        
        mainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(28)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(31)
        }
        chefImageView.snp.makeConstraints { make in
            make.width.equalTo(61)
            make.height.equalTo(63)
        }
        buttonsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }
        followButton.snp.makeConstraints { make in
            make.width.equalTo(109)
            make.height.equalTo(23)
        }
        threeDotButton.snp.makeConstraints { make in
            make.width.equalTo(4)
            make.height.equalTo(15)
        }
    }
    
    func configure(_ item: RecipeAuthorModel){
        chefImageView.kf.setImage(with: URL(string: item.image))
        chefUsernameLabel.text = "@\(item.username)"
        chefNameLabel.text = "\(item.name) \(item.surname)-Chef"
    }
}
