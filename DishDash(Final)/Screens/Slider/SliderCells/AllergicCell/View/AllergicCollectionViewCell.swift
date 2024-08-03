import UIKit

class AllergicCollectionViewCell: UICollectionViewCell {
    private let viewModel = AllergicCellViewModel()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentViewInScroll: UIView = {
        let view = UIView()
        return view
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 33
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let allergicTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "¿You have any allergic?"
        lb.font = UIFont(name: "Poppins-SemiBold", size: 20)
        return lb
    }()
    
    private let allergicDescLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Lorem ipsum dolor sit amet consectetur. Leo ornare ullamcorper viverra ultrices in."
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Poppins-Regular", size: 13)
        return lb
    }()
    
    private let allergicCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 19
        layout.itemSize = .init(width: 100, height: 142)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        cv.showsVerticalScrollIndicator = false
        cv.register(AllergicMealCollectionViewCell.self, forCellWithReuseIdentifier: AllergicMealCollectionViewCell.identifier)
        return cv
    }()
    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        allergicCollectionView.dataSource = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(contentViewInScroll)
        
        contentViewInScroll.addSubview(stackView)
        [
            allergicTitleLabel,
            allergicDescLabel,
            allergicCollectionView,
            emptyView
        ].forEach(stackView.addArrangedSubview)
        
        // Constraints for scrollView
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Constraints for contentViewInScroll
        contentViewInScroll.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview() 
        }
        
        // Constraints for stackView
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Constraints for collectionView
        allergicCollectionView.snp.makeConstraints { make in
            make.height.equalTo(viewModel.allergicMealList.count / 3 * 150) // Adjust this as needed
        }
        emptyView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
    }
}

extension AllergicCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allergicMealList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllergicMealCollectionViewCell.identifier, for: indexPath) as! AllergicMealCollectionViewCell
        cell.configure(viewModel.allergicMealList[indexPath.row])
        return cell
    }
}
