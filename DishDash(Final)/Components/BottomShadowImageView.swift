//
//  BottomShadowImageView.swift
//  DishDash(Final)
//
//  Created by Apple on 27.05.24.
//

import UIKit
import SnapKit

class BottomShadowImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        setupImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImage()
    }
    private func setupImage() {
        self.image = UIImage(named: "bottom-shadow")
    }
    
    func setupConstraints() {
        guard self.superview != nil else {
            print("Superview is nil", superview ?? "")
            return
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(126)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}



