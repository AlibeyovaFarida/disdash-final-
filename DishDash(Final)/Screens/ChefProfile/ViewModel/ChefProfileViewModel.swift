//
//  ChefProfileViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 26.07.24.
//

import Firebase

class ChefProfileViewModel {
    var chefProfileImageView: String?
    var chefName: String?
    var chefUsername: String
    private(set) var chefCollectionRecipesList: [ChefCollectionRecipesModel] = []
    
    var didUpdateData: (() -> Void)?
    var errorOccured: ((String) -> Void)?
    
    init(chefUsername: String) {
        self.chefUsername = chefUsername
        self.chefCollectionRecipesList = [
            .init(image: "asian-heritage", name: "Salty"),
            .init(image: "guilty-pleasures", name: "Sweet")
        ]
    }
    
    func fetchChefProfile(){
        let db = Firestore.firestore()
        db.collection("chefs").whereField("username", isEqualTo: chefUsername).getDocuments { querySnapshot, error in
            if let error = error {
                self.errorOccured?(error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    self.chefProfileImageView = document.data()["image"] as? String
                    self.chefName = "\(document.data()["name"] as! String) \(document.data()["surname"] as! String)"
                    self.didUpdateData?()
                }
            }
        }
    }
}
