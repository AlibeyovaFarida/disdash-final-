//
//  OnboardingCViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 25.05.24.
//

import UIKit
import SnapKit

class OnboardingCViewController: UIViewController {
    private let gallery: [OnboardingCMealItem] = [
        .init(image: "onboarding-c-1"),
        .init(image: "onboarding-c-2"),
        .init(image: "onboarding-c-3"),
        .init(image: "onboarding-c-4"),
        .init(image: "onboarding-c-5"),
        .init(image: "onboarding-c-6")
    ]
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 13
        return sv
    }()
    private let galleryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 24
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: screenWidth/2-44, height: screenWidth/2-44)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.register(OnboardingCCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCCollectionViewCell.identifier)
        return cv
    }()
    private let textStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 11
        return sv
    }()
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-SemiBold", size: 25)
        lb.text = "Welcome"
        lb.textAlignment = .center
        return lb
    }()
    private let descLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Regular", size: 13)
        lb.text = "Find the best recipes that the world can provide you also with every step that you can learn to increase your cooking skills."
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    private let buttonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 20
        return sv
    }()
    private let directionRegisterBtn: UIButton = CustomMiddleButton(title: "I’m New", backgroundColor: "PinkBase", textColor: "PinkSubColor")
    private let directionLoginBtn: UIButton = CustomMiddleButton(title: "I’ve been here", backgroundColor: "PinkBase", textColor: "PinkSubColor")
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBackButton()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        view.addSubview(stackView)
        [
            galleryCollectionView,
            textStackView,
            buttonsStackView
        ].forEach(stackView.addArrangedSubview)
        [
            titleLabel,
            descLabel
        ].forEach(textStackView.addArrangedSubview)
        [
            directionRegisterBtn,
            directionLoginBtn
        ].forEach(buttonsStackView.addArrangedSubview)
        stackView.setCustomSpacing(28, after: textStackView)
        galleryCollectionView.dataSource = self
        setupUI()
        setupActions()
    }
    private func setupCustomBackButton(){
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "back-button"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    private func setupUI(){
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
        }
    }
    private func setupActions(){
        directionRegisterBtn.addTarget(self, action: #selector(didTapContinueSliderButton), for: .touchUpInside)
        directionLoginBtn.addTarget(self, action: #selector(didTapContinueLoginBtn), for: .touchUpInside)
    }
    @objc
    private func didTapContinueSliderButton(){
        let vc = SliderViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc
    private func didTapContinueLoginBtn(){
        let vc = LoginViewController()
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
}
extension OnboardingCViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCCollectionViewCell.identifier, for: indexPath) as! OnboardingCCollectionViewCell
        cell.configure(gallery[indexPath.row])
        return cell
    }
}
