//
//  PreferencesCellViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 04.08.24.
//

import Foundation

class PreferencesCellViewModel{
    private(set) var preferencesMealList: [PreferencesMealItemModel] = []
    
    init(){
        self.preferencesMealList = [
            .init(mealImage: "salad", mealTitle: "Salad"),
            .init(mealImage: "soup", mealTitle: "Soup"),
            .init(mealImage: "eggs-preferences", mealTitle: "Eggs"),
            .init(mealImage: "seafood-preferences", mealTitle: "Seafood"),
            .init(mealImage: "chicken", mealTitle: "Chicken"),
            .init(mealImage: "meat-preferences", mealTitle: "Meat"),
            .init(mealImage: "burger", mealTitle: "Burger"),
            .init(mealImage: "pizza", mealTitle: "Pizza"),
            .init(mealImage: "sushi", mealTitle: "Sushi"),
            .init(mealImage: "rice", mealTitle: "Rice"),
            .init(mealImage: "dessert", mealTitle: "Dessert"),
            .init(mealImage: "bread", mealTitle: "Bread")
        ]
    }
}
