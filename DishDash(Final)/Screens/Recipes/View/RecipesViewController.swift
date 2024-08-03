//
//  RecipesViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 24.06.24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class RecipesViewController: UIViewController {
    private var viewModel: RecipesViewModel
    private let recipesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 19
        layout.sectionInset = .init(top: 0, left: 28, bottom: 70, right: 28)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 75) / 2, height: 226)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        return cv
    }()
    
    private let bottomShadowImageView = BottomShadowImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchRecipes()
        viewModel.fetchFavorites()
        setupCustomBackButton()
        navigationItem.title = viewModel.categoryName
        if let navigationBar = self.navigationController?.navigationBar {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(named: "RedPinkMain")!
            ]
            navigationBar.titleTextAttributes = textAttributes
        }
        view.backgroundColor = UIColor(named: "WhiteBeige")
        recipesCollectionView.backgroundColor = .clear
        recipesCollectionView.dataSource = self
        recipesCollectionView.delegate = self
        setupUI()
        setupBindings()
    }

    private func setupBindings(){
        self.viewModel.didUpdateData = {[weak self] in
            DispatchQueue.main.async {
                self?.recipesCollectionView.reloadData()
            }
        }
        self.viewModel.errorOccured = {[weak self] errorMessage in
            self?.showAlert(title: "Server error", message: errorMessage)
        }
    }
    init(categoryName: String, chefUsername: String) {
        self.viewModel = RecipesViewModel(categoryName: categoryName, chefUsername: chefUsername)
        super.init(nibName: nil, bundle: nil)
//        self.chefUsername = chefUsername
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    private func setupUI(){
        view.addSubview(recipesCollectionView)
        view.addSubview(bottomShadowImageView)
        
        recipesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(34.5)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}
extension RecipesViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TrendingRecipesDetailViewController(productName: viewModel.recipeList[indexPath.row].name)
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension RecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getRecipeListCount()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as! RecipeCollectionViewCell
        var recipe = self.viewModel.recipeList[indexPath.row]
        let isFavorite = self.viewModel.getIsFavorite(at: indexPath.row)
        cell.configure(recipe, isFavorite: isFavorite)
        cell.favoriteButtonTapped = {
            self.viewModel.toggleFavorite(for: recipe)
        }

        return cell
    }
    
}

