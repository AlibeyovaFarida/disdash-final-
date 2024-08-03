//
//  RecipesViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 02.08.24.
//

import FirebaseFirestore
import FirebaseAuth

class RecipesViewModel{
    private(set) var categoryName: String = ""
    private(set) var chefUsername: String = ""
    private(set) var recipeList: [RecipeModel] = []
    private(set) var favoriteRecipes: Set<String> = []
    private let userId = Auth.auth().currentUser?.uid
    
    init(categoryName: String, chefUsername: String) {
        self.categoryName = categoryName
        self.chefUsername = chefUsername
    }
    
    
    var didUpdateData: (() -> Void)?
    var errorOccured: ((String) -> Void)?
    
    func fetchRecipes() {
        let db = Firestore.firestore()
        db.collection("recipes").whereField("taste", isEqualTo: categoryName).whereField("chef.username", isEqualTo: chefUsername).getDocuments { querySnapshot, error in
            if let error = error {
                self.errorOccured?(error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                self.recipeList.append(RecipeModel(
                    name: document.data()["name"] as! String,
                    image: document.data()["image"] as! String,
                    description: document.data()["description"] as! String,
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
                self.errorOccured?(error.localizedDescription)
            } else {
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
                    self.errorOccured?(error.localizedDescription)
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
                "cookingTime": recipe.cookingTime
            ]) { error in
                if let error = error {
                    self.errorOccured?(error.localizedDescription)
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
    
    func getIsFavorite(at index: Int) -> Bool {
        return self.favoriteRecipes.contains(self.recipeList[index].name)
    }
}
