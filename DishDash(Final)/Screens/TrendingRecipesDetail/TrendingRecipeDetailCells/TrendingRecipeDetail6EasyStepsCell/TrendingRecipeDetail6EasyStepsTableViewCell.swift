//
//  TrendingRecipeDetail6EasyStepsTableViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 19.06.24.
//

import UIKit

class TrendingRecipeDetail6EasyStepsTableViewCell: UITableViewCell {
    private let height = 0
    private var stepsList: [EasyStep] = []
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "6 easy Steps"
        lb.font = UIFont(name: "Poppins-SemiBold", size: 20)
        lb.textColor = UIColor(named: "RedPinkMain")
        return lb
    }()
    private let stepsTableView: UITableView = {
        let tv = UITableView()
        tv.isScrollEnabled = false
        tv.register(EasyStepTableViewCell.self, forCellReuseIdentifier: EasyStepTableViewCell.identifier)
        return tv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        stepsTableView.dataSource = self
        stepsTableView.separatorStyle = .none
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(stepsTableView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28)
        }
        stepsTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(90)
            make.height.equalTo(552)
        }
    }
    func configure(_ item: [EasyStep]){
        stepsList = item
        stepsTableView.reloadData()
        adjustCollectionViewHeight()
    }
    
    private func adjustCollectionViewHeight() {
        let numberOfRows = stepsList.count
        let height = numberOfRows * 92
        stepsTableView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}

extension TrendingRecipeDetail6EasyStepsTableViewCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EasyStepTableViewCell.identifier, for: indexPath) as! EasyStepTableViewCell
        cell.configure(stepsList[indexPath.row])
        return cell
    }
}
