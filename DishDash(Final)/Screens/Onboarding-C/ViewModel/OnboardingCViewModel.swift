//
//  OnboardingCViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 31.07.24.
//

import Foundation

class OnboardingCViewModel{
    var gallery: [OnboardingCMealItem] = []
    init(){
        self.gallery = [
            .init(image: "onboarding-c-1"),
            .init(image: "onboarding-c-2"),
            .init(image: "onboarding-c-3"),
            .init(image: "onboarding-c-4"),
            .init(image: "onboarding-c-5"),
            .init(image: "onboarding-c-6")
        ]
    }
}
