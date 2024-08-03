//
//  ProfileFollowingViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 02.08.24.
//

class ProfileFollowingViewModel{
    private(set) var followingProfileList: [FollowingProfileItemModel] = []
    private(set) var followersProfileList: [FollowingProfileItemModel] = []
    
    init(){
        self.followingProfileList = [
            .init(image: "neil_tran", username: "@neil_tran", name: "Neil Tran-Chef"),
            .init(image: "chef_emily", username: "@chef_emily", name: "Emily Carter"),
            .init(image: "cia_food", username: "@cia_food", name: "Cia Rodriguez"),
            .init(image: "josh-ryan", username: "@josh-ryan", name: "Josh Ryan-Chef"),
            .init(image: "torres_meat", username: "@torres_meat", name: "Alfredo Torres"),
            .init(image: "dakota.mullen", username: "@dakota.mullen", name: "Dakota Mullen"),
            .init(image: "smithchef", username: "@smithchef", name: "William Smith"),
            .init(image: "flavorswithhivan", username: "@flavorswithhivan", name: "Ivan Valach"),
            .init(image: "travelfood_", username: "@travelfood_", name: "Derek Hart"),
            .init(image: "jessi_davis", username: "@jessi_davis", name: "Jessica Davis-Chef")
        ]
        self.followersProfileList = [
            .init(image: "sweet.sarah", username: "@sweet.sarah", name: "Sarah Johnson"),
            .init(image: "Moore_Meli", username: "@Moore_Meli", name: "Melissa Moore"),
            .init(image: "miacolors", username: "@miacolors", name: "Mia Davis"),
            .init(image: "emma.br", username: "@emma.br", name: "Emma Brown"),
            .init(image: "r_joshua", username: "@r_joshua", name: "Joshua Ramirez"),
            .init(image: "rivera_jus", username: "@rivera_jus", name: "Justin Rivera"),
            .init(image: "lisamiller", username: "@lisamiller", name: "Lisa Miller"),
            .init(image: "parker_18", username: "parker_18", name: "Kyle Parker"),
            .init(image: "clark_88", username: "@clark_88", name: "Robert Clark"),
            .init(image: "ava.pink", username: "@ava.pink", name: "Ava Johnson")
        ]
    }
    
    func getFollowingProfileListCount() -> Int {
        return self.followingProfileList.count
    }
    
    func getFollowersProfileListCount() -> Int {
        return self.followersProfileList.count
    }
    
    func changeFollowingProfileAnimated(at index: Int) {
        self.followingProfileList[index].isAnimatedDone = true
    }
    
    func changeFollowersProfileAnimated(at index: Int) {
        self.followingProfileList[index].isAnimatedDone = true
    }
}
