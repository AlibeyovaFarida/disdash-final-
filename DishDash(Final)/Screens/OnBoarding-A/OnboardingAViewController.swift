//
//  OnboardingAViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 24.05.24.
//

import UIKit

class OnboardingAViewController: UIViewController {
    private let textStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Get Inspired"
        label.font = UIFont(name: "Poppins-SemiBold", size: 20)
        return label
    }()
    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = "Get inspired with our daily recipe recommendations."
        label.font = UIFont(name: "Poppins-Regular", size: 13)
        label.numberOfLines = 0
        return label
    }()
    private let topShadowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "top-shadow")
        return iv
    }()
    private let mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "onboarding-a")
        return iv
    }()
    private let bottomShadowImageView = BottomShadowImageView()
    private let continueButton = CustomMiddleButton(title: "Continue", backgroundColor: "PinkBase", textColor: "PinkSubColor")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        [
            textStackView,
            mainImageView,
            topShadowImageView,
            bottomShadowImageView,
            continueButton
        ].forEach(view.addSubview)
        [
            titleLabel,
            descLabel
        ].forEach(textStackView.addArrangedSubview)
        setupUI()
        bottomShadowImageView.setupConstraints()
        setupActions()
    }
    private func setupUI(){
        textStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(26)
        }
        topShadowImageView.snp.makeConstraints { make in
            make.top.equalTo(textStackView.snp.bottom).offset(20.75)
            make.leading.equalTo(mainImageView.snp.leading)
            make.trailing.equalTo(mainImageView.snp.trailing)
        }
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(textStackView.snp.bottom).offset(44.32)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(720)
        }
        continueButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(48)
            make.centerX.equalToSuperview()
        }
    }
    private func setupActions(){
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
    }
    @objc
    private func didTapContinue(){
        let vc = OnboardingBViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
