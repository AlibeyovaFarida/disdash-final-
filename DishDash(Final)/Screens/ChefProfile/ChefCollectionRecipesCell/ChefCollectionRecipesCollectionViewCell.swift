//
//  ChefCollectionRecipesCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 24.06.24.
//

import UIKit

class ChefCollectionRecipesCollectionViewCell: UICollectionViewCell {
    private let recipeCollectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    private let categoryNameView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "PinkSubColor")?.cgColor
        view.layer.cornerRadius = 20
        return view
    }()
    private let categoryNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 16)
        lb.textColor = .black
        lb.textAlignment = .center
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(recipeCollectionView)
        recipeCollectionView.addSubview(categoryNameView)
        recipeCollectionView.addSubview(categoryImageView)
        categoryNameView.addSubview(categoryNameLabel)
        
        recipeCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        categoryImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            let screenWidth = UIScreen.main.bounds.width
            make.width.equalTo(screenWidth - 56)
            make.height.equalTo(103)
        }
        categoryNameView.snp.makeConstraints { make in
            make.top.equalTo(categoryImageView.snp.bottom).offset(-40)
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
        }
        categoryNameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    func configure(_ item: ChefCollectionRecipesModel){
        categoryImageView.image = UIImage(named: item.image)
        categoryNameLabel.text = item.name
    }
}
