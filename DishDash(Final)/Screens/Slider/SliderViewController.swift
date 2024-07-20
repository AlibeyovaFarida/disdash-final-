//
//  SliderViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 25.05.24.
//

import UIKit

class SliderViewController: UIViewController {
    private let sliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width-50, height: UIScreen.main.bounds.height)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CookingLevelCollectionViewCell.self, forCellWithReuseIdentifier: CookingLevelCollectionViewCell.identifier)
        cv.register(PreferencesCollectionViewCell.self, forCellWithReuseIdentifier: PreferencesCollectionViewCell.identifier)
        cv.register(AllergicCollectionViewCell.self, forCellWithReuseIdentifier: AllergicCollectionViewCell.identifier)
        return cv
    }()
    private let cookingLevelButton = CustomMiddleButton(title: "Continue", backgroundColor: "RedPinkMain", textColor: "WhiteBeige")
    private let preferencesButtonStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 32
        return sv
    }()
    private let preferencesButton_1 = CustomSmallButton(title: "Skip", backgroundColor: "PinkBase", textColor: "PinkSubColor")
    private let preferencesButton_2 = CustomSmallButton(title: "Continue", backgroundColor: "RedPinkMain", textColor: "WhiteBeige")
    private let allergicButton = CustomSmallButton(title: "Continue", backgroundColor: "RedPinkMain", textColor: "WhiteBeige")
    private let bottomShadowImageView = BottomShadowImageView()
    override func viewDidLoad() {
        cookingLevelButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        preferencesButton_2.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        allergicButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        super.viewDidLoad()
        customBackButton()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        sliderCollectionView.backgroundColor = .clear
        view.addSubview(sliderCollectionView)
        view.addSubview(bottomShadowImageView)
        view.addSubview(cookingLevelButton)
        view.addSubview(preferencesButtonStackView)
        [
            preferencesButton_1,
            preferencesButton_2
        ].forEach(preferencesButtonStackView.addArrangedSubview)
        view.addSubview(allergicButton)
        preferencesButtonStackView.isHidden = true
        allergicButton.isHidden = true
        sliderCollectionView.dataSource = self
        sliderCollectionView.isScrollEnabled = false
        setupUI()
        bottomShadowImageView.setupConstraints()
    }
    private func setupUI(){
        sliderCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.height.equalTo(UIScreen.main.bounds.height + 50)
        }
        cookingLevelButton.snp.makeConstraints { make in
            make.bottom.equalTo(-48)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        preferencesButtonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(-48)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        allergicButton.snp.makeConstraints { make in
            make.bottom.equalTo(-60.65)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func customBackButton(){
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "back-button"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    @objc
    private func didTapBackButton(){
        let currentIndex = getCurrentIndex()
        let previousIndex = currentIndex - 1
        
        if previousIndex >= 0{
            let indexPath = IndexPath(item: previousIndex, section: 0)
            sliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        if previousIndex == 0 {
            cookingLevelButton.isHidden = false
            allergicButton.isHidden = true
            preferencesButtonStackView.isHidden = true
        }
        if previousIndex == 1 {
            preferencesButtonStackView.isHidden = false
            cookingLevelButton.isHidden = true
            allergicButton.isHidden = true
        }
        if previousIndex == -1 {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    private func nextButtonTapped(){
        let currentIndex = getCurrentIndex()
        let nextIndex = currentIndex + 1
        if nextIndex < 3 {
            let indexPath = IndexPath(item: nextIndex, section: 0)
            sliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        if nextIndex == 1 {
            cookingLevelButton.isHidden = true
            preferencesButtonStackView.isHidden = false
        }
        if nextIndex == 2 {
            preferencesButtonStackView.isHidden = true
            allergicButton.isHidden = false
        }
        if nextIndex == 3 {
            let vc = SignUpViewController()
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
    private func getCurrentIndex() -> Int{
        let visibleRect = CGRect(origin: sliderCollectionView.contentOffset, size: sliderCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = sliderCollectionView.indexPathForItem(at: visiblePoint) else {return 0}
        return indexPath.item
    }
}
extension SliderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CookingLevelCollectionViewCell.identifier, for: indexPath) as! CookingLevelCollectionViewCell
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreferencesCollectionViewCell.identifier, for: indexPath) as! PreferencesCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllergicCollectionViewCell.identifier, for: indexPath) as! AllergicCollectionViewCell
            return cell
        }
    }
}
