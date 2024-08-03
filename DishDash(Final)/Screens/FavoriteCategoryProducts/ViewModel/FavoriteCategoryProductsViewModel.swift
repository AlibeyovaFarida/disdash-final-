//
//  FavoriteCategoryProductsViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 31.07.24.
//

import Foundation
import FirebaseAuth
import Firebase

class FavoriteCategoryProductsViewModel{
    private(set) var taste: String
    private let userId = Auth.auth().currentUser?.uid
    private(set) var favoriteRecipes: Set<String> = []
    private(set) var recipeList: [RecipeModel] = []
    
    var didUpdateData: (() -> Void)?
    var didReceiveError: ((String) -> Void)?
    
    init(taste: String) {
        self.taste = taste
    }
    
    
    func fetchRecipes(){
        let db = Firestore.firestore()
        db.collection("users").document(userId ?? "").collection("favorites").whereField("taste", isEqualTo: taste).getDocuments { querySnapshot, error in
            if let error = error {
                self.didReceiveError?(error.localizedDescription)
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
                self.didUpdateData?()
            }
        }
    }
    func fetchFavorites() {
        let db = Firestore.firestore()
        db.collection("users").document(userId ?? "").collection("favorites").getDocuments { querySnapshot, error in
            if let error = error {
                self.didReceiveError?(error.localizedDescription)
            } else {
                self.favoriteRecipes.removeAll()
                for document in querySnapshot!.documents {
                    self.favoriteRecipes.insert(document.documentID)
                }
                self.didUpdateData?()
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
    
    func getRecipeListCount() -> Int{
        return self.recipeList.count
    }
    
    func getFavoriteRecipe(recipeName: String) -> Bool{
        return self.favoriteRecipes.contains(recipeName)
    }
}
