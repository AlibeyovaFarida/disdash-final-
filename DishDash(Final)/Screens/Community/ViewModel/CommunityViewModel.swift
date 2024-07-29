//
//  CommunityViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 28.07.24.
//

import Firebase

class CommunityViewModel{
    private(set) var communityCardList: [CommunityCardModel] = []
    private(set) var favoriteRecipes: Set<String> = []
    private let userId = Auth.auth().currentUser?.uid
    private var filterList: [FilterChoiseModel] = []
    
    var didUpdateData: (() -> Void)?
    var didReceiveError: ((String) -> Void)?
    
    init(){
        self.filterList = [
            .init(name: "Top Recipes", isSelected: true),
            .init(name: "Newest", isSelected: false),
            .init(name: "Oldest", isSelected: false)
        ]
    }
    
    func fetchDataBasedOnFilter() {
//        activityIndicator.startAnimating()
        let db = Firestore.firestore()
        communityCardList.removeAll()
//        communityCollectionView.reloadData()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        for filterOption in filterList {
            if filterOption.isSelected {
                let query: Query
                if filterOption.name == "Newest" {
                    query = db.collection("recipes").order(by: "date", descending: true)
                } else if filterOption.name == "Oldest" {
                    query = db.collection("recipes").order(by: "date", descending: false)
                } else {
                    query = db.collection("recipes").order(by: "rating", descending: true)
                }
                
                query.getDocuments { querySnapshot, error in
                    if let error = error {
                        self.didReceiveError?(error.localizedDescription)
                    } else {
                        for document in querySnapshot!.documents {
                            let chef = document.data()["chef"] as! [String : String]
                            self.communityCardList.append(CommunityCardModel(
                                authorImage: chef["image"]!,
                                username: chef["username"]!,
                                time: document.data()["date"] as? Date ?? Date(),
                                recipeImage: document.data()["image"] as! String,
                                recipeName: document.data()["name"] as! String,
                                rating: document.data()["rating"] as! Int,
                                description: document.data()["details"] as! String,
                                cookingTime: document.data()["cookingTime"] as! String,
                                comment: 0,
                                taste: document.data()["taste"] as! String
                            ))
                        }
                        self.didUpdateData?()
                    }
                }
                break
            }
        }
    }
    func fetchFavorites() {
        let db = Firestore.firestore()
        db.collection("users").document(userId ?? "").collection("favorites").getDocuments { querySnapshot, error in
            if let error = error {
                self.didReceiveError?( error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    self.favoriteRecipes.insert(document.documentID)
                }
                self.didUpdateData?()
            }
        }
    }
    func toggleFavorite(for recipe: CommunityCardModel) {
        let db = Firestore.firestore()
        let recipeDocRef = db.collection("users").document(userId ?? "").collection("favorites").document(recipe.recipeName)
        
        if favoriteRecipes.contains(recipe.recipeName) {
            recipeDocRef.delete { error in
                if let error = error {
                    self.didReceiveError?( error.localizedDescription)
                } else {
                    self.favoriteRecipes.remove(recipe.recipeName)
                    self.didUpdateData?()
                }
            }
        } else {
            recipeDocRef.setData([
                "name": recipe.recipeName,
                "image": recipe.recipeImage,
                "description": recipe.description,
                "rating": recipe.rating,
                "cookingTime": recipe.cookingTime,
                "taste": recipe.taste
            ]) { error in
                if let error = error {
                    self.didReceiveError?( error.localizedDescription)
                } else {
                    self.favoriteRecipes.insert(recipe.recipeName)
                    self.didUpdateData?()
                }
            }
        }
    }
    
    func selectFilter(at index: Int){
        for (i, _) in filterList.enumerated(){
            filterList[i].isSelected = (i == index)
        }
        fetchDataBasedOnFilter()
    }
    
    func getFilters() -> [FilterChoiseModel]{
        return filterList
    }
    
    func getCommunityCardList() -> [CommunityCardModel]{
        return communityCardList
    }
    
    func isFavorite(recipeName: String) -> Bool{
        return favoriteRecipes.contains(recipeName)
    }
}
