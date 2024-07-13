import UIKit

class YourRecipesTableViewCell: UITableViewCell {

    private var receipeList: [YourRecipeModel] = []
    
    private let pinkBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "RedPinkMain")
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Your recipes"
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "WhiteBeige")
        return lb
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 28
        layout.sectionInset = .init(top: 0, left: 28, bottom: 0, right: 28)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 84) / 2 , height: 195)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(YourRecipeCollectionViewCell.self, forCellWithReuseIdentifier: YourRecipeCollectionViewCell.identifier)
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        selectionStyle = .none
        collectionView.backgroundColor = UIColor(named: "RedPinkMain")
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(pinkBackgroundView)
        pinkBackgroundView.addSubview(titleLabel)
        pinkBackgroundView.addSubview(collectionView)
        
        pinkBackgroundView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(19)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(255)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(195)
        }
    }
}

extension YourRecipesTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receipeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YourRecipeCollectionViewCell.identifier, for: indexPath) as! YourRecipeCollectionViewCell
        cell.configure(receipeList[indexPath.row])
        return cell
    }
    
    func configure(_ item: [YourRecipeModel]) {
        receipeList = item
        collectionView.reloadData()
    }
}
