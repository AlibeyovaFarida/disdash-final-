import UIKit
import Firebase
import FirebaseAuth

class CommunityViewController: UIViewController {

    private var communityCardList: [CommunityCardModel] = []
    private var favoriteRecipes: Set<String> = []
    private let userId = Auth.auth().currentUser?.uid
    private var filterList: [FilterChoiseModel] = [
        .init(name: "Top Recipes", isSelected: true),
        .init(name: "Newest", isSelected: false),
        .init(name: "Oldest", isSelected: false)
    ]
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
        fetchDataBasedOnFilter()
        fetchFavorites()
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
        fetchDataBasedOnFilter()
        fetchFavorites()
    }
    
    private func setupUI() {
        view.addSubview(filterCollectionView)
        view.addSubview(communityCollectionView)
        view.addSubview(bottomShadowImageView)
        
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
    
    private func fetchDataBasedOnFilter() {
        let db = Firestore.firestore()
        communityCardList.removeAll()
        communityCollectionView.reloadData()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        for filterOption in filterList {
            if filterOption.isSelected {
                let query: Query
                if filterOption.name == "Newest" {
                    query = db.collection("recipes").order(by: "date", descending: true)
                } else if filterOption.name == "Oldest" {
                    query = db.collection("recipes").order(by: "date", descending: false)
                } else {
                    query = db.collection("recipes").order(by: "rating", descending: true)
                }
                
                query.getDocuments { querySnapshot, error in
                    if let error = error {
                        self.showAlert(title: "Server error", message: error.localizedDescription)
                    } else {
                        for document in querySnapshot!.documents {
                            let chef = document.data()["chef"] as! [String : String]
                            self.communityCardList.append(CommunityCardModel(
                                authorImage: chef["image"]!,
                                username: chef["username"]!,
                                time: document.data()["date"] as? Date ?? Date(),
                                recipeImage: document.data()["image"] as! String,
                                recipeName: document.data()["name"] as! String,
                                rating: document.data()["rating"] as! Int,
                                description: document.data()["details"] as! String,
                                cookingTime: document.data()["cookingTime"] as! String,
                                comment: 0,
                                taste: document.data()["taste"] as! String
                            ))
                        }
                        self.communityCollectionView.reloadData()
                    }
                }
                break
            }
        }
    }
    private func fetchFavorites() {
        let db = Firestore.firestore()
        db.collection("users").document(userId ?? "").collection("favorites").getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(title: "Server error", message: error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    self.favoriteRecipes.insert(document.documentID)
                }
                DispatchQueue.main.async {
                    self.communityCollectionView.reloadData()
                }
            }
        }
    }
    private func toggleFavorite(for recipe: CommunityCardModel) {
        let db = Firestore.firestore()
        let recipeDocRef = db.collection("users").document(userId ?? "").collection("favorites").document(recipe.recipeName)
        
        if favoriteRecipes.contains(recipe.recipeName) {
            recipeDocRef.delete { error in
                if let error = error {
                    self.showAlert(title: "Server error", message: error.localizedDescription)
                } else {
                    self.favoriteRecipes.remove(recipe.recipeName)
                    self.communityCollectionView.reloadData()
                }
            }
        } else {
            recipeDocRef.setData([
                "name": recipe.recipeName,
                "image": recipe.recipeImage,
                "description": recipe.description,
                "rating": recipe.rating,
                "cookingTime": recipe.cookingTime,
                "taste": recipe.taste
            ]) { error in
                if let error = error {
                    self.showAlert(title: "Server error", message: error.localizedDescription)
                } else {
                    self.favoriteRecipes.insert(recipe.recipeName)
                    self.communityCollectionView.reloadData()
                }
            }
        }
    }
}

extension CommunityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return filterList.count
        }
        if collectionView == communityCollectionView {
            return communityCardList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as! FilterCollectionViewCell
            cell.configure(filterList[indexPath.row])
            return cell
        }
        if collectionView == communityCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityCardCollectionViewCell.identifier, for: indexPath) as! CommunityCardCollectionViewCell
            var recipe = communityCardList[indexPath.row]
            let isFavorite = favoriteRecipes.contains(recipe.recipeName)
            cell.configure(recipe, isFavorite)
            cell.favoriteButtonTapped = {
                self.toggleFavorite(for: recipe)
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
            for (index, _) in filterList.enumerated() {
                filterList[index].isSelected = (index == indexPath.row)
            }
            filterCollectionView.reloadData()
            fetchDataBasedOnFilter()
        }
        if collectionView == communityCollectionView {
            let vc = TrendingRecipesDetailViewController(productName: communityCardList[indexPath.row].recipeName)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
