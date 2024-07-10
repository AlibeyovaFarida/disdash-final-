//
//  CategoryProductsViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 30.06.24.
//

import UIKit

class CategoryProductsViewController: UIViewController {
    private let categoryNameList: [CategoryNameItemModel] = [
        .init(name: "Breakfast", isSelected: true),
        .init(name: "Lunch", isSelected: false),
        .init(name: "Dinner", isSelected: false),
        .init(name: "Vegan", isSelected: false),
        .init(name: "Dessert", isSelected: false),
        .init(name: "Drinks", isSelected: false),
        .init(name: "Sea Food", isSelected: false)
    ]
    private let categoryProductsList: [RecipeModel] = [
        .init(image: "eggs-benedict", name: "Eggs Benedict", description: "Muffin with Canadian bacon", rating: 5, cookingTime: "15min"),
        .init(image: "french-toast", name: "French Toast", description: "Delicious slices of bread", rating: 5, cookingTime: "20min"),
        .init(image: "oatmeal-and-nut", name: "Oatmeal and Nut", description: "Wholesome blend for breakfast", rating: 4, cookingTime: "35min"),
        .init(image: "still-life-potato", name: "Still Life Potato", description: "Earthy, textured, rustic charm", rating: 4, cookingTime: "30min"),
        .init(image: "oatmeal-granola", name: "Oatmeal Granola", description: "Strawberries and Blueberries", rating: 4, cookingTime: "30min"),
        .init(image: "sunny-bruschetta", name: "Sunny Bruschetta", description: "With Cream Cheese", rating: 4, cookingTime: "30min"),
        .init(image: "omelette-cheese", name: "Omelette Cheese", description: "Fresh Parsley", rating: 4, cookingTime: "30min"),
        .init(image: "tofu-sandwich", name: "Tofu Sandwich", description: "Microgreens", rating: 4, cookingTime: "30min")
    ]
    private let categoryListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = .init(width: 81, height: 25)
        layout.sectionInset = .init(top: 7, left: 28, bottom: 7, right: 28)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryNameCollectionViewCell.self, forCellWithReuseIdentifier: CategoryNameCollectionViewCell.identifier)
        return cv
    }()
    private let categoryProductsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 19
        layout.sectionInset = .init(top: 0, left: 28, bottom: 79, right: 28)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 75) / 2, height: 226)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        return cv
    }()
    private let bottomShadowImageView = BottomShadowImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        categoryListCollectionView.backgroundColor = .clear
        categoryProductsCollectionView.backgroundColor = .clear
        categoryListCollectionView.dataSource = self
        categoryProductsCollectionView.dataSource = self
        setupUI()
    }
    
    private func setupUI(){
        view.addSubview(categoryListCollectionView)
        view.addSubview(categoryProductsCollectionView)
        view.addSubview(bottomShadowImageView)
        
        categoryListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(36)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(39)
        }
        
        categoryProductsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryListCollectionView.snp.bottom).offset(19)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}
extension CategoryProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryListCollectionView {
            return categoryNameList.count
        }
        if collectionView == categoryProductsCollectionView {
            return categoryProductsList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryListCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryNameCollectionViewCell.identifier, for: indexPath) as! CategoryNameCollectionViewCell
            cell.configure(categoryNameList[indexPath.row])
            return cell
        }
        if collectionView == categoryProductsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as! RecipeCollectionViewCell
            cell.configure(categoryProductsList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}
