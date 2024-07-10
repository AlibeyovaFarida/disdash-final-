//
//  TopChefsCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 23.06.24.
//

import UIKit

class TopChefsCollectionViewCell: UICollectionViewCell {
    
    private let topChefView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let topChefImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 14
        return iv
    }()
    private let topChefInfoView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.backgroundColor = UIColor(named: "WhiteBeige")
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "PinkSubColor")?.cgColor
        return view
    }()
    private let topChefInfoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 7
        return sv
    }()
    private let topChefInfoNameUsernameStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = -3
        return sv
    }()
    private let topChefInfoNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "BrownLetters")
        return lb
    }()
    private let topChefInfoUsernameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Light", size: 12)
        lb.textColor = UIColor(named: "RedPinkMain")
        return lb
    }()
    private let interactionStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        return sv
    }()
    private let ratingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 2
        return sv
    }()
    private let ratingLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "PinkSubColor")
        return lb
    }()
    private let ratingImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "star")
        return iv
    }()
    private let followShareStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 3.42
        return sv
    }()
    private let followingButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Following", for: .normal)
        btn.setTitleColor(UIColor(named: "WhiteBeige"), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 8)
        btn.backgroundColor = UIColor(named: "RedPinkMain")
        btn.frame = CGRect(x: 0, y: 0, width: 38, height: 12)
        btn.layer.cornerRadius = 6
        return btn
    }()
    private let shareButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "share"), for: .normal)
        btn.backgroundColor = UIColor(named: "RedPinkMain")
        btn.frame = CGRect(x: 0, y: 0, width: 13.72, height: 13.68)
        btn.layer.cornerRadius = 6
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(topChefView)
        topChefView.addSubview(topChefInfoView)
        topChefView.addSubview(topChefImageView)
        topChefInfoView.addSubview(topChefInfoStackView)
        [
            topChefInfoNameUsernameStackView,
            interactionStackView
        ].forEach(topChefInfoStackView.addArrangedSubview)
        [
            topChefInfoNameLabel,
            topChefInfoUsernameLabel
        ].forEach(topChefInfoNameUsernameStackView.addArrangedSubview)
        [
            ratingStackView,
            followShareStackView
        ].forEach(interactionStackView.addArrangedSubview)
        [
            ratingLabel,
            ratingImageView
        ].forEach(ratingStackView.addArrangedSubview)
        [
            followingButton,
            shareButton
        ].forEach(followShareStackView.addArrangedSubview)
        
        topChefView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topChefImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(153)
            let screenWidth = UIScreen.main.bounds.width
            make.width.equalTo((screenWidth - 84) / 2)
        }
        
        topChefInfoView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(9)
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.equalTo(topChefImageView.snp.bottom).offset(-20)
        }
        
        topChefInfoStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(20)
        }
        ratingImageView.snp.makeConstraints { make in
            make.size.equalTo(12)
        }
        followingButton.snp.makeConstraints { make in
            make.width.equalTo(44)
            make.height.equalTo(14)
        }
        shareButton.snp.makeConstraints { make in
            make.size.equalTo(14)
        }
    }
    
    func configure(_ item: TopChefsModel){
        topChefImageView.image = UIImage(named: item.image)
        topChefInfoNameLabel.text = item.name
        topChefInfoUsernameLabel.text = item.username
        ratingLabel.text = "\(item.ratingCount)"
    }
}
