//
//  OnboardingCCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 25.05.24.
//

import UIKit
import SnapKit
class OnboardingCCollectionViewCell: UICollectionViewCell {

    private let mealImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 14.674
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mealImageView)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        let screenWidth = UIScreen.main.bounds.width
        mealImageView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth/2-44)
            make.height.equalTo(screenWidth/2-44)
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    func configure(_ item: OnboardingCMealItem){
        mealImageView.image = UIImage(named: item.image)
    }
}
