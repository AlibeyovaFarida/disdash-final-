//
//  ReviewsViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 04.08.24.
//

import Foundation

class ReviewsViewModel{
    private(set) var reviewsList: [ReviewModel] = []
    
    init(){
        self.reviewsList = [
            .init(reviewerImage: "r_joshua", reviewerUsername: "@r_joshua", time: "(15 mins ago)", reviewText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent fringilla eleifend purus vel dignissim. Praesent urna ante, iaculis at lobortis eu."),
            .init(reviewerImage: "josh-ryan", reviewerUsername: "@josh-ryan", time: "(40 mins ago)", reviewText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent fringilla eleifend purus vel dignissim. Praesent urna ante, iaculis at lobortis eu."),
            .init(reviewerImage: "sweet.sarah", reviewerUsername: "@sweet.sarah", time: "(1 Hr ago)", reviewText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent fringilla eleifend purus vel dignissim. Praesent urna ante, iaculis at lobortis eu.")
        ]
    }
}
