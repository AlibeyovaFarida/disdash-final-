//
//  RecentlyAddedTableViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 10.06.24.
//

import UIKit

protocol RecentlyAddedTableViewCellDelegate: AnyObject {
    func recentlyAddedTableViewCell(_ cell: RecentlyAddedTableViewCell, didSelectItem item: RecentlyAddedModel)
}

class RecentlyAddedTableViewCell: UITableViewCell {
    weak var delegate: RecentlyAddedTableViewCellDelegate?
    private var staticHeight = 0
    private var recentlyAddedList: [RecentlyAddedModel] = []
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "RedPinkMain")
        lb.text = "Recently Added"
        return lb
    }()
    
    private let recentlyAddedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 19
        layout.minimumInteritemSpacing = 30
        layout.sectionInset = .init(top: 0, left: 28, bottom: 99, right: 28)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 86) / 2, height: 226)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.register(RecentlyAddedCollectionViewCell.self, forCellWithReuseIdentifier: RecentlyAddedCollectionViewCell.identifier)
        cv.isScrollEnabled = false
        return cv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        selectionStyle = .none
        recentlyAddedCollectionView.dataSource = self
        recentlyAddedCollectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(recentlyAddedCollectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        recentlyAddedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(99)
            make.height.equalTo(226)
        }
    }
    
    func configure(_ item: [RecentlyAddedModel]){
        recentlyAddedList = item
        recentlyAddedCollectionView.reloadData()
        adjustCollectionViewHeight()
    }
    
    private func adjustCollectionViewHeight() {
        let numberOfRows = ceil(Double(recentlyAddedList.count) / 2.0)
        let height = numberOfRows * 226 + (numberOfRows - 1) * 19
        recentlyAddedCollectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}

extension RecentlyAddedTableViewCell: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = recentlyAddedList[indexPath.row]
        delegate?.recentlyAddedTableViewCell(self, didSelectItem: selectedItem)
//        print(selectedItem, "Hello")
    }
}

extension RecentlyAddedTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentlyAddedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyAddedCollectionViewCell.identifier, for: indexPath) as! RecentlyAddedCollectionViewCell
        cell.configure(recentlyAddedList[indexPath.row])
        return cell
    }
}
extension RecentlyAddedTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth - 86) / 2
        return CGSize(width: width, height: 226)
    }
}
