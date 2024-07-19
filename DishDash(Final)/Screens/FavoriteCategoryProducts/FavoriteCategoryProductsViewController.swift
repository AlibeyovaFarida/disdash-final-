//
//  FavoriteCategoryProductsViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 02.07.24.
//

import UIKit
import FirebaseAuth
import Firebase

class FavoriteCategoryProductsViewController: UIViewController {
    private var taste: String = ""
    private let userId = Auth.auth().currentUser?.uid
    private var favoriteRecipes: Set<String> = []
    private var recipeList: [RecipeModel] = []
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
        fetchRecipes()
        fetchFavorites()
        setupCustomBackButton()
        navigationItem.title = taste
        if let navigationBar = self.navigationController?.navigationBar {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(named: "RedPinkMain")!
            ]
            navigationBar.titleTextAttributes = textAttributes
        }
        view.backgroundColor = UIColor(named: "WhiteBeige")
        productsCollectionView.backgroundColor = .clear
        productsCollectionView.dataSource = self
        productsCollectionView.delegate = self
        setupUI()
    }
    
    init(taste: String) {
        super.init(nibName: nil, bundle: nil)
        self.taste = taste
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
    private func fetchRecipes(){
        let db = Firestore.firestore()
        db.collection("users").document(userId ?? "").collection("favorites").whereField("taste", isEqualTo: taste).getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(title: "Server error", message: error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    self.recipeList.append(RecipeModel(
                        name: document.data()["name"] as! String,
                        image: document.data()["image"] as! String,
                        description: document.data()["description"] as? String ?? "",
                        rating: document.data()["rating"] as! Int,
                        cookingTime: document.data()["cookingTime"] as! String,
                        taste: document.data()["taste"] as! String
                    ))
                }
                DispatchQueue.main.async {
                    self.productsCollectionView.reloadData()
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
                self.favoriteRecipes.removeAll()
                for document in querySnapshot!.documents {
                    self.favoriteRecipes.insert(document.documentID)
                }
                DispatchQueue.main.async {
                    self.productsCollectionView.reloadData()
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
                    self.productsCollectionView.reloadData()
                }
            }
        } else {
            recipeDocRef.setData([
                "name": recipe.name,
                "image": recipe.image,
                "description": recipe.description,
                "rating": recipe.rating,
                "cookingTime": recipe.cookingTime,
                "taste": recipe.taste
            ]) { error in
                if let error = error {
                    self.showAlert(title: "Server error", message: error.localizedDescription)
                } else {
                    self.favoriteRecipes.insert(recipe.name)
                    self.productsCollectionView.reloadData()
                }
            }
        }
    }
    private func setupUI(){
        view.addSubview(productsCollectionView)
        view.addSubview(bottomShadowImageView)
        productsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
    }
}

extension FavoriteCategoryProductsViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TrendingRecipesDetailViewController(productName: recipeList[indexPath.row].name)
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension FavoriteCategoryProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as! RecipeCollectionViewCell
        let recipe = recipeList[indexPath.row]
        let isFavorite = favoriteRecipes.contains(recipe.name)
        cell.configure(recipe, isFavorite: isFavorite)
        cell.favoriteButtonTapped = {
            self.toggleFavorite(for: recipe)
        }
        return cell
    }
}
