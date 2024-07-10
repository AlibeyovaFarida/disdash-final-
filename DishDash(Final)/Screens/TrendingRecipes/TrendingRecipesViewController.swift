//
//  TrendingRecipesViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 18.06.24.
//

import UIKit

class TrendingRecipesViewController: UIViewController {
    private let trendingRecipesList: [TrendingRecipeItemModel] = [
        .init(image: "trending-chicken-curry", name: "Chicken Curry", description: "Savor the aromatic Chicken Curry—a rich blend of spices...", chefName: "By Chef Josh Ryan", time: 45, level: "Easy", rating: 4),
        .init(image: "trending-chicken-burger", name: "Chicken Burger", description: "Indulge in a flavorful Chicken Burger: seasoned chicken...", chefName: "By Chef Andrew", time: 15, level: "Medium", rating: 5),
        .init(image: "trending-tiramisu", name: "Tiramisu", description: "Mix the flours, salt, cinnamon and baking powder...", chefName: "By Chef Andrew", time: 30, level: "Hard", rating: 5),
        .init(image: "trending-tofu-sandwich", name: "Tofu Sandwich", description: "Mix the flours, salt, cinnamon and baking powder...", chefName: "By Chef Jhon", time: 30, level: "Easy", rating: 4)
    ]
    private let mostViewedTodayView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(named: "RedPinkMain")
        return view
    }()
    
    private let mostViewedTodayStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 9
        return sv
    }()
    private let mostViewedTodayLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "WhiteBeige")
        lb.text = "Most Viewed Today"
        return lb
    }()
    private let mostViewedTodayRecipeView: UIView = {
        let view = UIView()
        return view
    }()
    private let mostViewedTodayRecipeImageView: UIImageView = {
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
    private let mostViewedTodayDescriptionView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.backgroundColor = UIColor(named: "WhiteBeige")
        view.layer.borderColor = UIColor(named: "PinkSubColor")?.cgColor
        view.layer.cornerRadius = 14
        return view
    }()
    private let mostViewedTodayDescriptionStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        return sv
    }()
    private let mostViewedTodayTitleSubtitleStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    private let mostViewedTodayRecipeTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 13)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "Salami and cheese pizza"
        return lb
    }()
    private let mostViewedTodayRecipeSubtitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 13)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "This is a quick overview of the ingredients..."
        lb.numberOfLines = 0
        return lb
    }()
    private let mostViewedTodayTimeRatingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .trailing
        return sv
    }()
    private let mostViewedTodayCookingTimeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        return sv
    }()
    private let mostViewedTodayClockImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "clock")
        return iv
    }()
    private let mostViewedTodayCookingTimeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "30min"
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "PinkSubColor")
        return lb
    }()
    private let mostViewedTodayRatingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.alignment = .center
        sv.distribution = .fillProportionally
        return sv
    }()
    private let mostViewedTodayRatingLabel: UILabel = {
        let lb = UILabel()
        lb.text = "5"
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "PinkSubColor")
        return lb
    }()
    private let mostViewedTodayRatingImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "star")
        return iv
    }()
    
    private let trendingRecipesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: screenWidth - 56, height: 150)
        layout.sectionInset = .init(top: 15, left: 28, bottom: 94, right: 28)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TrendingRecipeCollectionViewCell.self, forCellWithReuseIdentifier: TrendingRecipeCollectionViewCell.identifier)
        return cv
    }()
    private let bottomShadowImageView = BottomShadowImageView()
    override func viewDidLoad() {
        setupCustomBackButton()
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        trendingRecipesCollectionView.dataSource = self
        setupUI()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    private func setupCustomBackButton() {
        guard let backButtonImage = UIImage(named: "back-button") else {
                print("Error: Back button image not found.")
                return
            }
            
        let backButton = UIButton(type: .custom)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
            
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
            
        backButton.snp.makeConstraints { make in
            make.width.equalTo(22.4)
            make.height.equalTo(14)
        }
    }
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    private func setupUI(){
        view.addSubview(mostViewedTodayView)
        view.addSubview(trendingRecipesCollectionView)
        view.addSubview(bottomShadowImageView)
        mostViewedTodayView.addSubview(mostViewedTodayStackView)
        [
            mostViewedTodayLabel,
            mostViewedTodayRecipeView
        ].forEach(mostViewedTodayStackView.addArrangedSubview)
        [
            mostViewedTodayDescriptionView,
            mostViewedTodayRecipeImageView
        ].forEach(mostViewedTodayRecipeView.addSubview)
        mostViewedTodayDescriptionView.addSubview(mostViewedTodayDescriptionStackView)
        [
            mostViewedTodayTitleSubtitleStackView,
            mostViewedTodayTimeRatingStackView
        ].forEach(mostViewedTodayDescriptionStackView.addArrangedSubview)
        [
            mostViewedTodayRecipeTitleLabel,
            mostViewedTodayRecipeSubtitleLabel
        ].forEach(mostViewedTodayTitleSubtitleStackView.addArrangedSubview)
        [
            mostViewedTodayCookingTimeStackView,
            mostViewedTodayRatingStackView
        ].forEach(mostViewedTodayTimeRatingStackView.addArrangedSubview)
        [
            mostViewedTodayClockImageView,
            mostViewedTodayCookingTimeLabel
        ].forEach(mostViewedTodayCookingTimeStackView.addArrangedSubview)
        [
            mostViewedTodayRatingLabel,
            mostViewedTodayRatingImageView
        ].forEach(mostViewedTodayRatingStackView.addArrangedSubview)
        
        mostViewedTodayView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        mostViewedTodayStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(9)
            make.leading.trailing.equalToSuperview().inset(28)
            make.top.bottom.equalToSuperview().inset(18)
        }
        mostViewedTodayRecipeImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        mostViewedTodayDescriptionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
            make.top.equalTo(mostViewedTodayRecipeImageView.snp.bottom).offset(-12)
        }
        mostViewedTodayDescriptionStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(2)
        }
        mostViewedTodayClockImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        mostViewedTodayRatingImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        trendingRecipesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mostViewedTodayView.snp.bottom).offset(31)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}

extension TrendingRecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendingRecipesList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingRecipeCollectionViewCell.identifier, for: indexPath) as! TrendingRecipeCollectionViewCell
        cell.configure(trendingRecipesList[indexPath.row])
        return cell
    }
}
