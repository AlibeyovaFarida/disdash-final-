//
//  TrendingRecipeTableViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 08.06.24.
//

import UIKit

class TrendingRecipeTableViewCell: UITableViewCell {
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 9
        return sv
    }()
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "RedPinkMain")
        lb.text = "Trending Recipe"
        return lb
    }()
    private let recipeView: UIView = {
        let view = UIView()
        return view
    }()
    private let favButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(named: "RedPinkMain")
        btn.setImage(UIImage(named: "fav-icon"), for: .normal)
        btn.imageView?.tintColor = UIColor(named: "WhiteBeige")
        btn.layer.cornerRadius = 14
        return btn
    }()
    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "trend-recipe")
        iv.layer.cornerRadius = 14
        iv.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        iv.layer.shadowOpacity = 1
        iv.layer.shadowOffset = CGSize(width: 0, height: 4)
        iv.layer.shadowRadius = 4
        iv.layer.shadowPath = UIBezierPath(roundedRect: iv.bounds, cornerRadius: 14).cgPath
        iv.layer.shouldRasterize = false
        iv.clipsToBounds = true
        return iv
    }()
    private let descriptionView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "PinkSubColor")?.cgColor
        view.layer.cornerRadius = 14
        return view
    }()
    private let descriptionStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        return sv
    }()
    private let titleSubtitleStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    private let recipeTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 13)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "Salami and cheese pizza"
        return lb
    }()
    private let recipeSubtitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 13)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "This is a quick overview of the ingredients..."
        lb.numberOfLines = 0
        return lb
    }()
    private let timeRatingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .trailing
        return sv
    }()
    private let cookingTimeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        return sv
    }()
    private let clockImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "clock")
        return iv
    }()
    private let cookingTimeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "30min"
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "PinkSubColor")
        return lb
    }()
    private let ratingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.alignment = .center
        sv.distribution = .fillProportionally
        return sv
    }()
    private let ratingLabel: UILabel = {
        let lb = UILabel()
        lb.text = "5"
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "PinkSubColor")
        return lb
    }()
    private let ratingImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "star")
        return iv
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
            titleLabel,
            recipeView
        ].forEach(stackView.addArrangedSubview)
        [
            descriptionView,
            recipeImageView,
            favButton
        ].forEach(recipeView.addSubview)
        descriptionView.addSubview(descriptionStackView)
        [
            titleSubtitleStackView,
            timeRatingStackView
        ].forEach(descriptionStackView.addArrangedSubview)
        [
            recipeTitleLabel,
            recipeSubtitleLabel
        ].forEach(titleSubtitleStackView.addArrangedSubview)
        [
            cookingTimeStackView,
            ratingStackView
        ].forEach(timeRatingStackView.addArrangedSubview)
        [
            clockImageView,
            cookingTimeLabel
        ].forEach(cookingTimeStackView.addArrangedSubview)
        [
            ratingLabel,
            ratingImageView
        ].forEach(ratingStackView.addArrangedSubview)
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28)
        }
        recipeImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        favButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(7)
            make.trailing.equalToSuperview().inset(8.52)
            make.size.equalTo(28)
        }
        descriptionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
            make.top.equalTo(recipeImageView.snp.bottom).offset(-12)
        }
        descriptionStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(2)
        }
        clockImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        ratingImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
    }
}
