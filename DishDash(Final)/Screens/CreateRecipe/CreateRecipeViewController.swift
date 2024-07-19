//
//  CreateRecipeViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 19.07.24.
//

import UIKit

class CreateRecipeViewController: UIViewController {
    private let publishDeleteButtonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 6
        return sv
    }()
    private let publishButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Publish", for: .normal)
        btn.backgroundColor = UIColor(named: "PinkBase")
        btn.titleLabel?.textColor = UIColor(named: "PinkSubColor")
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 13.5
        return btn
    }()
    private let recipeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Publish", for: .normal)
        btn.backgroundColor = UIColor(named: "PinkBase")
        btn.titleLabel?.textColor = UIColor(named: "PinkSubColor")
        btn.frame = CGRect(x: 0, y: 0, width: 177, height: 27)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 13.5
        return btn
    }()
    private let deleteButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Delete", for: .normal)
        btn.backgroundColor = UIColor(named: "PinkBase")
        btn.titleLabel?.textColor = UIColor(named: "PinkSubColor")
        btn.frame = CGRect(x: 0, y: 0, width: 177, height: 27)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 13.5
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        setupUI()
    }
    private func setupUI(){
        view.addSubview(publishDeleteButtonsStackView)
        [
            publishButton,
            deleteButton
        ].forEach(publishDeleteButtonsStackView.addArrangedSubview)
        
        publishDeleteButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(26)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        
        publishButton.snp.makeConstraints { make in
            make.width.equalTo(177)
            make.height.equalTo(27)
        }
    }
}
