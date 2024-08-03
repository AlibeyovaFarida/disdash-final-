//
//  FollowersProfileTableViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 05.07.24.
//

import UIKit

class FollowersProfileTableViewCell: UITableViewCell {
    
    private let followersStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 15
        sv.alignment = .center
        return sv
    }()
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 31.5
        return iv
    }()
    private let usernameNameStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    private let usernameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "RedPinkMain")
        return lb
    }()
    private let nameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 14)
        lb.textColor = UIColor(named: "TextColorBrown")
        return lb
    }()
    private let deleteButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Delete", for: .normal)
        btn.setTitleColor(UIColor(named: "PinkSubColor"), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
        btn.backgroundColor = UIColor(named: "PinkBase")
        btn.layer.cornerRadius = 12
        return btn
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
        selectionStyle = .none
        contentView.addSubview(followersStackView)
        [
            avatarImageView,
            usernameNameStackView,
            deleteButton
        ].forEach(followersStackView.addArrangedSubview)
        [
            usernameLabel,
            nameLabel
        ].forEach(usernameNameStackView.addArrangedSubview)
        
        followersStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
        avatarImageView.snp.makeConstraints { make in
            make.width.equalTo(61)
            make.height.equalTo(63)
        }
        deleteButton.snp.makeConstraints { make in
            make.width.equalTo(128)
            make.height.equalTo(24)
        }
    }
    
    func configure(_ item: FollowingProfileItemModel){
        avatarImageView.image = UIImage(named: item.image)
        usernameLabel.text = item.username
        nameLabel.text = item.name
    }
    
}
