//
//  YourRecipesViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 25.06.24.
//

import UIKit
import Firebase
import FirebaseAuth

class YourRecipesViewController: UIViewController {
    private let userId = Auth.auth().currentUser?.uid
    private var favoriteRecipes: Set<String> = []
    private var mostViewedTodayList: [YourRecipeModel] = []
    private var recipesList: [RecipeModel] = []
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
        fetchRecipes()
        fetchFavorites()
        setupCustomBackButton()
        navigationItem.title = "Your Recipes"
        if let navigationBar = self.navigationController?.navigationBar {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(named: "RedPinkMain")!
            ]
            navigationBar.titleTextAttributes = textAttributes
        }
        view.backgroundColor = UIColor(named: "WhiteBeige")
        mostViewedTodayCollectionView.dataSource = self
        mostViewedTodayCollectionView.delegate = self
        recipesCollectionView.dataSource = self
        recipesCollectionView.delegate = self
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
    private func fetchRecipes(){
        guard let id = userId else {
            self.showAlert(title: "Invalid user", message: "No such user exists")
            return
        }
        let db = Firestore.firestore()
        db.collection("users").whereField("userId", isEqualTo: id).getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(title: "Server error", message: error.localizedDescription)
            } else {
                for document in querySnapshot!.documents{
                    let fullname = document.data()["fullname"] as! String
                    let name = fullname.components(separatedBy: " ")[0]
                    let surname = fullname.components(separatedBy: " ")[1]
                    db.collection("recipes").whereField("chef.name", isEqualTo: name).whereField("chef.surname", isEqualTo: surname).getDocuments { querySnapshot2, error2 in
                        if let error = error2 {
                            self.showAlert(title: "Server error", message: error.localizedDescription)
                        } else {
                            for documentRecipe in querySnapshot2!.documents{
                                print(documentRecipe,"Hello")
                                let chef = documentRecipe.data()["chef"] as! [String: String]
                                if documentRecipe.data()["rating"] as! Int == 5{
                                    self.mostViewedTodayList.append(YourRecipeModel(
                                        image: documentRecipe.data()["image"] as! String,
                                        title: documentRecipe.data()["name"] as! String,
                                        rating: documentRecipe.data()["rating"] as! Int,
                                        time: documentRecipe.data()["cookingTime"] as! String,
                                        taste: documentRecipe.data()["taste"] as! String
                                    ))
                                } else {
                                    self.recipesList.append(RecipeModel(
                                        name: documentRecipe.data()["name"] as! String,
                                        image: documentRecipe.data()["image"] as! String,
                                        description: documentRecipe.data()["description"] as! String,
                                        rating: documentRecipe.data()["rating"] as! Int,
                                        cookingTime: documentRecipe.data()["cookingTime"] as! String,
                                        taste: documentRecipe.data()["taste"] as! String))
                                }
                            }
                            DispatchQueue.main.async {
                                self.mostViewedTodayCollectionView.reloadData()
                                self.recipesCollectionView.reloadData()
                            }
                        }
                    }
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
                    self.mostViewedTodayCollectionView.reloadData()
                    self.recipesCollectionView.reloadData()
                }
            }
        }
    }
    private func toggleFavoriteMostViewed(for recipe: YourRecipeModel) {
        let db = Firestore.firestore()
        let recipeDocRef = db.collection("users").document(userId ?? "").collection("favorites").document(recipe.title)
        
        if favoriteRecipes.contains(recipe.title) {
            recipeDocRef.delete { error in
                if let error = error {
                    self.showAlert(title: "Server error", message: error.localizedDescription)
                } else {
                    self.favoriteRecipes.remove(recipe.title)
                    self.mostViewedTodayCollectionView.reloadData()
                    self.recipesCollectionView.reloadData()
                }
            }
        } else {
            recipeDocRef.setData([
                "name": recipe.title,
                "image": recipe.image,
                "rating": recipe.rating,
                "cookingTime": recipe.time,
                "taste": recipe.taste
            ]) { error in
                if let error = error {
                    self.showAlert(title: "Server error", message: error.localizedDescription)
                } else {
                    self.favoriteRecipes.insert(recipe.title)
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
                "cookingTime": recipe.cookingTime,
                "taste": recipe.taste
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
}
extension YourRecipesViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mostViewedTodayCollectionView{
            let vc = TrendingRecipesDetailViewController(productName: mostViewedTodayList[indexPath.row].title)
            navigationController?.pushViewController(vc, animated: true)
        }
        if collectionView == recipesCollectionView {
            let vc = TrendingRecipesDetailViewController(productName: recipesList[indexPath.row].name)
            navigationController?.pushViewController(vc, animated: true)
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
            let recipe = mostViewedTodayList[indexPath.row]
            let isFavorite = favoriteRecipes.contains(recipe.title)
            cell.configure(recipe, isFavorite)
            cell.favoriteButtonTapped = {
                self.toggleFavoriteMostViewed(for: recipe)
            }
            return cell
        }
        if collectionView == recipesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as! RecipeCollectionViewCell
            let recipe = recipesList[indexPath.row]
            let isFavorite = favoriteRecipes.contains(recipe.name)
            cell.configure(recipe, isFavorite: isFavorite)
            cell.favoriteButtonTapped = {
                self.toggleFavorite(for: recipe)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
