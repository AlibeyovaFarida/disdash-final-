//
//  AllergicCellViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 04.08.24.
//

import Foundation

class AllergicCellViewModel{
    private(set) var allergicMealList: [AllergicMealItemModel] = []
    
    init(){
        self.allergicMealList = [
            .init(mealImage: "banana", mealTitle: "Banana"),
            .init(mealImage: "meat-allergic", mealTitle: "Meat"),
            .init(mealImage: "kiwi", mealTitle: "Kiwi"),
            .init(mealImage: "almonds", mealTitle: "Almonds"),
            .init(mealImage: "milk", mealTitle: "Milk"),
            .init(mealImage: "eggs-allergic", mealTitle: "Eggs"),
            .init(mealImage: "peanuts", mealTitle: "Peanuts"),
            .init(mealImage: "wheat", mealTitle: "Wheat"),
            .init(mealImage: "shrimp", mealTitle: "Shrimp"),
            .init(mealImage: "tree-nuts", mealTitle: "Tree Nuts"),
            .init(mealImage: "shellfish", mealTitle: "Shellfish"),
            .init(mealImage: "fish", mealTitle: "Fish"),
            .init(mealImage: "soy", mealTitle: "Soy"),
            .init(mealImage: "sesame", mealTitle: "Sesame"),
            .init(mealImage: "mustard", mealTitle: "Mustard")
        ]
    }
}
