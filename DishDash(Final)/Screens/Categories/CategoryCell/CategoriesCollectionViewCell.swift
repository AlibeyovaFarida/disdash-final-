//
//  CategoriesCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 14.06.24.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    private let categoryStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 6
        sv.alignment = .center
        return sv
    }()
    private let categoryLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 16)
        lb.textColor = UIColor(named: "TextColorBrown")
        return lb
    }()
    private let categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 13
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(categoryStackView)
        [
            categoryImageView,
            categoryLabel
        ].forEach(categoryStackView.addArrangedSubview)
        categoryStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(_ item: CategoryItemModel){
        categoryImageView.image = UIImage(named: item.image)
        categoryLabel.text = item.title
    }
}
