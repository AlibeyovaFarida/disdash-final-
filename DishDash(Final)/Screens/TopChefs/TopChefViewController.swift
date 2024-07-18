//
//  TopChefViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 21.06.24.
//

import UIKit
import Firebase

class TopChefViewController: UIViewController {
    private var mostViewedChefs: [TopChefsModel] = []
    private var chefsList: [TopChefsModel] = []
    private let mostViewedChefsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "RedPinkMain")
        view.layer.cornerRadius = 20
        return view
    }()
    private let mostViewedChefsTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "WhiteBeige")
        lb.text = "Most viewed chefs"
        return lb
    }()
    private let mostViewedChefsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 28
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 84) / 2, height: 226)
        layout.sectionInset = .init(top: 0, left: 28, bottom: 0, right: 28)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TopChefsCollectionViewCell.self, forCellWithReuseIdentifier: TopChefsCollectionViewCell.identifier)
        return cv
    }()
    private let chefsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 17
        layout.minimumInteritemSpacing = 8
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 73) / 2, height: 226)
        layout.sectionInset = .init(top: 0, left: 28, bottom: 0, right: 28)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TopChefsCollectionViewCell.self, forCellWithReuseIdentifier: TopChefsCollectionViewCell.identifier)
        return cv
    }()
    
    private let bottomShadowImageView = BottomShadowImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        db.collection("chefs").order(by: "rating", descending: true).limit(to: 2).getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(title: "Server error", message: error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    self.mostViewedChefs.append(TopChefsModel(
                        image: document.data()["image"] as! String,
                        name: "\(document.data()["name"] as! String) \(document.data()["surname"] as! String)",
                        username: document.data()["username"] as! String,
                        ratingCount: document.data()["rating"] as! Int))
                }
                DispatchQueue.main.async {
                    self.mostViewedChefsCollectionView.reloadData()
                }
            }
        }
        db.collection("chefs").order(by: "rating", descending: true).limit(toLast: 23).getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(title: "Server error", message: error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    self.chefsList.append(TopChefsModel(
                        image: document.data()["image"] as! String,
                        name: "\(document.data()["name"] as! String) \(document.data()["surname"] as! String)",
                        username: document.data()["username"] as! String,
                        ratingCount: document.data()["rating"] as! Int))
                }
                DispatchQueue.main.async {
                    self.chefsCollectionView.reloadData()
                }
            }
        }
        setupCustomBackButton()
        navigationItem.title = "Top Chef"
        if let navigationBar = self.navigationController?.navigationBar {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(named: "RedPinkMain")!
            ]
            navigationBar.titleTextAttributes = textAttributes
        }
        view.backgroundColor = UIColor(named: "WhiteBeige")
        mostViewedChefsCollectionView.dataSource = self
        mostViewedChefsCollectionView.delegate = self
        chefsCollectionView.dataSource = self
        chefsCollectionView.delegate = self
        mostViewedChefsCollectionView.backgroundColor = .clear
        chefsCollectionView.backgroundColor = .clear
        setupUI()
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
        view.addSubview(mostViewedChefsView)
        view.addSubview(chefsCollectionView)
        view.addSubview(bottomShadowImageView)
        mostViewedChefsView.addSubview(mostViewedChefsTitleLabel)
        mostViewedChefsView.addSubview(mostViewedChefsCollectionView)
        mostViewedChefsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        mostViewedChefsTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(9)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        mostViewedChefsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mostViewedChefsTitleLabel.snp.bottom).offset(9)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(18)
            make.height.equalTo(226)
        }
        chefsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mostViewedChefsView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
extension TopChefViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mostViewedChefsCollectionView{
            let vc = ChefProfileViewController(chefUsername: mostViewedChefs[indexPath.row].username)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ChefProfileViewController(chefUsername: chefsList[indexPath.row].username)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension TopChefViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mostViewedChefsCollectionView{
            return mostViewedChefs.count
        }
        if collectionView == chefsCollectionView{
            return chefsList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopChefsCollectionViewCell.identifier, for: indexPath) as! TopChefsCollectionViewCell
        if collectionView == mostViewedChefsCollectionView{
            cell.configure(mostViewedChefs[indexPath.row])
            return cell
        }
        if collectionView == chefsCollectionView{
            cell.configure(chefsList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
}
