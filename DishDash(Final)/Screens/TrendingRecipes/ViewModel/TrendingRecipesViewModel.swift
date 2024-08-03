//
//  TrendingRecipesViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 04.08.24.
//

import Foundation
import FirebaseAuth
import Firebase

class TrendingRecipesViewModel{
    private(set) var trendingRecipesList: [TrendingRecipeItemModel] = []
    private(set) var favoriteRecipes: Set<String> = []
    private let userId = Auth.auth().currentUser?.uid
    
    var didUpdateData: (() -> Void)?
    var didReceiveError: ((String) -> Void)?
    
    func fetchRecipes(){
        let db = Firestore.firestore()
        db.collection("recipes").whereField("rating", isEqualTo: 5).getDocuments { querySnapshot, error in
            if let error = error {
                self.didReceiveError?(error.localizedDescription)
            } else {
                for document in querySnapshot!.documents{
                    if let chef = document.data()["chef"] as? [String:String]{
                        self.trendingRecipesList.append(TrendingRecipeItemModel(
                            image: document.data()["image"] as! String,
                            name: document.data()["name"] as! String,
                            description: document.data()["description"] as! String,
                            chefName: chef["name"]!,
                            time: document.data()["cookingTime"] as! String,
                            level: document.data()["level"] as! String,
                            rating: document.data()["rating"] as! Int,
                            taste: document.data()["taste"] as? String ?? ""
                        ))
                    } else {
                        print("Server error")
                    }
                }
                self.didUpdateData?()
            }
        }
    }
    
    func fetchFavorites(){
        let db = Firestore.firestore()
        db.collection("users").document(userId ?? "").collection("favorites").getDocuments { querySnapshot, error in
            if let error = error {
                self.didReceiveError?(error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    self.favoriteRecipes.insert(document.documentID)
                }
                self.didUpdateData?()
            }
        }
    }
    func toggleFavorite(for recipe: TrendingRecipeItemModel) {
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
                "cookingTime": recipe.time,
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
    
    func getTrendingRecipesListCount() -> Int{
        return self.trendingRecipesList.count
    }
    
    func getIsFavorite(_ recipeName: String) -> Bool {
        return self.favoriteRecipes.contains(recipeName)
    }
}
