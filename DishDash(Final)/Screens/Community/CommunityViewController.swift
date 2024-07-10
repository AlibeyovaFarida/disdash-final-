//
//  CommunityViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 25.06.24.
//

import UIKit

class CommunityViewController: UIViewController {
    private let communityCardList: [CommunityCardModel] = [
        .init(authorImage: "josh-ryan", username: "@josh-ryan", time: "2 years ago", recipeImage: "community-chicken-curry", recipeName: "Chicken Curry ", rating: 5, description: "This recipe requires basic ingredients and minimal prep time, making it ideal for busy days...", cookingTime: "45min", comment: 2458),
        .init(authorImage: "dakota.mullen", username: "@dakota.mullen", time: "11 Month ago", recipeImage: "community-macarons", recipeName: "Macarons", rating: 5, description: "This recipe will guide you through the art of making perfect macarons...", cookingTime: "38min", comment: 2273),
        .init(authorImage: "cia_food", username: "@cia_food", time: "15 months ago", recipeImage: "community-chicken-burger", recipeName: "Chicken Burger", rating: 5, description: "This recipe requires basic ingredients and minimal prep time, making it ideal for busy days...", cookingTime: "45 min", comment: 1983)
    ]
    private let filterList: [FilterChoiseModel] = [
        .init(name: "Top Recipes", isSelected: true),
        .init(name: "Newest", isSelected: false),
        .init(name: "Oldest", isSelected: false)
    ]
    private let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.sectionInset = .init(top: 0, left: 28, bottom: 0, right: 28)
        layout.itemSize = .init(width: 119, height: 25)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        return cv
    }()
    
    private let communityCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 19
        layout.sectionInset = .init(top: 0, left: 28, bottom: 0, right: 28)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 56), height: 320)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.register(CommunityCardCollectionViewCell.self, forCellWithReuseIdentifier: CommunityCardCollectionViewCell.identifier)
        return cv
    }()
    private let bottomShadowImageView = BottomShadowImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        filterCollectionView.dataSource = self
        communityCollectionView.dataSource = self
        setupUI()
    }
    private func setupUI(){
        view.addSubview(filterCollectionView)
        view.addSubview(communityCollectionView)
        view.addSubview(bottomShadowImageView)
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(36)
        }
        communityCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterCollectionView.snp.bottom).offset(22)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}
extension CommunityViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return filterList.count
        }
        if collectionView == communityCollectionView {
            return communityCardList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as! FilterCollectionViewCell
            cell.configure(filterList[indexPath.row])
            return cell
        }
        if collectionView == communityCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityCardCollectionViewCell.identifier, for: indexPath) as! CommunityCardCollectionViewCell
            cell.configure(communityCardList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}
