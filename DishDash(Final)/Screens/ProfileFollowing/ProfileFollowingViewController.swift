//
//  ProfileFollowingViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 03.07.24.
//

import UIKit
import Firebase

class ProfileFollowingViewController: UIViewController {
    private let followingProfileList: [FollowingProfileItemModel] = [
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
    private let followersProfileList: [FollowingProfileItemModel] = [
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
    private let switchStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        return sv
    }()
    private let followingTabStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.isUserInteractionEnabled = true
        return sv
    }()
    private let followingTabLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "120 Following"
        return lb
    }()
    private let followingTabBottomLineImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "recipe-button-bottom-line")
        iv.tintColor = UIColor(named: "RedPinkMain")
        return iv
    }()
    private let followersTabStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.isUserInteractionEnabled = true
        return sv
    }()
    private let followersTabLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "250 Folowers"
        return lb
    }()
    private let followersTabBottomLineImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "recipe-button-bottom-line")
        iv.tintColor = UIColor(named: "WhiteBeige")
        return iv
    }()
    
    private let searchTextField: UISearchTextField = {
        let stf = UISearchTextField()
        stf.backgroundColor = UIColor(named: "PinkBase")
        stf.layer.cornerRadius = 17
        stf.layer.masksToBounds = true
        stf.placeholder = "Search"
        stf.tintColor = UIColor(named: "RedPinkMain")
        let placeholderColor = UIColor(named: "RedPinkMain") ?? UIColor(named: "WhiteBeige")
            let placeholderFont = UIFont(name: "Poppins-Regular", size: 12)
            stf.attributedPlaceholder = NSAttributedString(
                string: stf.placeholder ?? "",
                attributes: [
                    NSAttributedString.Key.foregroundColor: placeholderColor ?? "",
                    NSAttributedString.Key.font: placeholderFont ?? UIFont.systemFont(ofSize: 12)
                ]
            )
        stf.textColor = UIColor(named: "RedPinkMain")
        stf.font = UIFont(name: "Poppins-Regular", size: 12)
        stf.leftView = nil
        return stf
    }()
    private let followTableView: UITableView = {
        let tv = UITableView()
        tv.showsVerticalScrollIndicator = false
        tv.register(FollowingTableViewCell.self, forCellReuseIdentifier: FollowingTableViewCell.identifier)
        tv.register(FollowersProfileTableViewCell.self, forCellReuseIdentifier: FollowersProfileTableViewCell.identifier)
        return tv
    }()
    private let bottomShadowImageView = BottomShadowImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBackButton()
        let tapGestureFollowing = UITapGestureRecognizer(target: self, action: #selector(didTapFollowing))
        followingTabStackView.addGestureRecognizer(tapGestureFollowing)
        let tapGestureFollowers = UITapGestureRecognizer(target: self, action: #selector(didTapFollowers))
        followersTabStackView.addGestureRecognizer(tapGestureFollowers)
        view.backgroundColor = UIColor(named: "WhiteBeige")
        followTableView.dataSource = self
        followTableView.separatorStyle = .none
        setupUI()
    }
    @objc
    private func didTapFollowing(){
        followingTabBottomLineImageView.tintColor = UIColor(named: "RedPinkMain")
        followersTabBottomLineImageView.tintColor = UIColor(named: "WhiteBeige")
        DispatchQueue.main.async {
            self.followTableView.reloadData()
        }
    }
    @objc
    private func didTapFollowers(){
        followingTabBottomLineImageView.tintColor = UIColor(named: "WhiteBeige")
        followersTabBottomLineImageView.tintColor = UIColor(named: "RedPinkMain")
        DispatchQueue.main.async {
            self.followTableView.reloadData()
        }
    }
    private func setupUI(){
        view.addSubview(switchStackView)
        [
            followingTabStackView,
            followersTabStackView
        ].forEach(switchStackView.addArrangedSubview)
        [
            followingTabLabel,
            followingTabBottomLineImageView
        ].forEach(followingTabStackView.addArrangedSubview)
        [
            followersTabLabel,
            followersTabBottomLineImageView
        ].forEach(followersTabStackView.addArrangedSubview)
        view.addSubview(searchTextField)
        view.addSubview(followTableView)
        view.addSubview(bottomShadowImageView)
        switchStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(14)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        followingTabBottomLineImageView.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
        followersTabBottomLineImageView.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(switchStackView.snp.bottom).offset(18)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
            make.height.equalTo(34)
        }
        followTableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(19.3)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
            make.bottom.equalToSuperview()
        }
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
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
}

extension ProfileFollowingViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !followingTabBottomLineImageView.isHidden{
            return followingProfileList.count
        }
        if !followersTabBottomLineImageView.isHidden{
            return followersProfileList.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if followingTabBottomLineImageView.tintColor == UIColor(named: "RedPinkMain") {
            let cell = tableView.dequeueReusableCell(withIdentifier: FollowingTableViewCell.identifier, for: indexPath) as! FollowingTableViewCell
            cell.configure(followingProfileList[indexPath.row])
            return cell
        }
        if followersTabBottomLineImageView.tintColor == UIColor(named: "RedPinkMain"){
            let cell = tableView.dequeueReusableCell(withIdentifier: FollowersProfileTableViewCell.identifier, for: indexPath) as! FollowersProfileTableViewCell
            cell.configure(followersProfileList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
