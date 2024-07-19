//
//  RecipeCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 24.06.24.
//

import UIKit
import Kingfisher



class RecipeCollectionViewCell: UICollectionViewCell {
    var favoriteButtonTapped: (() -> Void)?
    private let recipeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let favButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(named: "RedPinkMain")
        btn.setImage(UIImage(named: "fav-icon"), for: .normal)
        btn.imageView?.tintColor = UIColor(named: "WhiteBeige")
        btn.layer.cornerRadius = 14
        btn.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
        return btn
    }()
    @objc private func favButtonTapped() {
        favoriteButtonTapped?()
    }
    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 14
        return iv
    }()
    private let recipeDescriptionView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "PinkSubColor")?.cgColor
        view.layer.cornerRadius = 14
        return view
    }()
    private let recipeDescriptionStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 1
        return sv
    }()
    private let recipeNameDescStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    private let recipeNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "BrownLetters")
        return lb
    }()
    private let recipeDescriptionLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 13)
        lb.textColor = UIColor(named: "BrownLetters")
        lb.numberOfLines = 0
        return lb
    }()
    private let ratingCookingTimeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        return sv
    }()
    private let ratingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
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
        sv.alignment = .center
        return sv
    }()
    private let cookingTimeImageView: UIImageView = {
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
        contentView.addSubview(recipeView)
        recipeView.addSubview(recipeDescriptionView)
        recipeView.addSubview(recipeImageView)
        recipeView.addSubview(favButton)
        recipeDescriptionView.addSubview(recipeDescriptionStackView)
        [
            recipeNameDescStackView,
            ratingCookingTimeStackView
        ].forEach(recipeDescriptionStackView.addArrangedSubview)
        [
            recipeNameLabel,
            recipeDescriptionLabel
        ].forEach(recipeNameDescStackView.addArrangedSubview)
        [
            ratingStackView,
            cookingTimeStackView
        ].forEach(ratingCookingTimeStackView.addArrangedSubview)
        [
            ratingLabel,
            ratingImageView
        ].forEach(ratingStackView.addArrangedSubview)
        [
            cookingTimeImageView,
            cookingTimeLabel
        ].forEach(cookingTimeStackView.addArrangedSubview)
        
        recipeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        favButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(7)
            make.trailing.equalToSuperview().inset(8.52)
            make.size.equalTo(28)
        }
        recipeImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            let screenWidth = UIScreen.main.bounds.width
            make.width.equalTo((screenWidth - 75) / 2)
            make.height.equalTo(153)
        }
        recipeDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(recipeImageView.snp.bottom).offset(-24)
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
        }
        recipeDescriptionStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(6)
        }
        ratingImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        cookingTimeImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
    }
    func configure(_ item: RecipeModel, isFavorite: Bool){
        recipeImageView.kf.setImage(with: URL(string: item.image))
        recipeNameLabel.text = item.name
        recipeDescriptionLabel.text = item.description
        ratingLabel.text = "\(item.rating)"
        cookingTimeLabel.text = item.cookingTime
        updateFavButton(isFavorite: isFavorite)
    }
    private func updateFavButton(isFavorite: Bool) {
        favButton.backgroundColor = isFavorite ? UIColor(named: "PinkBase") : UIColor(named: "RedPinkMain")
        favButton.imageView?.tintColor = isFavorite ? UIColor(named: "PinkSubColor") : UIColor(named: "WhiteBeige")
    }
}
