//
//  ReviewCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 21.06.24.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {
    private let reviewStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 21
        return sv
    }()
    private let reviewContentView: UIView = {
        let view = UIView()
        return view
    }()
    private let reviewContentStackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 10
        sv.axis = .vertical
        return sv
    }()
    private let reviewerStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 13
        return sv
    }()
    private let reviewerImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 18
        return iv
    }()
    private let reviewerNameStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        return sv
    }()
    private let reviewerUsernameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 15)
        lb.textColor = UIColor(named: "RedPinkMain")
        return lb
    }()
    private let reviewTimeLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "PinkSubColor")
        return lb
    }()
    private let reviewTextLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Light", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.numberOfLines = 0
        return lb
    }()
    private let starsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 16.43
        sv.alignment = .leading
        return sv
    }()
    private let star1ImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "red-pink-star")
        return iv
    }()
    private let star2ImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "red-pink-star")
        return iv
    }()
    private let star3ImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "red-pink-star")
        return iv
    }()
    private let star4ImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "red-pink-bordered-star")
        return iv
    }()
    private let star5ImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "red-pink-bordered-star")
        return iv
    }()
    private let lineImageView: UIImageView = {
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
        contentView.addSubview(reviewStackView)
        [
            reviewContentView,
            lineImageView
        ].forEach(reviewStackView.addArrangedSubview)
        reviewContentView.addSubview(reviewContentStackView)
        [
            reviewerStackView,
            reviewTextLabel,
            starsStackView
        ].forEach(reviewContentStackView.addArrangedSubview)
        [
            reviewerImageView,
            reviewerNameStackView
        ].forEach(reviewerStackView.addArrangedSubview)
        [
            reviewerUsernameLabel,
            reviewTimeLabel
        ].forEach(reviewerNameStackView.addArrangedSubview)
        [
            star1ImageView,
            star2ImageView,
            star3ImageView,
            star4ImageView,
            star5ImageView,
            UIView()
        ].forEach(starsStackView.addArrangedSubview)
        
        reviewStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        reviewContentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5.4)
            make.leading.trailing.equalToSuperview()
        }
        
        reviewerImageView.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
        
        star1ImageView.snp.makeConstraints { make in
            make.size.equalTo(15)
        }
        star2ImageView.snp.makeConstraints { make in
            make.size.equalTo(15)
        }
        star3ImageView.snp.makeConstraints { make in
            make.size.equalTo(15)
        }
        star4ImageView.snp.makeConstraints { make in
            make.size.equalTo(15)
        }
        star5ImageView.snp.makeConstraints { make in
            make.size.equalTo(15)
        }
    }
    func configure(_ item: ReviewModel){
        reviewerImageView.image = UIImage(named: item.reviewerImage)
        reviewerUsernameLabel.text = item.reviewerUsername
        reviewTimeLabel.text = item.time
        reviewTextLabel.text = item.reviewText
    }
}
