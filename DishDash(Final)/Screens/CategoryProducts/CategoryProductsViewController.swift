//
//  CategoryProductsViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 30.06.24.
//

import UIKit
import Firebase

class CategoryProductsViewController: UIViewController {
    private var categoryName: String = ""
    private var categoryNameList: [CategoryNameItemModel] = [
        .init(name: "Breakfast", isSelected: false),
        .init(name: "Lunch", isSelected: false),
        .init(name: "Dinner", isSelected: false),
        .init(name: "Vegan", isSelected: false),
        .init(name: "Dessert", isSelected: false),
        .init(name: "Drinks", isSelected: false),
        .init(name: "Sea Food", isSelected: false)
    ]
    private var categoryProductsList: [RecipeModel] = []
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
        super.init(nibName: nil, bundle: nil)
        self.categoryName = categoryName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupCustomBackButton()
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        db.collection("recipes").whereField("category", isEqualTo: categoryName).getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                for document in querySnapshot!.documents{
                    self.categoryProductsList.append(RecipeModel(
                        name: document.data()["name"] as! String,
                        image: document.data()["image"] as! String,
                        description: document.data()["description"] as! String,
                        rating: document.data()["rating"] as! Int,
                        cookingTime: document.data()["cookingTime"] as! String))
                }
                DispatchQueue.main.async {
                    self.categoryProductsCollectionView.reloadData()
                }
            }
        }
        
        
        
        view.backgroundColor = UIColor(named: "WhiteBeige")
        categoryListCollectionView.backgroundColor = .clear
        categoryProductsCollectionView.backgroundColor = .clear
        categoryListCollectionView.dataSource = self
        categoryListCollectionView.delegate = self
        categoryProductsCollectionView.dataSource = self
        categoryProductsCollectionView.delegate = self
        navigationItem.title = categoryName
        if let navigationBar = self.navigationController?.navigationBar {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(named: "RedPinkMain")!
            ]
            navigationBar.titleTextAttributes = textAttributes
        }
        setupUI()
        navigationController?.setNavigationBarHidden(false, animated: false)
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
        view.addSubview(categoryListCollectionView)
        view.addSubview(categoryProductsCollectionView)
        view.addSubview(bottomShadowImageView)
        
        categoryListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(39)
        }
        
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
extension CategoryProductsViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryListCollectionView {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        if collectionView == categoryProductsCollectionView {
            let vc = TrendingRecipesDetailViewController(productName: categoryProductsList[indexPath.row].name)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
extension CategoryProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryListCollectionView {
            return categoryNameList.count
        }
        if collectionView == categoryProductsCollectionView {
            return categoryProductsList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryListCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryNameCollectionViewCell.identifier, for: indexPath) as! CategoryNameCollectionViewCell
            let item = categoryNameList[indexPath.row]
            cell.configure(categoryNameList[indexPath.row])
            cell.isSelected = item.name == categoryName
            return cell
        }
        if collectionView == categoryProductsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as! RecipeCollectionViewCell
            cell.configure(categoryProductsList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}
