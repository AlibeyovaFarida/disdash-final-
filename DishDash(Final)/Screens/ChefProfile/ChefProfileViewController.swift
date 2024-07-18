//
//  ChefProfileViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 23.06.24.
//

import UIKit
import Firebase

class ChefProfileViewController: UIViewController {
    private var chefUsername: String = ""
    private let chefCollectionRecipesList: [ChefCollectionRecipesModel] = [
        .init(image: "asian-heritage", name: "Salty"),
        .init(image: "guilty-pleasures", name: "Sweet")
    ]
    private let chefProfileStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 13
        return sv
    }()
    private let chefProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 48.5
        return iv
    }()
    private let chefProfileDetailsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 7
        return sv
    }()
    private let chefNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "RedPinkMain")
        return lb
    }()
    private let chefDescriptionLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "Passionate chef in creative and contemporary cuisine."
        lb.numberOfLines = 0
        return lb
    }()
    private let followingButton: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 81, height: 19)
        btn.setTitle("Following", for: .normal)
        btn.setTitleColor(UIColor(named: "WhiteBeige"), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 9.5)
        btn.backgroundColor = UIColor(named: "RedPinkMain")
        btn.layer.cornerRadius = 9.5
        return btn
    }()
    private let interactionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "PinkBase")?.cgColor
        view.layer.cornerRadius = 14
        return view
    }()
    private let interactionStackView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .equalSpacing
        sv.axis = .horizontal
        sv.alignment = .center
        return sv
    }()
    private let recipesStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = -3
        return sv
    }()
    private let recipesCountLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "15"
        return lb
    }()
    private let recipesLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "Recipes"
        return lb
    }()
    private let seperatorLine1ImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "seperator-line")
        return iv
    }()
    private let followingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = -3
        return sv
    }()
    private let followingCountLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "10"
        return lb
    }()
    private let followingLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "Following"
        return lb
    }()
    private let seperatorLine2ImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "seperator-line")
        return iv
    }()
    private let followersStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = -2
        return sv
    }()
    private let followersCountLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "255.770"
        return lb
    }()
    private let followersLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "Followers"
        return lb
    }()
    private let recipeHeaderStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 1
        sv.alignment = .center
        return sv
    }()
    private let recipeHeaderLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "BrownLetters")
        lb.text = "Recipes"
        return lb
    }()
    private let recipeHeaderBottomLineImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "header-bottom-line")
        return iv
    }()
    
    private let chefCollectionsRecipesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.sectionInset = .init(top: 0, left: 28, bottom: 0, right: 28)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: screenWidth - 56, height: 133)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ChefCollectionRecipesCollectionViewCell.self, forCellWithReuseIdentifier: ChefCollectionRecipesCollectionViewCell.identifier)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(chefUsername, "hello")
        let db = Firestore.firestore()
        db.collection("chefs").whereField("username", isEqualTo: chefUsername).getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(title: "Server error", message: error.localizedDescription)
            } else {
                for document in querySnapshot!.documents{
                    self.chefProfileImageView.kf.setImage(with: URL(string: document.data()["image"] as! String))
                    self.chefNameLabel.text = "\(document.data()["name"] as! String) \(document.data()["surname"] as! String)"
                    self.navigationItem.title = "@\( document.data()["username"] as! String)"
                }
            }
        }
        if let navigationBar = self.navigationController?.navigationBar {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(named: "RedPinkMain")!
            ]
            navigationBar.titleTextAttributes = textAttributes
        }
        setupCustomBackButton()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        chefCollectionsRecipesCollectionView.dataSource = self
        chefCollectionsRecipesCollectionView.delegate = self
        setupUI()
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
    init(chefUsername: String) {
        super.init(nibName: nil, bundle: nil)
        self.chefUsername = chefUsername
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI(){
        view.addSubview(chefProfileStackView)
        [
            chefProfileImageView,
            chefProfileDetailsStackView
        ].forEach(chefProfileStackView.addArrangedSubview)
        [
            chefNameLabel,
            chefDescriptionLabel,
            followingButton
        ].forEach(chefProfileDetailsStackView.addArrangedSubview)
        view.addSubview(interactionView)
        interactionView.addSubview(interactionStackView)
        [
            recipesStackView,
            seperatorLine1ImageView,
            followingStackView,
            seperatorLine2ImageView,
            followersStackView
        ].forEach(interactionStackView.addArrangedSubview)
        [
            recipesCountLabel,
            recipesLabel
        ].forEach(recipesStackView.addArrangedSubview)
        [
            followingCountLabel,
            followingLabel
        ].forEach(followingStackView.addArrangedSubview)
        [
            followersCountLabel,
            followersLabel
        ].forEach(followersStackView.addArrangedSubview)
        view.addSubview(recipeHeaderStackView)
        [
            recipeHeaderLabel,
            recipeHeaderBottomLineImageView
        ].forEach(recipeHeaderStackView.addArrangedSubview)
        view.addSubview(chefCollectionsRecipesCollectionView)
        chefProfileStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        chefProfileImageView.snp.makeConstraints { make in
            make.width.equalTo(102)
            make.height.equalTo(97)
        }
        followingButton.snp.makeConstraints { make in
            make.width.equalTo(81)
            make.height.equalTo(19)
        }
        interactionView.snp.makeConstraints { make in
            make.top.equalTo(chefProfileStackView.snp.bottom).offset(12.7)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        interactionStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        seperatorLine1ImageView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(26)
        }
        seperatorLine2ImageView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(26)
        }
        recipeHeaderStackView.snp.makeConstraints { make in
            make.top.equalTo(interactionView.snp.bottom).offset(13.3)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        recipeHeaderBottomLineImageView.snp.makeConstraints { make in
            make.width.equalTo(358)
            make.height.equalTo(1)
        }
        chefCollectionsRecipesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recipeHeaderStackView.snp.bottom).offset(15.2)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}
extension ChefProfileViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = RecipesViewController(categoryName: chefCollectionRecipesList[indexPath.row].name, chefUsername: chefUsername)
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension ChefProfileViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chefCollectionRecipesList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChefCollectionRecipesCollectionViewCell.identifier, for: indexPath) as! ChefCollectionRecipesCollectionViewCell
        cell.configure(chefCollectionRecipesList[indexPath.row])
        return cell
    }
}
