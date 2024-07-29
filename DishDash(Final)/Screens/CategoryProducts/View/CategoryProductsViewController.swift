import UIKit
import Firebase
import FirebaseAuth

class CategoryProductsViewController: UIViewController {

    private var viewModel: CategoryProductsViewModel
    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    private let categoryListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = .init(width: 81, height: 25)
        layout.sectionInset = .init(top: 7, left: 28, bottom: 7, right: 28)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryNameCollectionViewCell.self, forCellWithReuseIdentifier: CategoryNameCollectionViewCell.identifier)
        return cv
    }()
    private let categoryProductsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 19
        layout.sectionInset = .init(top: 0, left: 28, bottom: 79, right: 28)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 75) / 2, height: 226)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        return cv
    }()
    private let bottomShadowImageView = BottomShadowImageView()
    
    init(categoryName: String){
        self.viewModel = CategoryProductsViewModel(categoryName: categoryName)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        viewModel.fetchRecipes()
        viewModel.fetchFavorites()
        setupCustomBackButton()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        categoryListCollectionView.backgroundColor = .clear
        categoryProductsCollectionView.backgroundColor = .clear
        categoryListCollectionView.dataSource = self
        categoryListCollectionView.delegate = self
        categoryProductsCollectionView.dataSource = self
        categoryProductsCollectionView.delegate = self
        navigationItem.title = viewModel.categoryNameList.first(where: {$0.isSelected})?.name
        if let navigationBar = self.navigationController?.navigationBar {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(named: "RedPinkMain")!
            ]
            navigationBar.titleTextAttributes = textAttributes
        }
        setupUI()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupBinding(){
        viewModel.didUpdateData = { [weak self] in
            DispatchQueue.main.async {
                self?.categoryProductsCollectionView.reloadData()
                self?.categoryListCollectionView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.didReceiveError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(title: "Server error", message: error)
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func setupCustomBackButton() {
        guard let backButtonImage = UIImage(named: "back-button") else {
                print("Error: Back button image not found.")
                return
            }
            
        let backButton = UIButton(type: .custom)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
            
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
            
        backButton.snp.makeConstraints { make in
            make.width.equalTo(22.4)
            make.height.equalTo(14)
        }
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    private func setupUI() {
        view.addSubview(activityIndicator)
        view.addSubview(categoryListCollectionView)
        view.addSubview(categoryProductsCollectionView)
        view.addSubview(bottomShadowImageView)
        
        categoryListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(39)
        }
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        categoryProductsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryListCollectionView.snp.bottom).offset(19)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}

extension CategoryProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryListCollectionView {
            let selectedCategory = viewModel.categoryNameList[indexPath.row]
            viewModel.selectCategory(selectedCategory)
            navigationItem.title = selectedCategory.name
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        if collectionView == categoryProductsCollectionView {
            let vc = TrendingRecipesDetailViewController(productName: viewModel.categoryProductsList[indexPath.row].name)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension CategoryProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryListCollectionView {
            return viewModel.categoryNameList.count
        }
        if collectionView == categoryProductsCollectionView {
            return viewModel.categoryProductsList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryListCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryNameCollectionViewCell.identifier, for: indexPath) as! CategoryNameCollectionViewCell
            let item = viewModel.categoryNameList[indexPath.row]
            cell.configure(item)
            cell.isSelected = item.name == viewModel.categoryNameList.first(where: {$0.isSelected})?.name
            return cell
        }
        if collectionView == categoryProductsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as! RecipeCollectionViewCell
            let recipe = viewModel.categoryProductsList[indexPath.row]
            let isFavorite = viewModel.favoriteRecipes.contains(recipe.name)
            cell.configure(recipe, isFavorite: isFavorite)
            cell.favoriteButtonTapped = {
                self.viewModel.toggleFavorite(for: recipe)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
