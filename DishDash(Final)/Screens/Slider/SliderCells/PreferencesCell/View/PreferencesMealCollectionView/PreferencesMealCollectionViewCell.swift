//
//  PreferencesMealCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 28.05.24.
//

import UIKit

class PreferencesMealCollectionViewCell: UICollectionViewCell {
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 6.51
        sv.alignment = .center
        return sv
    }()
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 11.742
        return iv
    }()
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 13.253)
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
            make.width.equalTo(95.958)
            make.height.equalTo(98.633)
        }
    }
    
    func configure(_ item: PreferencesMealItemModel){
        imageView.image = UIImage(named: item.mealImage)
        titleLabel.text = item.mealTitle
    }
}
