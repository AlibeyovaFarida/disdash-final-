//
//  CommunityCardCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 27.06.24.
//

import UIKit

class CommunityCardCollectionViewCell: UICollectionViewCell {
    var favoriteButtonTapped: (() -> Void)?
    private let cardStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 15
        return sv
    }()
    private let authorStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 14
        return sv
    }()
    private let authorImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 17.5
        return iv
    }()
    private let usernameTimeLabelStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = -2
        return sv
    }()
    private let usernameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 15)
        lb.textColor = UIColor(named: "TextColorBrown")
        return lb
    }()
    private let timeLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "PinkSubColor")
        return lb
    }()
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter
        }()
    private let communityRecipeCardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.backgroundColor = UIColor(named: "RedPinkMain")
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
    private let communityRecipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 14
        return iv
    }()
    private let recipeNameRatingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 22
        return sv
    }()
    private let recipeNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "WhiteBeige")
        return lb
    }()
    private let recipeRatingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        return sv
    }()
    private let ratingImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "white-star")
        return iv
    }()
    private let ratingLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "WhiteBeige")
        return lb
    }()
    private let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 14)
        lb.textColor = UIColor(named: "WhiteBeige")
        lb.numberOfLines = 3
        return lb
    }()
    private let cookingTimeCommentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .trailing
        return sv
    }()
    private let cookingTimeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        sv.alignment = .center
        return sv
    }()
    private let clockImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "white-clock")
        return iv
    }()
    private let cookingTimeLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "WhiteBeige")
        lb.numberOfLines = 0
        return lb
    }()
    private let commentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        return sv
    }()
    private let commentLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "WhiteBeige")
        return lb
    }()
    private let commentImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "comment")
        return iv
    }()
    private let bottomLineImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bottom-line")
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
        contentView.addSubview(cardStackView)
        [
            authorStackView,
            communityRecipeCardView,
            bottomLineImageView
        ].forEach(cardStackView.addArrangedSubview)
        [
            authorImageView,
            usernameTimeLabelStackView
        ].forEach(authorStackView.addArrangedSubview)
        [
            usernameLabel,
            timeLabel
        ].forEach(usernameTimeLabelStackView.addArrangedSubview)
        communityRecipeCardView.addSubview(communityRecipeImageView)
        communityRecipeCardView.addSubview(favButton)
        communityRecipeCardView.addSubview(recipeNameRatingStackView)
        communityRecipeCardView.addSubview(descriptionLabel)
        communityRecipeCardView.addSubview(cookingTimeCommentStackView)
        [
            recipeNameLabel,
            recipeRatingStackView,
            UIView()
        ].forEach(recipeNameRatingStackView.addArrangedSubview)
        [
            ratingLabel,
            ratingImageView
        ].forEach(recipeRatingStackView.addArrangedSubview)
        [
            cookingTimeStackView,
            commentStackView
        ].forEach(cookingTimeCommentStackView.addArrangedSubview)
        [
            clockImageView,
            cookingTimeLabel
        ].forEach(cookingTimeStackView.addArrangedSubview)
        [
            commentLabel,
            commentImageView
        ].forEach(commentStackView.addArrangedSubview)
        
        favButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(7)
            make.trailing.equalToSuperview().inset(8.52)
            make.size.equalTo(28)
        }
        cardStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        authorImageView.snp.makeConstraints { make in
            make.size.equalTo(35)
        }
        communityRecipeImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            let screenWidth = UIScreen.main.bounds.width
            make.width.equalTo(screenWidth - 56)
            make.height.equalTo(173)
        }
        recipeNameRatingStackView.snp.makeConstraints { make in
            make.top.equalTo(communityRecipeImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(15)
        }
        descriptionLabel.snp.makeConstraints { make in

            make.leading.equalToSuperview().inset(15)
            make.trailing.equalToSuperview().inset(83)
            make.bottom.equalToSuperview().inset(6)
        }
        cookingTimeCommentStackView.snp.makeConstraints { make in
            make.leading.equalTo(descriptionLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
        }
        ratingImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        clockImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        commentImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        bottomLineImageView.snp.makeConstraints { make in
            let screenWidth = UIScreen.main.bounds.width
            make.width.equalTo(screenWidth - 56)
            make.height.equalTo(1)
        }
    }
    func configure(_ item: CommunityCardModel, _ isFavorite: Bool){
        authorImageView.kf.setImage(with: URL(string: item.authorImage))
        usernameLabel.text = item.username
        timeLabel.text = dateFormatter.string(from: item.time)
        communityRecipeImageView.kf.setImage(with: URL(string: item.recipeImage))
        recipeNameLabel.text = item.recipeName
        ratingLabel.text = "\(item.rating)"
        descriptionLabel.text = item.description
        cookingTimeLabel.text = item.cookingTime
        commentLabel.text = "\(item.comment)"
        updateFavButton(isFavorite: isFavorite)
    }
    private func updateFavButton(isFavorite: Bool) {
        favButton.backgroundColor = isFavorite ? UIColor(named: "PinkBase") : UIColor(named: "RedPinkMain")
        favButton.imageView?.tintColor = isFavorite ? UIColor(named: "PinkSubColor") : UIColor(named: "WhiteBeige")
    }
}
