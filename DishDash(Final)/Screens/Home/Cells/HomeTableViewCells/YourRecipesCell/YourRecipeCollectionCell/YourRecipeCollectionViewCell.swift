//
//  YourRecipeCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 09.06.24.
//

import UIKit

class YourRecipeCollectionViewCell: UICollectionViewCell {
    private let recipeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 13
        iv.clipsToBounds = true
        return iv
    }()
    private let descriptionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 13
        view.backgroundColor = UIColor(named: "WhiteBeige")
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 13).cgPath
        view.layer.shouldRasterize = false
        view.clipsToBounds = true
        return view
    }()
    private let descriptionStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 2
        return sv
    }()
    private let recipeNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "ComponenteBrownText")
        return lb
    }()
    private let timeRatingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 26
        return sv
    }()
    private let ratingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillProportionally
        sv.alignment = .center
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
    private let cookingTimeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        sv.distribution = .fillProportionally
        sv.alignment = .center
        return sv
    }()
    private let clockImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "clock")
        return iv
    }()
    private let cookingTimeLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "PinkSubColor")
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
        contentView.addSubview(recipeBackgroundView)
        [
            recipeImageView,
            descriptionView
        ].forEach(recipeBackgroundView.addSubview)
        descriptionView.addSubview(descriptionStackView)
        [
            recipeNameLabel,
            timeRatingStackView
        ].forEach(descriptionStackView.addArrangedSubview)
        [
            ratingStackView,
            cookingTimeStackView
        ].forEach(timeRatingStackView.addArrangedSubview)
        [
            ratingLabel,
            ratingImageView
        ].forEach(ratingStackView.addArrangedSubview)
        [
            clockImageView,
            cookingTimeLabel
        ].forEach(cookingTimeStackView.addArrangedSubview)
        
        recipeBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        recipeImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            let screenWidth = UIScreen.main.bounds.width
            make.width.equalTo((screenWidth - 84) / 2)
            make.height.equalTo(162)
        }
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(recipeImageView.snp.bottom).offset(-20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }
        descriptionStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        ratingImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        clockImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
    }
    func configure(_ item: YourRecipeModel){
        recipeImageView.image = UIImage(named: item.image)
        recipeNameLabel.text = item.title
        ratingLabel.text = "\(item.rating)"
        cookingTimeLabel.text = "\(item.time)min"
    }
    
}
