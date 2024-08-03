//
//  ReviewsViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 21.06.24.
//

import UIKit

class ReviewsViewController: UIViewController {
//    private let reviewsList: [ReviewModel] = [
//        .init(reviewerImage: "r_joshua", reviewerUsername: "@r_joshua", time: "(15 mins ago)", reviewText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent fringilla eleifend purus vel dignissim. Praesent urna ante, iaculis at lobortis eu."),
//        .init(reviewerImage: "josh-ryan", reviewerUsername: "@josh-ryan", time: "(40 mins ago)", reviewText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent fringilla eleifend purus vel dignissim. Praesent urna ante, iaculis at lobortis eu."),
//        .init(reviewerImage: "sweet.sarah", reviewerUsername: "@sweet.sarah", time: "(1 Hr ago)", reviewText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent fringilla eleifend purus vel dignissim. Praesent urna ante, iaculis at lobortis eu.")
//    ]
    private let viewModel = ReviewsViewModel()
    private let recipeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "RedPinkMain")
        view.layer.cornerRadius = 20
        return view
    }()
    private let recipeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 15
        sv.alignment = .center
        return sv
    }()
    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "chicken-burger-reviews")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 14
        return iv
    }()
    private let recipeDetailsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 7
        sv.alignment = .leading
        return sv
    }()
    private let recipeNameStatisticStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    private let recipeNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 20)
        lb.textColor = UIColor(named: "WhiteBeige")
        lb.text = "Chicken Burger"
        return lb
    }()
    private let recipeStatisticStackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 7
        sv.axis = .horizontal
        return sv
    }()
    private let starsStakView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 4
        sv.axis = .horizontal
        return sv
    }()
    private let star1ImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "white-star")
        return iv
    }()
    private let star2ImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "white-star")
        return iv
    }()
    private let star3ImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "white-star")
        return iv
    }()
    private let star4ImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "white-star")
        return iv
    }()
    private let star5ImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bordered-star")
        return iv
    }()
    private let reviewsLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 11)
        lb.textColor = UIColor(named: "WhiteBeige")
        lb.text = "(456 reviews)"
        return lb
    }()
    private let chefInfoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.alignment = .center
        return sv
    }()
    private let chefImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "andrew-mar")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16.6
        return iv
    }()
    private let chefNameStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    private let chefUsernameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 14)
        lb.textColor = UIColor(named: "WhiteBeige")
        lb.text = "@Andrew-Mar"
        return lb
    }()
    private let chefNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 14)
        lb.textColor = UIColor(named: "WhiteBeige")
        lb.text = "Andrew Martinez-Chef"
        return lb
    }()
    private let addReviewButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Add Review", for: .normal)
        btn.setTitleColor(UIColor(named: "RedPinkMain"), for: .normal)
        btn.backgroundColor = UIColor(named: "WhiteBeige")
        btn.frame = CGRect(x: 0, y: 0, width: 126, height: 24)
        btn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    private let commentsTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "RedPinkMain")
        lb.text = "Comments"
        return lb
    }()
    
    private let commentsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 21
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: screenWidth - 56, height: 174)
        layout.sectionInset = .init(top: 0, left: 28, bottom: 0, right: 28)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier)
        return cv
    }()
    private let bottomShadowImageView = BottomShadowImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        commentsCollectionView.dataSource = self
        setupUI()
    }
    
    private func setupUI(){
        view.addSubview(recipeView)
        view.addSubview(commentsTitleLabel)
        view.addSubview(commentsCollectionView)
        view.addSubview(bottomShadowImageView)
        recipeView.addSubview(recipeStackView)
        [
            recipeImageView,
            recipeDetailsStackView
        ].forEach(recipeStackView.addArrangedSubview)
        [
            recipeNameStatisticStackView,
            chefInfoStackView,
            addReviewButton
        ].forEach(recipeDetailsStackView.addArrangedSubview)
        [
            recipeNameLabel,
            recipeStatisticStackView
        ].forEach(recipeNameStatisticStackView.addArrangedSubview)
        [
            starsStakView,
            reviewsLabel
        ].forEach(recipeStatisticStackView.addArrangedSubview)
        [
            star1ImageView,
            star2ImageView,
            star3ImageView,
            star4ImageView,
            star5ImageView
        ].forEach(starsStakView.addArrangedSubview)
        [
            chefImageView,
            chefNameStackView
        ].forEach(chefInfoStackView.addArrangedSubview)
        [
            chefUsernameLabel,
            chefNameLabel
        ].forEach(chefNameStackView.addArrangedSubview)
        
        recipeView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(17)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        recipeStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(26)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        recipeImageView.snp.makeConstraints { make in
            make.size.equalTo(158)
        }
        chefImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
        }
        star1ImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        star2ImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        star3ImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        star4ImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        star5ImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        addReviewButton.snp.makeConstraints { make in
            make.width.equalTo(126)
            make.height.equalTo(24)
        }
        commentsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeView.snp.bottom).offset(28)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        commentsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(commentsTitleLabel.snp.bottom).offset(17)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        bottomShadowImageView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}
extension ReviewsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.reviewsList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as! ReviewCollectionViewCell
        cell.configure(viewModel.reviewsList[indexPath.row])
        return cell
    }
}
