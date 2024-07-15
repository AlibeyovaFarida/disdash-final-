//
//  FavoriteCategoryProductsViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 02.07.24.
//

import UIKit

class FavoriteCategoryProductsViewController: UIViewController {
    private let recipeList: [RecipeModel] = [
//        .init(image: "french-toast", name: "French Toast", description: "Delicious slices of bread", rating: 5, cookingTime: "20min"),
//        .init(image: "fruit-crepes", name: "Fruit Crepes", description: "Fruity-filled chocolate crepes", rating: 4, cookingTime: "20min"),
//        .init(image: "macarons", name: "Macarons", description: "Delicate, colorful French macarons", rating: 4, cookingTime: "30min"),
//        .init(image: "spring-cupcake", name: "Spring Cupcake", description: "Fresh, spring-themed cupcake sweetness", rating: 4, cookingTime: "30min"),
//        .init(image: "cheesecake", name: "Cheesecake", description: "Creamy strawberry cheesecake bliss", rating: 4, cookingTime: "30min"),
//        .init(image: "iced-coffee", name: "Iced Coffee", description: "Chilled indulgence in iced coffee", rating: 4, cookingTime: "30min")
    ]
    private let productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 18
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 74) / 2, height: 226)
        layout.sectionInset = .init(top: 0, left: 28, bottom: 79, right: 28)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        return cv
    }()
    private let bottomShadowImageView = BottomShadowImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        productsCollectionView.backgroundColor = .clear
        productsCollectionView.dataSource = self
        setupUI()
    }
    
    private func setupUI(){
        view.addSubview(productsCollectionView)
        view.addSubview(bottomShadowImageView)
        productsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32.5)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
    }
}
extension FavoriteCategoryProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as! RecipeCollectionViewCell
        cell.configure(recipeList[indexPath.row])
        return cell
    }
}
