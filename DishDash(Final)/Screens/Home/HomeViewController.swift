//
//  HomeViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 04.06.24.
//

import UIKit
import FirebaseAuth
import Firebase

enum HomeSection{
    case trendingRecipe
    case yourRecipes
    case topChef
    case recentlyAdded
}

struct HomeModel: Hashable {
    let id: String = UUID().uuidString
    let yourRecipes: [YourRecipeModel]
    let topChef: [ChefModel]
    let recentlyAdded: [RecentlyAddedModel]
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

typealias HomeDataSource = UITableViewDiffableDataSource<HomeSection, HomeModel>

class HomeViewController: UIViewController{
    private var recentlyAddedProducts: [RecentlyAddedModel] = []
    private lazy var homeDataSource: HomeDataSource = makeHomeDataSource()
    
    private let categoryList: [CategoryModel] = [
        .init(title: "Breakfast", isSelected: true),
        .init(title: "Lunch", isSelected: false),
        .init(title: "Dinner", isSelected: false),
        .init(title: "Vegan", isSelected: false),
        .init(title: "Dessert", isSelected: false),
        .init(title: "Drinks", isSelected: false),
        .init(title: "Sea Food", isSelected: false)
    ]
    private let headerContainerView: UIView = {
        let view = UIView()
        return view
    }()
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        return sv
    }()
    private let textStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    private let pinkLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Hi! Dianne"
        lb.font = UIFont(name: "Poppins-Regular", size: 25.3)
        lb.textColor = UIColor(named: "RedPinkMain")
        return lb
    }()
    private let brownLabel: UILabel = {
        let lb = UILabel()
        lb.text = "What are you cooking today"
        lb.font = UIFont(name: "Poppins-Regular", size: 13.5)
        lb.textColor = UIColor(named: "TextColorBrown")
        return lb
    }()
    private let buttonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        return sv
    }()
    private let notificationsButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "notification-button"), for: .normal)
        btn.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        return btn
    }()
    @objc
    private func notificationButtonTapped(){
        let vc = NotificationsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    private let searchButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "search-button"), for: .normal)
        btn.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        return btn
    }()
    @objc
    private func didTapSearchButton(){
        let searchVC = SearchViewController()
        searchVC.modalPresentationStyle = .overFullScreen
        present(searchVC, animated: false, completion: nil)
    }
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .init(width: 81, height: 15)
        layout.minimumLineSpacing = 11
        layout.sectionInset = .init(top: 7, left: 28, bottom: 7, right: 28)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        return cv
    }()
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.register(TrendingRecipeTableViewCell.self, forCellReuseIdentifier: TrendingRecipeTableViewCell.identifier)
        tv.register(YourRecipesTableViewCell.self, forCellReuseIdentifier: YourRecipesTableViewCell.identifier)
        tv.register(TopChefTableViewCell.self, forCellReuseIdentifier: TopChefTableViewCell.identifier)
        tv.register(RecentlyAddedTableViewCell.self, forCellReuseIdentifier: RecentlyAddedTableViewCell.identifier)
        return tv
    }()
    
    private let bottomShadowImageView = BottomShadowImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        db.collection("recipes").order(by: "date", descending: true).limit(to: 6).getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(title: "Server error", message: error.localizedDescription)
            } else {
                for document in querySnapshot!.documents{
                    self.recentlyAddedProducts.append(RecentlyAddedModel(
                        image: document.data()["image"] as! String,
                        name: document.data()["name"] as! String,
                        description: document.data()["description"] as! String,
                        rating: document.data()["rating"] as! Int,
                        time: document.data()["cookingTime"] as! String))
                }
                DispatchQueue.main.async {
                    self.applySnapshot()
                }
            }
        }
        
        view.backgroundColor = UIColor(named: "WhiteBeige")
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        categoryCollectionView.backgroundColor = .clear
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        setupUI()
        tableView.delegate = self
        tableView.dataSource = homeDataSource
        applySnapshot()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    private func setupUI(){
        view.addSubview(headerContainerView)
        view.addSubview(categoryCollectionView)
        headerContainerView.addSubview(stackView)
        [
            textStackView,
            buttonsStackView
        ].forEach(stackView.addArrangedSubview)
        [
            pinkLabel,
            brownLabel
        ].forEach(textStackView.addArrangedSubview)
        [
            notificationsButton,
            searchButton
        ].forEach(buttonsStackView.addArrangedSubview)
        view.addSubview(tableView)
        view.addSubview(bottomShadowImageView)
        headerContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(19)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerContainerView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(39)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(19)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    private func makeHomeDataSource() -> HomeDataSource {
        return HomeDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TrendingRecipeTableViewCell.identifier) as! TrendingRecipeTableViewCell
                return cell
            }
            if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: YourRecipesTableViewCell.identifier) as! YourRecipesTableViewCell
                cell.configure(itemIdentifier.yourRecipes)
                return cell
            }
            if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TopChefTableViewCell.identifier) as! TopChefTableViewCell
                cell.configure(itemIdentifier.topChef)
                return cell
            }
            if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: RecentlyAddedTableViewCell.identifier) as! RecentlyAddedTableViewCell
                cell.configure(itemIdentifier.recentlyAdded)
                return cell
            }
            return UITableViewCell()
        }
    }
    private func applySnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeModel>()
        snapshot.appendSections([.trendingRecipe, .yourRecipes, .topChef, .recentlyAdded])
        snapshot.appendItems([.init(yourRecipes: [], topChef: [], recentlyAdded: [])], toSection: .trendingRecipe)
        snapshot.appendItems([.init(yourRecipes: [
            .init(image: "chicken-burger", title: "Chicken Burger", rating: 5, time: 15),
            .init(image: "tiramisu", title: "Tiramisu", rating: 5, time: 15),
            .init(image: "chicken-burger", title: "Chicken Burger", rating: 5, time: 15),
            .init(image: "tiramisu", title: "Tiramisu", rating: 5, time: 15),
        ], topChef: [], recentlyAdded: [])], toSection: .yourRecipes)
        snapshot.appendItems([.init(yourRecipes: [], topChef: [
            .init(image: "joseph", name: "Joseph"),
            .init(image: "andrew", name: "Andrew"),
            .init(image: "emily", name: "Emily"),
            .init(image: "jessica", name: "Jessica")], recentlyAdded: [])], toSection: .topChef)
        snapshot.appendItems([.init(yourRecipes: [], topChef: [], recentlyAdded: recentlyAddedProducts)], toSection: .recentlyAdded)
        homeDataSource.apply(snapshot, animatingDifferences: true)
    }
}
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.configure(categoryList[indexPath.row])
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CategoryProductsViewController(categoryName: categoryList[indexPath.row].title)
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = TrendingRecipesViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 1 {
            let vc = YourRecipesViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            let vc = TopChefViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension HomeViewController: RecentlyAddedTableViewCellDelegate {
    func recentlyAddedTableViewCell(_ cell: RecentlyAddedTableViewCell, didSelectItem item: RecentlyAddedModel) {
        let vc = TrendingRecipesDetailViewController(productName: item.name)
        navigationController?.pushViewController(vc, animated: true)
    }
}
