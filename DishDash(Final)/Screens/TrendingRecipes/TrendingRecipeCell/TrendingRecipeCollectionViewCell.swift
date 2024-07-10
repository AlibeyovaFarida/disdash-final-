//
//  TrendingRecipeCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 18.06.24.
//

import UIKit

class TrendingRecipeCollectionViewCell: UICollectionViewCell {
    private let trendingRecipeView: UIView = {
        let view = UIView()
        return view
    }()
    private let trendingRecipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 14
        return iv
    }()
    private let trendingRecipeDescriptionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "PinkSubColor")?.cgColor
        return view
    }()
    private let trendingRecipeDescriptionStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 6
        return sv
    }()
    private let trendingRecipeTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "BrownLetters")
        return lb
    }()
    private let trendingRecipeDescriptionLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 13)
        lb.textColor = UIColor(named: "BrownLetters")
        lb.numberOfLines = 0
        return lb
    }()
    private let trendingRecipeChefNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Light", size: 12)
        lb.textColor = UIColor(named: "RedPinkMain")
        return lb
    }()
    private let trendingRecipeDetailsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        return sv
    }()
    private let trendingRecipeCookingTimeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        return sv
    }()
    private let trendingRecipeClockImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "clock")
        return iv
    }()
    private let trendingRecipeCookingTimeLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "PinkSubColor")
        return lb
    }()
    private let trendingRecipeLevelStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        return sv
    }()
    private let trendingRecipeLevelLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "PinkSubColor")
        return lb
    }()
    private let trendingRecipeLevelImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "level")
        return iv
    }()
    private let trendingRecipeRatingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        return sv
    }()
    private let trendingRecipeRatingLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "PinkSubColor")
        return lb
    }()
    private let trendingRecipeRatingImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "star")
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(trendingRecipeView)
        trendingRecipeView.addSubview(trendingRecipeDescriptionView)
        trendingRecipeView.addSubview(trendingRecipeImageView)
        trendingRecipeDescriptionView.addSubview(trendingRecipeDescriptionStackView)
        [
            trendingRecipeTitleLabel,
            trendingRecipeDescriptionLabel,
            trendingRecipeChefNameLabel,
            trendingRecipeDetailsStackView
        ].forEach(trendingRecipeDescriptionStackView.addArrangedSubview)
        [
            trendingRecipeCookingTimeStackView,
            trendingRecipeLevelStackView,
            trendingRecipeRatingStackView
        ].forEach(trendingRecipeDetailsStackView.addArrangedSubview)
        [
            trendingRecipeClockImageView,
            trendingRecipeCookingTimeLabel
        ].forEach(trendingRecipeCookingTimeStackView.addArrangedSubview)
        [
            trendingRecipeLevelLabel,
            trendingRecipeLevelImageView
        ].forEach(trendingRecipeLevelStackView.addArrangedSubview)
        [
            trendingRecipeRatingLabel,
            trendingRecipeRatingImageView
        ].forEach(trendingRecipeRatingStackView.addArrangedSubview)
        
        trendingRecipeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        trendingRecipeImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.size.equalTo(150)
        }
        trendingRecipeDescriptionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.leading.equalTo(trendingRecipeImageView.snp.trailing).offset(-10)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
        trendingRecipeDescriptionStackView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
        }
        trendingRecipeClockImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        trendingRecipeLevelImageView.snp.makeConstraints { make in
            make.width.equalTo(13)
            make.height.equalTo(10)
        }
        trendingRecipeRatingImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
    }
    
    func configure(_ item: TrendingRecipeItemModel){
        trendingRecipeImageView.image = UIImage(named: item.image)
        trendingRecipeTitleLabel.text = item.name
        trendingRecipeDescriptionLabel.text = item.description
        trendingRecipeChefNameLabel.text = item.chefName
        trendingRecipeCookingTimeLabel.text = "\(item.time)min"
        trendingRecipeLevelLabel.text = "\(item.level)"
        trendingRecipeRatingLabel.text = "\(item.rating)"
    }
}
