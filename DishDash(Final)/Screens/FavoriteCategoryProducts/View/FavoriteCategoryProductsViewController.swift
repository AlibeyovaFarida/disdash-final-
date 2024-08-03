//
//  FavoriteCategoryProductsViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 02.07.24.
//

import UIKit
import FirebaseAuth
import Firebase

class FavoriteCategoryProductsViewController: UIViewController {
    private var viewModel = FavoriteCategoryProductsViewModel(taste: "")
    private let productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 18
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 74) / 2, height: 226)
        layout.sectionInset = .init(top: 0, left: 28, bottom: 79, right: 28)
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
        navigationItem.title = viewModel.taste
        if let navigationBar = self.navigationController?.navigationBar {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(named: "RedPinkMain")!
            ]
            navigationBar.titleTextAttributes = textAttributes
        }
        view.backgroundColor = UIColor(named: "WhiteBeige")
        productsCollectionView.backgroundColor = .clear
        productsCollectionView.dataSource = self
        productsCollectionView.delegate = self
        setupUI()
        setupBindings()
    }
    init(taste: String) {
        self.viewModel = FavoriteCategoryProductsViewModel(taste: taste)
        super.init(nibName: nil, bundle: nil)
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
    private func setupBindings(){
        viewModel.didUpdateData = { [weak self] in
            DispatchQueue.main.async {
                self?.productsCollectionView.reloadData()
            }
        }
        
        viewModel.didReceiveError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(title: "Server error", message: errorMessage)
            }
        }
    }

    private func setupUI(){
        view.addSubview(productsCollectionView)
        view.addSubview(bottomShadowImageView)
        productsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
    }
}

extension FavoriteCategoryProductsViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TrendingRecipesDetailViewController(productName: viewModel.recipeList[indexPath.row].name)
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension FavoriteCategoryProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recipeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as! RecipeCollectionViewCell
        let recipe = viewModel.recipeList[indexPath.row]
        let isFavorite = viewModel.getFavoriteRecipe(recipeName: recipe.name)
        cell.configure(recipe, isFavorite: isFavorite)
        cell.favoriteButtonTapped = {
            self.viewModel.toggleFavorite(for: recipe)
        }
        return cell
    }
}
