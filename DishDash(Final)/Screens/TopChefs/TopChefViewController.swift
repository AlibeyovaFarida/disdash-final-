//
//  TopChefViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 21.06.24.
//

import UIKit

class TopChefViewController: UIViewController {
    private let mostViewedChefs: [TopChefsModel] = [
        .init(image: "neil-tran-top", name: "Neil Tran-Chef", username: "@neil_tran", ratingCount: 6687),
        .init(image: "jessica-davis", name: "Jessica Davis-Chef", username: "@jessi_davis", ratingCount: 5687),
        .init(image: "neil-tran-top", name: "Neil Tran-Chef", username: "@neil_tran", ratingCount: 6687),
        .init(image: "jessica-davis", name: "Jessica Davis-Chef", username: "@jessi_davis", ratingCount: 5687)
    ]
    private let chefsList: [TopChefsModel] = [
        .init(image: "daniel-martinez", name: "Daniel Martinez", username: "@dan-chef", ratingCount: 6687),
        .init(image: "aria-chang", name: "Aria Chang", username: "@ariachang-chef", ratingCount: 5687),
        .init(image: "lily-chen", name: "Lily Chen-Chef", username: "@lily.chef", ratingCount: 6687),
        .init(image: "edward-jones", name: "Edward Jones", username: "@edjones-chef", ratingCount: 5687)
    ]
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
        setupCustomBackButton()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        mostViewedChefsCollectionView.dataSource = self
        chefsCollectionView.dataSource = self
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
