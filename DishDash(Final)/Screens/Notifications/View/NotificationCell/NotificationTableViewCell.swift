//
//  NotificationTableViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 10.07.24.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    private let notificationsPinkView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "PinkBase")
        view.layer.cornerRadius = 14
        return view
    }()
    private let notificationsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 15
        sv.alignment = .center
        return sv
    }()
    private let notificationsImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 22.5
        return iv
    }()
    private let titleSubtitleStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    private let notificationTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "RedPinkMain")
        return lb
    }()
    private let notificationSubtitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Light", size: 12)
        lb.textColor = UIColor(named: "ComponenteBrownText")
        lb.numberOfLines = 0
        return lb
    }()
    private let dateLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Light", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        return lb
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(containerView)
        containerView.addSubview(notificationsPinkView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(notificationsStackView)
        [
            notificationsImageView,
            titleSubtitleStackView
        ].forEach(notificationsStackView.addArrangedSubview)
        [
            notificationTitleLabel,
            notificationSubtitleLabel
        ].forEach(titleSubtitleStackView.addArrangedSubview)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        notificationsPinkView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(75)
        }
        notificationsStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(22)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(notificationsPinkView.snp.bottom).offset(10)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        notificationsImageView.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
    }
    func configure(_ item: NotificationItemModel){
        notificationsImageView.image = UIImage(named: item.icon)
        notificationTitleLabel.text = item.title
        notificationSubtitleLabel.text = item.subtitle
        dateLabel.text = item.date
    }
}
