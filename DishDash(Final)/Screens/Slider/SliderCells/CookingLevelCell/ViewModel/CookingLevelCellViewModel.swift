//
//  CookingLevelCellViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 04.08.24.
//

import Foundation

class CookingLevelCellViewModel{
    private(set) var cookingLevelList: [CookingLevelItemModel] = []
    
    init(){
        self.cookingLevelList = [
            .init(levelTitle: "Novice", levelDesc: "Lorem ipsum dolor sit amet consectetur. Auctor pretium cras id dui pellentesque ornare. Quisque malesuada netus pulvinar diam.", isSelected: false),
            .init(levelTitle: "Intermediate", levelDesc: "Lorem ipsum dolor sit amet consectetur. Auctor pretium cras id dui pellentesque ornare. Quisque pulvinar diam.", isSelected: false),
            .init(levelTitle: "Advanced", levelDesc: "Lorem ipsum dolor sit amet pretium cras id dui pellentesque ornare. Quisque malesuada netus pulvinar diam.", isSelected: true),
            .init(levelTitle: "Professional", levelDesc: "Lorem ipsum dolor sit amet consectetur. Auctor pretium cras id dui pellentesque ornare. Quisque malesuada.", isSelected: false)
        ]
    }
}
