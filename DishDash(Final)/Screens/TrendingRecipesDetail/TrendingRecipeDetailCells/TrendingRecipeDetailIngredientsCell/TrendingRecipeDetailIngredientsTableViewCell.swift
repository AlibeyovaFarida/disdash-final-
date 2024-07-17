//
//  TrendingRecipeDetailIngredientsTableViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 19.06.24.
//

import UIKit

class TrendingRecipeDetailIngredientsTableViewCell: UITableViewCell {
    private var height = 0
    private var ingredientList: [String] = []

    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Ingredients"
        lb.textColor = UIColor(named: "RedPinkMain")
        lb.font = UIFont(name: "Poppins-SemiBold", size: 20)
        return lb
    }()
    private let ingredientsTableView: UITableView = {
        let tv = UITableView()
        tv.isScrollEnabled = false
        tv.register(IngredientItemTableViewCell.self, forCellReuseIdentifier: IngredientItemTableViewCell.identifier)
        return tv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        ingredientsTableView.separatorStyle = .none
        ingredientsTableView.dataSource = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(ingredientsTableView)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28)
        }
        ingredientsTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(28)
            make.bottom.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    func configure(_ items: [String]){
        ingredientList = items
        ingredientsTableView.reloadData()
        adjustCollectionViewHeight()
    }
    
    private func adjustCollectionViewHeight() {
        let numberOfRows = ingredientList.count
        let height = numberOfRows * 28
        ingredientsTableView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}

extension TrendingRecipeDetailIngredientsTableViewCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientItemTableViewCell.identifier, for: indexPath) as! IngredientItemTableViewCell
        cell.configure(ingredientList[indexPath.row])
        return cell
    }
}
