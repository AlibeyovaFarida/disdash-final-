//
//  TopChefCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 10.06.24.
//

import UIKit

class TopChefCollectionViewCell: UICollectionViewCell {
    
    private let chefStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 2
        sv.alignment = .center
        return sv
    }()
    
    private let chefImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 6.8
        iv.clipsToBounds = true
        return iv
    }()
    
    private let chefNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "TextColorBrown")
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
        contentView.addSubview(chefStackView)
        [
            chefImageView,
            chefNameLabel
        ].forEach(chefStackView.addArrangedSubview)
        
        chefStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func configure(_ item: ChefModel){
        chefImageView.image = UIImage(named: item.image)
        chefNameLabel.text = item.name
    }
}
