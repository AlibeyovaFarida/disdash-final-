//
//  NotificationsViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 10.07.24.
//

import UIKit

class NotificationsViewController: UIViewController {
    private let notificationsList: [[NotificationItemModel]] = [[
        .init(icon: "notification-star-icon", title: "Weekly New Recipes!", subtitle: "Discover our new recipes of the week!", date: "2 Min Ago"),
        .init(icon: "notification-bell-icon", title: "Meal Reminder", subtitle: "Time to cook your healthy meal of the day", date: "35 Min Ago")],
        [.init(icon: "notification-bell-icon", title: "New update available", subtitle: "Performance improvements and bug fixes.", date: "25 April 2024"),
        .init(icon: "notification-star-icon", title: "Reminder", subtitle: "Don't forget to complete your profile to access all app features", date: "25 April 2024"),
         .init(icon: "notification-star-icon", title: "Important Notice", subtitle: "Remember to change your password regularly  to keep your account secure", date: "25 April 2024")],
        [.init(icon: "notification-star-icon", title: "New update available", subtitle: "Performance improvements and bug fixes.", date: "23 April 2024")]
    ]
    private let notifications: [String] = ["Today", "Wednesday", "Monday"]
    private let notificationsTableView: UITableView = {
        let tv = UITableView()
        tv.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.identifier)
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBackButton()
        notificationsTableView.backgroundColor = .clear
        view.backgroundColor = UIColor(named: "WhiteBeige")
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
        notificationsTableView.separatorStyle = .none
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    private func setupCustomBackButton() {
        guard let backButtonImage = UIImage(named: "back-button") else {
                print("Error: Back button image not found.")
                return
            }
            
        let backButton = UIButton(type: .custom)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
            
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
            
        backButton.snp.makeConstraints { make in
            make.width.equalTo(22.4)
            make.height.equalTo(14)
        }
    }
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    private func setupUI(){
        view.addSubview(notificationsTableView)
        notificationsTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
            make.bottom.equalToSuperview()
        }
    }
}
extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return notificationsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsList[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return notifications[section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier) as! NotificationTableViewCell
        cell.configure(notificationsList[indexPath.section][indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
            header.textLabel?.textColor = UIColor(named: "TextColorBrown")
            header.textLabel?.snp.makeConstraints({ make in
                make.leading.equalToSuperview()
            })
        }
    }
}
