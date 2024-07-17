//
//  RecentlyAddedCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 10.06.24.
//

import UIKit

class RecentlyAddedCollectionViewCell: UICollectionViewCell {
    
    private let recipeView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 14
        return iv
    }()
    
    private let recipeDescriptionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "PinkSubColor")?.cgColor
        return view
    }()
    
    private let recipeDescriptionStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        return sv
    }()
    
    private let recipeTitleSubtitleStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    private let recipeTitleLabel: UILabel = {
       let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "BrownLetters")
        return lb
    }()
    
    private let recipeSubtitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 13)
        lb.textColor = UIColor(named: "BrownLetters")
        return lb
    }()
    
    private let ratingCookingTimeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        return sv
    }()
    private let ratingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
//        sv.distribution = .fillProportionally
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
//        sv.distribution = .fillProportionally
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
        contentView.addSubview(recipeDescriptionView)
        contentView.addSubview(recipeImageView)
        recipeDescriptionView.addSubview(recipeDescriptionStackView)
        
        [
            recipeTitleSubtitleStackView,
            ratingCookingTimeStackView
        ].forEach(recipeDescriptionStackView.addArrangedSubview)
        [
            recipeTitleLabel,
            recipeSubtitleLabel
        ].forEach(recipeTitleSubtitleStackView.addArrangedSubview)
        [
            ratingStackView,
            cookingTimeStackView
        ].forEach(ratingCookingTimeStackView.addArrangedSubview)
        [
            ratingLabel,
            ratingImageView
        ].forEach(ratingStackView.addArrangedSubview)
        [
            clockImageView,
            cookingTimeLabel
        ].forEach(cookingTimeStackView.addArrangedSubview)
        
        recipeImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            let screenWidth = UIScreen.main.bounds.width
            make.width.equalTo((screenWidth - 86) / 2)
            make.height.equalTo(153)
        }
        
        recipeDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(recipeImageView.snp.bottom).offset(-24)
            make.leading.trailing.equalToSuperview().inset(5)
        }
        
        recipeDescriptionStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    func configure(_ item: RecentlyAddedModel){
        recipeImageView.kf.setImage(with: URL(string: item.image))
        recipeTitleLabel.text = item.name
        recipeSubtitleLabel.text = item.description
        ratingLabel.text = "\(item.rating)"
        cookingTimeLabel.text = "\(item.time)"
    }
}
