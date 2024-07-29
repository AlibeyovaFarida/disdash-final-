//
//  CategoryProductsViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 25.07.24.
//

import Firebase

class CategoryProductsViewModel{
    private var categoryName: String
    private(set) var favoriteRecipes: Set<String> = []
    private let userId = Auth.auth().currentUser?.uid
    private(set) var categoryNameList: [CategoryNameItemModel] = []
    private(set) var categoryProductsList: [RecipeModel] = []
    
    var didUpdateData: (() -> Void)?
    var didReceiveError: ((String) -> Void)?
    
    init(categoryName: String) {
        self.categoryName = categoryName
        self.categoryNameList = [
            .init(name: "Breakfast", isSelected: false),
            .init(name: "Lunch", isSelected: false),
            .init(name: "Dinner", isSelected: false),
            .init(name: "Vegan", isSelected: false),
            .init(name: "Dessert", isSelected: false),
            .init(name: "Drinks", isSelected: false),
            .init(name: "Sea Food", isSelected: false)
        ]
    }
    
    func fetchRecipes(){
        let db = Firestore.firestore()
        
        for (index, _) in self.categoryNameList.enumerated(){
            categoryNameList[index].isSelected = categoryName == categoryNameList[index].name
        }
        
        db.collection("recipes").whereField("category", isEqualTo: categoryName).getDocuments { [weak self] querySnapshot, error in
            if let error = error {
                self?.didReceiveError?(error.localizedDescription)
            } else {
                self?.categoryProductsList.removeAll()
                for document in querySnapshot!.documents {
                    self?.categoryProductsList.append(RecipeModel(
                        name: document.data()["name"] as! String,
                        image: document.data()["image"] as! String,
                        description: document.data()["description"] as! String,
                        rating: document.data()["rating"] as! Int,
                        cookingTime: document.data()["cookingTime"] as! String,
                        taste: document.data()["taste"] as! String
                    ))
                }
                self?.didUpdateData?()
            }
        }
    }
    func fetchFavorites() {
        let db = Firestore.firestore()
        db.collection("users").document(userId ?? "").collection("favorites").getDocuments { [weak self] querySnapshot, error in
            if let error = error {
                self?.didReceiveError?(error.localizedDescription)
            } else {
                self?.favoriteRecipes.removeAll()
                for document in querySnapshot!.documents {
                    self?.favoriteRecipes.insert(document.documentID)
                }
                self?.didUpdateData?()
            }
        }
    }
    
    func toggleFavorite(for recipe: RecipeModel) {
        let db = Firestore.firestore()
        let recipeDocRef = db.collection("users").document(userId ?? "").collection("favorites").document(recipe.name)
        
        if favoriteRecipes.contains(recipe.name) {
            recipeDocRef.delete { error in
                if let error = error {
                    self.didReceiveError?(error.localizedDescription)
                } else {
                    self.favoriteRecipes.remove(recipe.name)
                    self.didUpdateData?()
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
                    self.didReceiveError?(error.localizedDescription)
                } else {
                    self.favoriteRecipes.insert(recipe.name)
                    self.didUpdateData?()
                }
            }
        }
    }
    func selectCategory(_ category: CategoryNameItemModel){
        self.categoryName = category.name
        fetchRecipes()
    }
}
