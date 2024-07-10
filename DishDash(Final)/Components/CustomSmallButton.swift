//
//  CustomSmallButton.swift
//  DishDash(Final)
//
//  Created by Apple on 25.05.24.
//

import UIKit
import SnapKit
class CustomSmallButton: UIButton{
    init(title: String, backgroundColor: String, textColor: String){
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor(named: textColor), for: .normal)
        self.backgroundColor = UIColor(named: backgroundColor)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton(){
        self.layer.cornerRadius = 22.5
        self.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.width.equalTo(162)
        }
        self.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 20)
    }
}

