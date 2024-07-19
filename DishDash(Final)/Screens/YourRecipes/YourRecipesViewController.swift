//
//  YourRecipesViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 25.06.24.
//

import UIKit

class YourRecipesViewController: UIViewController {
    private let mostViewedTodayList: [YourRecipeModel] = [
        .init(image: "chicken-burger", title: "Chicken Burger", rating: 5, time: 15),
        .init(image: "tiramisu", title: "Tiramisu", rating: 5, time: 15)
    ]
    private let recipesList: [RecipeModel] = [
//        .init(image: "bechamel-pasta", name: "Béchamel  Pasta", description: "A creamy and indulgent", rating: 4, cookingTime: "30min"),
//        .init(image: "grilled-skewers", name: "Grilled Skewers", description: "Succulent morsels", rating: 4, cookingTime: "30min"),
//        .init(image: "nut-brownie", name: "Nut brownie", description: "Is a rich and indulgent dessert...", rating: 4, cookingTime: "30min"),
//        .init(image: "oatmeal-pancakes", name: "Oatmeal pancakes", description: "These nutritious delights offer a satisfyingly...", rating: 4, cookingTime: "30min"),
//        .init(image: "mushroom-risotto", name: "Mushroom Risotto", description: "Creamy mushroom-infused rice dish", rating: 4, cookingTime: "30min"),
//        .init(image: "waffles", name: "Waffles", description: "They're fluffy on the inside, perfect...", rating: 4, cookingTime: "30min"),
//        .init(image: "iced-coffee", name: "Iced Coffee", description: "A refreshing blend of chilled coffee...", rating: 4, cookingTime: "30min"),
//        .init(image: "tofu-and-noodles", name: "Tofu and Noodles", description: "Tender tofu mixed with slurpy noodles", rating: 4, cookingTime: "30min")
    ]
    private let mostViewedTodayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "RedPinkMain")
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let mostViewTodayLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "WhiteBeige")
        lb.text = "Most Viewed Today"
        return lb
    }()
    private let mostViewedTodayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 28
        layout.sectionInset = .init(top: 0, left: 28, bottom: 0, right: 28)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 84) / 2, height: 195)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(YourRecipeCollectionViewCell.self, forCellWithReuseIdentifier: YourRecipeCollectionViewCell.identifier)
        return cv
    }()
    private let recipesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 19
        layout.sectionInset = .init(top: 0, left: 28, bottom: 79, right: 28)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 75) / 2, height: 226)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        return cv
    }()
    private let bottomShadowImageView = BottomShadowImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBackButton()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        mostViewedTodayCollectionView.dataSource = self
        recipesCollectionView.dataSource = self
        mostViewedTodayCollectionView.backgroundColor = .clear
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
        mostViewedTodayView.addSubview(mostViewTodayLabel)
        mostViewedTodayView.addSubview(mostViewedTodayCollectionView)
        view.addSubview(recipesCollectionView)
        view.addSubview(bottomShadowImageView)
        mostViewedTodayView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        mostViewTodayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        mostViewedTodayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mostViewTodayLabel.snp.bottom).offset(9)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(14)
            make.height.equalTo(195)
        }
        recipesCollectionView.snp.makeConstraints { make in
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
extension YourRecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mostViewedTodayCollectionView {
            return mostViewedTodayList.count
        }
        if collectionView == recipesCollectionView{
            return recipesList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mostViewedTodayCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YourRecipeCollectionViewCell.identifier, for: indexPath) as! YourRecipeCollectionViewCell
            cell.configure(mostViewedTodayList[indexPath.row])
            return cell
        }
        if collectionView == recipesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as! RecipeCollectionViewCell
            cell.configure(recipesList[indexPath.row], isFavorite: false)
            return cell
        }
        return UICollectionViewCell()
    }
}
