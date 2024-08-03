//
//  TopChefsViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 04.08.24.
//

import Foundation
import Firebase
class TopChefsViewModel{
    private(set) var mostViewedChefs: [TopChefsModel] = []
    private(set) var chefsList: [TopChefsModel] = []
    
    var didUpdateMostViewedChefs: (() -> Void)?
    var didUpdateChefsList: (() -> Void)?
    var didReceiveError: ((String) -> Void)?
    
    func fetchRecipes(){
        let db = Firestore.firestore()
        db.collection("chefs").order(by: "rating", descending: true).limit(to: 2).getDocuments { querySnapshot, error in
            if let error = error {
                self.didReceiveError?(error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    self.mostViewedChefs.append(TopChefsModel(
                        image: document.data()["image"] as! String,
                        name: "\(document.data()["name"] as! String) \(document.data()["surname"] as! String)",
                        username: document.data()["username"] as! String,
                        ratingCount: document.data()["rating"] as! Int))
                }
                self.didUpdateMostViewedChefs?()
            }
        }
        db.collection("chefs").order(by: "rating", descending: true).limit(toLast: 23).getDocuments { querySnapshot, error in
            if let error = error {
                self.didReceiveError?(error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    self.chefsList.append(TopChefsModel(
                        image: document.data()["image"] as! String,
                        name: "\(document.data()["name"] as! String) \(document.data()["surname"] as! String)",
                        username: document.data()["username"] as! String,
                        ratingCount: document.data()["rating"] as! Int))
                }
                self.didUpdateChefsList?()
            }
        }
    }
    
    func getMostViewedChefsListCount() -> Int{
        return self.mostViewedChefs.count
    }
    
    func getChefsListCount() -> Int {
        return self.chefsList.count
    }
}
