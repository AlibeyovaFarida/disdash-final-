//
//  PreferencesCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 28.05.24.
//

import UIKit

class PreferencesCollectionViewCell: UICollectionViewCell {
    private let viewModel = PreferencesCellViewModel()
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        return sv
    }()
    
    private let preferencesTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Select your cuisines preferences"
        lb.font = UIFont(name: "Poppins-SemiBold", size: 20)
        return lb
    }()
    
    private let preferencesDescLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Please select your cuisines preferences for a better recommendations or you can skip it."
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Poppins-Regular", size: 13)
        return lb
    }()
    
    private let preferencesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 9
        layout.minimumInteritemSpacing = 9
        layout.itemSize = .init(width: 96, height: 124)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        cv.register(PreferencesMealCollectionViewCell.self, forCellWithReuseIdentifier: PreferencesMealCollectionViewCell.identifier)
        return cv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        preferencesCollectionView.dataSource = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(stackView)
        [
            preferencesTitleLabel,
            preferencesDescLabel,
            preferencesCollectionView
        ].forEach(stackView.addArrangedSubview)
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
extension PreferencesCollectionViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.preferencesMealList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreferencesMealCollectionViewCell.identifier, for: indexPath) as! PreferencesMealCollectionViewCell
        cell.configure(viewModel.preferencesMealList[indexPath.row])
        return cell
    }
}
