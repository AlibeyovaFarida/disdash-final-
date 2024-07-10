//
//  TopChefTableViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 10.06.24.
//

import UIKit

class TopChefTableViewCell: UITableViewCell {
    
    private var chefList: [ChefModel] = []
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "RedPinkMain")
        lb.text = "Top Chef"
        return lb
    }()
    
    private let topChefCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 9
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 28, bottom: 0, right: 28)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 83) / 4, height: 94)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(TopChefCollectionViewCell.self, forCellWithReuseIdentifier: TopChefCollectionViewCell.identifier)
        return cv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        topChefCollectionView.dataSource = self
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(topChefCollectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        topChefCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(94)
        }
    }
}

extension TopChefTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chefList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopChefCollectionViewCell.identifier, for: indexPath) as! TopChefCollectionViewCell
        cell.configure(chefList[indexPath.row])
        return cell
    }
    func configure(_ item: [ChefModel]){
        chefList = item
        topChefCollectionView.reloadData()
    }
}
