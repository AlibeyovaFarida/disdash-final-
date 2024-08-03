//
//  NotificationsViewModel.swift
//  DishDash(Final)
//
//  Created by Apple on 31.07.24.
//

import Foundation

class NotificationsViewModel{
    private(set) var notificationsList: [[NotificationItemModel]] = [[]]
    private(set) var notifications: [String] = []
    init(){
        self.notificationsList = [[
            .init(icon: "notification-star-icon", title: "Weekly New Recipes!", subtitle: "Discover our new recipes of the week!", date: "2 Min Ago"),
            .init(icon: "notification-bell-icon", title: "Meal Reminder", subtitle: "Time to cook your healthy meal of the day", date: "35 Min Ago")],
            [.init(icon: "notification-bell-icon", title: "New update available", subtitle: "Performance improvements and bug fixes.", date: "25 April 2024"),
            .init(icon: "notification-star-icon", title: "Reminder", subtitle: "Don't forget to complete your profile to access all app features", date: "25 April 2024"),
             .init(icon: "notification-star-icon", title: "Important Notice", subtitle: "Remember to change your password regularly  to keep your account secure", date: "25 April 2024")],
            [.init(icon: "notification-star-icon", title: "New update available", subtitle: "Performance improvements and bug fixes.", date: "23 April 2024")]
        ]
        self.notifications = ["Today", "Wednesday", "Monday"]
    }
}
