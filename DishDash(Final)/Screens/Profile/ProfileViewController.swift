//
//  ProfileViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 30.06.24.
//

import UIKit
import FirebaseAuth
class ProfileViewController: UIViewController {
    private let recipeList: [RecipeModel] = [
        .init(name: "Crispy Shrimp", image: "crispy-shrimp", description: "A feast for the senses", rating: 4, cookingTime: "20min"),
        .init(name: "Chicken Wings", image: "chicken-wings", description: "Delicious and juicy wings", rating: 5, cookingTime: "30min"),
        .init(name: "Colors Macarons", image: "colors-macarons", description: "Sweet bites full of elegance", rating: 4, cookingTime: "40min"),
        .init(name: "Pina Colada", image: "pina-colada", description: "A tropical explosion in every sip", rating: 4, cookingTime: "30min"),
        .init(name: "Spring Rolls", image: "spring-rolls", description: "Delicate and full of flavor", rating: 4, cookingTime: "30min"),
        .init(name: "French Toast", image: "french-toast", description: "Delicious slices of bread", rating: 4, cookingTime: "30min")
    ]
    
    private let favoritesCategoryList: [FavoritesCategoryItemModel] = [
        .init(image: "sweet", name: "Sweet"),
        .init(image: "salty", name: "Salty")
    ]
    private let profileCardStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 13
        sv.alignment = .center
        return sv
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "dianne-russell")
        iv.layer.cornerRadius = 47.5
        return iv
    }()
    private let profileCardDescriptionView: UIView = {
        let view = UIView()
        return view
    }()
    private let addRecipeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "plus-icon"), for: .normal)
        btn.backgroundColor = UIColor(named: "PinkBase")
        btn.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        btn.layer.cornerRadius = 14
        return btn
    }()
    private let logoutButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "log-out"), for: .normal)
        btn.backgroundColor = UIColor(named: "RedPinkMain")
        btn.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        btn.layer.cornerRadius = 14
        btn.addTarget(self, action: #selector(didTapLogOut), for: .touchUpInside)
        return btn
    }()
    @objc
    private func didTapLogOut(){
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: true, completion: {
        self.tabBarController?.dismiss(animated: false, completion: nil)
            do{
                try Auth.auth().signOut()
                self.tabBarController?.view.removeFromSuperview()
            } catch let signoutError as NSError {
                self.showAlert(title: "SignOut error", message: signoutError.localizedDescription)
            }
        })
    }
    private let descriptionStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    private let nameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "RedPinkMain")
        lb.text = "Dianne Russell"
        return lb
    }()
    private let usernameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "PinkSubColor")
        lb.text = "@dianne_r"
        return lb
    }()
    private let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "My passion is cooking and sharing new recipes with the world."
        lb.numberOfLines = 0
        return lb
    }()
    private let buttonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        return sv
    }()
    private let editButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(UIColor(named: "PinkSubColor"), for: .normal)
        btn.backgroundColor = UIColor(named: "PinkBase")
        btn.layer.cornerRadius = 13.5
        btn.frame = CGRect(x: 0, y: 0, width: 175, height: 27)
        btn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
        btn.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        return btn
    }()
    @objc
    private func didTapEditButton(){
        let vc = EditProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    private let shareButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Share Profile", for: .normal)
        btn.setTitleColor(UIColor(named: "PinkSubColor"), for: .normal)
        btn.backgroundColor = UIColor(named: "PinkBase")
        btn.layer.cornerRadius = 13.5
        btn.frame = CGRect(x: 0, y: 0, width: 175, height: 27)
        btn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
        return btn
    }()
    private let interactionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "PinkBase")?.cgColor
        return view
    }()
    private let interactionStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        return sv
    }()
    private let recipeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        return sv
    }()
    private let recipeCountLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "60"
        return lb
    }()
    private let recipeLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "recipes"
        return lb
    }()
    private let seperatorLine1: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "seperator-line")
        return iv
    }()
    private let followingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        return sv
    }()
    private let followingCountLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "120"
        return lb
    }()
    private let followingLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "Following"
        return lb
    }()
    private let seperatorLine2: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "seperator-line")
        return iv
    }()
    private let followersStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        return sv
    }()
    private let followersCountLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "250"
        return lb
    }()
    private let followersLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "Followers"
        return lb
    }()
    
    private let switchStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
