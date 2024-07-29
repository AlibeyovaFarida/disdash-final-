import UIKit
import Firebase
import FirebaseAuth

class CommunityViewController: UIViewController {
    private var viewModel = CommunityViewModel()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    private let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.sectionInset = .init(top: 0, left: 28, bottom: 0, right: 28)
        layout.itemSize = .init(width: 119, height: 25)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        return cv
    }()
    
    private let communityCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 19
        layout.sectionInset = .init(top: 0, left: 28, bottom: 0, right: 28)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 56), height: 320)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.register(CommunityCardCollectionViewCell.self, forCellWithReuseIdentifier: CommunityCardCollectionViewCell.identifier)
        return cv
    }()
    private let bottomShadowImageView = BottomShadowImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchDataBasedOnFilter()
        viewModel.fetchFavorites()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        navigationItem.title = "Community"
        if let navigationBar = self.navigationController?.navigationBar {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(named: "RedPinkMain")!
            ]
            navigationBar.titleTextAttributes = textAttributes
        }
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        communityCollectionView.dataSource = self
        communityCollectionView.delegate = self
        setupUI()
        setupBindings()
        viewModel.fetchDataBasedOnFilter()
        viewModel.fetchFavorites()
    }
    
    private func setupUI() {
        view.addSubview(activityIndicator)
        view.addSubview(filterCollectionView)
        view.addSubview(communityCollectionView)
        view.addSubview(bottomShadowImageView)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(36)
        }
        communityCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterCollectionView.snp.bottom).offset(22)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupBindings(){
        viewModel.didUpdateData = { [weak self] in
            DispatchQueue.main.async {
                self?.communityCollectionView.reloadData()
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
    
    private func showLoading(_ show: Bool){
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

extension CommunityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return viewModel.getFilters().count
        }
        if collectionView == communityCollectionView {
            return  viewModel.getCommunityCardList().count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as! FilterCollectionViewCell
            cell.configure(viewModel.getFilters()[indexPath.row])
            return cell
        }
        if collectionView == communityCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityCardCollectionViewCell.identifier, for: indexPath) as! CommunityCardCollectionViewCell
            let recipe = viewModel.getCommunityCardList()[indexPath.row]
            let isFavorite = viewModel.isFavorite(recipeName: recipe.recipeName)
            cell.configure(recipe, isFavorite)
            cell.favoriteButtonTapped = {
                self.viewModel.toggleFavorite(for: recipe)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension CommunityViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            viewModel.selectFilter(at: indexPath.row)
            filterCollectionView.reloadData()
            self.viewModel.fetchDataBasedOnFilter()
        }
        if collectionView == communityCollectionView {
            let vc = TrendingRecipesDetailViewController(productName: viewModel.getCommunityCardList()[indexPath.row].recipeName)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
