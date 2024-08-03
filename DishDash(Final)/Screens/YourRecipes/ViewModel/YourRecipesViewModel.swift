//
//  YourRecipesViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 04.08.24.
//

import Foundation
import FirebaseAuth
import Firebase

class YourRecipesViewModel{
    private let userId = Auth.auth().currentUser?.uid
    private(set) var favoriteRecipes: Set<String> = []
    private(set) var mostViewedTodayList: [YourRecipeModel] = []
    private(set) var recipesList: [RecipeModel] = []
    
    var didUpdateData: (() -> Void)?
    var didUpdateRecipesListData: (() -> Void)?
    var didReceiveError: ((String) -> Void)?
    
    func fetchRecipes(){
        guard let id = userId else {
            self.didReceiveError?("No such user exists")
            return
        }
        let db = Firestore.firestore()
        db.collection("users").whereField("userId", isEqualTo: id).getDocuments { querySnapshot, error in
            if let error = error {
                self.didReceiveError?(error.localizedDescription)
            } else {
                for document in querySnapshot!.documents{
                    let fullname = document.data()["fullname"] as! String
                    let name = fullname.components(separatedBy: " ")[0]
                    let surname = fullname.components(separatedBy: " ")[1]
                    db.collection("recipes").whereField("chef.name", isEqualTo: name).whereField("chef.surname", isEqualTo: surname).getDocuments { querySnapshot2, error2 in
                        if let error = error2 {
                            self.didReceiveError?(error.localizedDescription)
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
                            self.didUpdateData?()
                        }
                    }
                }
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
    func toggleFavoriteMostViewed(for recipe: YourRecipeModel) {
        let db = Firestore.firestore()
        let recipeDocRef = db.collection("users").document(userId ?? "").collection("favorites").document(recipe.title)
        
        if favoriteRecipes.contains(recipe.title) {
            recipeDocRef.delete { error in
                if let error = error {
                    self.didReceiveError?(error.localizedDescription)
                } else {
                    self.favoriteRecipes.remove(recipe.title)
                    self.didUpdateData?()
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
                    self.didReceiveError?(error.localizedDescription)
                } else {
                    self.favoriteRecipes.insert(recipe.title)
                    self.didUpdateRecipesListData?()
                }
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
                    self.didUpdateRecipesListData?()
                }
            }
        }
    }
    
    func getMostViewedTodayListCount() -> Int{
        return self.mostViewedTodayList.count
    }
    func getRecipesListCount() -> Int{
        return self.recipesList.count
    }
    func getIsFavorite(_ title: String) -> Bool{
        return self.favoriteRecipes.contains(title)
    }
}