//        sv.spacing = 33
        sv.distribution = .equalSpacing
        return sv
    }()
    
    private let recipeTabStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        return sv
    }()
    
    private let recipeTabLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "Recipe"
        lb.textAlignment = .center
        return lb
    }()
    
    private let recipeTabLineImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "recipe-button-bottom-line")
        iv.tintColor = UIColor(named: "RedPinkMain")
        return iv
    }()
    private let favoritesTabStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        return sv
    }()
    
    private let favoritesTabLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "Favorites"
        lb.textAlignment = .center
        return lb
    }()
    
    private let favoritesTabLineImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "recipe-button-bottom-line")
        iv.tintColor = UIColor(named: "WhiteBeige")
        return iv
    }()
    
    private let recipeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 31
        layout.minimumInteritemSpacing = 18
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 74) / 2 , height: 226)
        layout.sectionInset = .init(top: 0, left: 28, bottom: 79, right: 28)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        return cv
    }()
    
    private let favoritesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.sectionInset = .init(top: 0, left: 28, bottom: 0, right: 28)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 56), height: 133)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FavoritesCategoryCollectionViewCell.self, forCellWithReuseIdentifier: FavoritesCategoryCollectionViewCell.identifier)
        return cv
    }()
    
    private let bottomShadowImageView = BottomShadowImageView()
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "WhiteBeige")
        recipeCollectionView.dataSource = self
        recipeCollectionView.isHidden = true
        favoritesCollectionView.dataSource = self
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI(){
        view.addSubview(profileCardStackView)
        [
            profileImageView,
            profileCardDescriptionView
        ].forEach(profileCardStackView.addArrangedSubview)
        profileCardDescriptionView.addSubview(addRecipeButton)
        profileCardDescriptionView.addSubview(logoutButton)
        profileCardDescriptionView.addSubview(descriptionStackView)
        [
            nameLabel,
            usernameLabel,
            descriptionLabel
        ].forEach(descriptionStackView.addArrangedSubview)
        view.addSubview(buttonsStackView)
        [
            editButton,
            shareButton
        ].forEach(buttonsStackView.addArrangedSubview)
        view.addSubview(interactionView)
        view.addSubview(switchStackView)
        [
            recipeTabStackView,
            favoritesTabStackView
        ].forEach(switchStackView.addArrangedSubview)
        [
            recipeTabLabel,
            recipeTabLineImageView
        ].forEach(recipeTabStackView.addArrangedSubview)
        [
            favoritesTabLabel,
            favoritesTabLineImageView
        ].forEach(favoritesTabStackView.addArrangedSubview)
        interactionView.addSubview(interactionStackView)
        [
            recipeStackView,
            seperatorLine1,
            followingStackView,
            seperatorLine2,
            followersStackView
        ].forEach(interactionStackView.addArrangedSubview)
        [
            recipeCountLabel,
            recipeLabel
        ].forEach(recipeStackView.addArrangedSubview)
        [
            followingCountLabel,
            followingLabel
        ].forEach(followingStackView.addArrangedSubview)
        [
            followersCountLabel,
            followersLabel
        ].forEach(followersStackView.addArrangedSubview)
        
        view.addSubview(recipeCollectionView)
        view.addSubview(favoritesCollectionView)
        view.addSubview(bottomShadowImageView)
        profileCardStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(13.7)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(102)
            make.height.equalTo(97)
        }
        
        addRecipeButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(28)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalTo(addRecipeButton.snp.leading).offset(-5)
            make.size.equalTo(28)
        }
        descriptionStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.trailing.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(profileCardStackView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        
        editButton.snp.makeConstraints { make in
            let screenWidth = UIScreen.main.bounds.width
            make.width.equalTo((screenWidth - 62) / 2)
            make.height.equalTo(27)
        }
        
        shareButton.snp.makeConstraints { make in
            let screenWidth = UIScreen.main.bounds.width
            make.width.equalTo((screenWidth - 62) / 2)
            make.height.equalTo(27)
        }
        
        interactionView.snp.makeConstraints { make in
            make.top.equalTo(buttonsStackView.snp.bottom).offset(6)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        
        interactionStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        seperatorLine1.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(26)
        }
        
        seperatorLine2.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(26)
        }
        
        switchStackView.snp.makeConstraints { make in
            make.top.equalTo(interactionView.snp.bottom).offset(17.71)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        recipeTabLineImageView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        favoritesTabLineImageView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        recipeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(switchStackView.snp.bottom).offset(19)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        favoritesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(switchStackView.snp.bottom).offset(19)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recipeCollectionView{
            return recipeList.count
        }
        if collectionView == favoritesCollectionView {
            return favoritesCategoryList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recipeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as! RecipeCollectionViewCell
            cell.configure(recipeList[indexPath.row])
            return cell
        }
        if collectionView == favoritesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesCategoryCollectionViewCell.identifier, for: indexPath) as! FavoritesCategoryCollectionViewCell
            cell.configure(favoritesCategoryList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}
