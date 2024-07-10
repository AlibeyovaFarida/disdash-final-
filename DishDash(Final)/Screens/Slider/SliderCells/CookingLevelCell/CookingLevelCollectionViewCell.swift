//
//  CookingLevelCollectionViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 28.05.24.
//

import UIKit

class CookingLevelCollectionViewCell: UICollectionViewCell {
    private let cookingLevelList: [CookingLevelItemModel] = [
        .init(levelTitle: "Novice", levelDesc: "Lorem ipsum dolor sit amet consectetur. Auctor pretium cras id dui pellentesque ornare. Quisque malesuada netus pulvinar diam.", isSelected: false),
        .init(levelTitle: "Intermediate", levelDesc: "Lorem ipsum dolor sit amet consectetur. Auctor pretium cras id dui pellentesque ornare. Quisque pulvinar diam.", isSelected: false),
        .init(levelTitle: "Advanced", levelDesc: "Lorem ipsum dolor sit amet pretium cras id dui pellentesque ornare. Quisque malesuada netus pulvinar diam.", isSelected: true),
        .init(levelTitle: "Professional", levelDesc: "Lorem ipsum dolor sit amet consectetur. Auctor pretium cras id dui pellentesque ornare. Quisque malesuada.", isSelected: false)
    ]
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        return sv
    }()
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "¿What is your cooking level?"
        lb.font = UIFont(name: "Poppins-SemiBold", size: 20)
        return lb
    }()
    private let descLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Please select you cooking level for a better recommendations."
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Poppins-Regular", size: 13)
        return lb
    }()
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(CookingLevelTableViewCell.self, forCellReuseIdentifier: CookingLevelTableViewCell.identifier)
        return tv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "WhiteBeige")
        tableView.separatorStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(stackView)
        tableView.isScrollEnabled = false
        [
            titleLabel,
            descLabel,
            tableView
        ].forEach(stackView.addArrangedSubview)
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension CookingLevelCollectionViewCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cookingLevelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CookingLevelTableViewCell.identifier, for: indexPath) as! CookingLevelTableViewCell
        cell.configure(cookingLevelList[indexPath.row])
        return cell
    }
}
