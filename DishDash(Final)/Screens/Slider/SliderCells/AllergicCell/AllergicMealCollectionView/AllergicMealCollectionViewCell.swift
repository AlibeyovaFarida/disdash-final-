//
//  AllergicMealCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 28.05.24.
//

import UIKit

class AllergicMealCollectionViewCell: UICollectionViewCell {
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 7
        sv.alignment = .center
        return sv
    }()
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 13.29
        iv.layer.borderWidth = 1.3
        iv.layer.borderColor = UIColor(named: "PinkBase")?.cgColor
        return iv
    }()
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
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
        contentView.addSubview(stackView)
        [
            imageView,
            titleLabel
        ].forEach(stackView.addArrangedSubview)
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
    }
    
    func configure(_ item: AllergicMealItemModel){
        imageView.image = UIImage(named: item.mealImage)
        titleLabel.text = item.mealTitle
    }
}
