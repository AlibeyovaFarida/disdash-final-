//
//  RecipesViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 24.06.24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class RecipesViewController: UIViewController {
    private var categoryName: String = ""
    private var chefUsername: String = ""
    private var recipeList: [RecipeModel] = []
    private var favoriteRecipes: Set<String> = []
    private let userId = Auth.auth().currentUser?.uid
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
        fetchRecipes()
        fetchFavorites()
        setupCustomBackButton()
        navigationItem.title = categoryName
        if let navigationBar = self.navigationController?.navigationBar {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(named: "RedPinkMain")!
            ]
            navigationBar.titleTextAttributes = textAttributes
        }
        view.backgroundColor = UIColor(named: "WhiteBeige")
        recipesCollectionView.backgroundColor = .clear
        recipesCollectionView.dataSource = self
        recipesCollectionView.delegate = self
        setupUI()
    }
    private func fetchRecipes() {
        let db = Firestore.firestore()
        db.collection("recipes").whereField("taste", isEqualTo: categoryName).whereField("chef.username", isEqualTo: chefUsername).getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(title: "Server error", message: error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                self.recipeList.append(RecipeModel(
                    name: document.data()["name"] as! String,
                    image: document.data()["image"] as! String,
                    description: document.data()["description"] as! String,
                    rating: document.data()["rating"] as! Int,
                    cookingTime: document.data()["cookingTime"] as! String))
                }
                DispatchQueue.main.async {
                    self.recipesCollectionView.reloadData()
                }
            }
        }
    }
        
    private func fetchFavorites() {
        let db = Firestore.firestore()
        db.collection("users").document(userId ?? "").collection("favorites").getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(title: "Server error", message: error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    self.favoriteRecipes.insert(document.documentID)
                }
                DispatchQueue.main.async {
                    self.recipesCollectionView.reloadData()
                }
            }
        }
    }

    private func toggleFavorite(for recipe: RecipeModel) {
        let db = Firestore.firestore()
        let recipeDocRef = db.collection("users").document(userId ?? "").collection("favorites").document(recipe.name)
        
        if favoriteRecipes.contains(recipe.name) {
            recipeDocRef.delete { error in
                if let error = error {
                    self.showAlert(title: "Server error", message: error.localizedDescription)
                } else {
                    self.favoriteRecipes.remove(recipe.name)
                    self.recipesCollectionView.reloadData()
                }
            }
        } else {
            recipeDocRef.setData([
                "name": recipe.name,
                "image": recipe.image,
                "description": recipe.description,
                "rating": recipe.rating,
                "cookingTime": recipe.cookingTime
            ]) { error in
                if let error = error {
                    self.showAlert(title: "Server error", message: error.localizedDescription)
                } else {
                    self.favoriteRecipes.insert(recipe.name)
                    self.recipesCollectionView.reloadData()
                }
            }
        }
    }
    init(categoryName: String, chefUsername: String) {
        super.init(nibName: nil, bundle: nil)
        self.categoryName = categoryName
        self.chefUsername = chefUsername
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
extension RecipesViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TrendingRecipesDetailViewController(productName: recipeList[indexPath.row].name)
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension RecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as! RecipeCollectionViewCell
        var recipe = recipeList[indexPath.row]
        let isFavorite = favoriteRecipes.contains(recipe.name)
        cell.configure(recipe, isFavorite: isFavorite)
        cell.favoriteButtonTapped = {
            self.toggleFavorite(for: recipe)
        }

        return cell
    }
    
}

