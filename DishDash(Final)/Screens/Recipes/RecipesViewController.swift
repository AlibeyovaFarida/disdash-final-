//
//  RecipesViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 24.06.24.
//

import UIKit

class RecipesViewController: UIViewController {
    private let recipeList: [RecipeModel] = [
//        .init(image: "beans-burger", name: "Beans Burger", description: "Veggie-packed bean burger patty", rating: 4, cookingTime: "30min"),
//        .init(image: "broccoli-lasagna", name: "Broccoli Lasagna", description: "Cheesy broccoli-filled lasagna layers", rating: 4, cookingTime: "30min"),
//        .init(image: "egg-plant-gratin", name: "Egg Plant Gratin", description: "Oven-baked eggplant with savory gratin", rating: 4, cookingTime: "30min"),
//        .init(image: "quinoa-salad", name: "Quinoa Salad", description: "Nutrient-rich quinoa tossed in salad", rating: 4, cookingTime: "30min"),
//        .init(image: "mushroom-risotto", name: "Mushroom Risotto", description: "Creamy mushroom-infused rice dish", rating: 4, cookingTime: "30min"),
//        .init(image: "falafel-salad", name: "Falafel Salad", description: "Crisp falafel atop fresh salad greens", rating: 4, cookingTime: "30min"),
//        .init(image: "veggie-pizza", name: "Veggie Pizza", description: "Colorful veggie-topped pizza pie", rating: 4, cookingTime: "30min"),
//        .init(image: "tofu-and-noodles", name: "Tofu and Noodles", description: "Tender tofu mixed with slurpy noodles", rating: 4, cookingTime: "30min")
    ]
    private let recipesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 19
        layout.sectionInset = .init(top: 0, left: 28, bottom: 70, right: 28)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 75) / 2, height: 226)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        return cv
    }()
    
    private let bottomShadowImageView = BottomShadowImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        recipesCollectionView.backgroundColor = .clear
        recipesCollectionView.dataSource = self
        setupUI()
    }
    
    private func setupUI(){
        view.addSubview(recipesCollectionView)
        view.addSubview(bottomShadowImageView)
        
        recipesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(34.5)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}

extension RecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as! RecipeCollectionViewCell
        cell.configure(recipeList[indexPath.row])
        return cell
    }
}
