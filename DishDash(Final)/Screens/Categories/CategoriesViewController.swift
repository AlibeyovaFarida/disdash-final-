//
//  CategoriesViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 14.06.24.
//

import UIKit
import Firebase

class CategoriesViewController: UIViewController {
    private var categoriesList: [CategoryItemModel] = []
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    private let contentViewInScroll: UIView = {
        let view = UIView()
        return view
    }()
    private let seafoodCategoryStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 3
        return sv
    }()
    private let seafoodLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Poppins-Medium", size: 14)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.textAlignment = .center
        return lb
    }()
    private let seafoodImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 13
        iv.isUserInteractionEnabled = true
        return iv
    }()
    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 28
        layout.sectionInset = .init(top: 0, left: 28, bottom: 0, right: 28)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: (screenWidth - 88)/2, height: 171)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        cv.isScrollEnabled = false
        return cv
    }()
    private let bottomShadowImageView = BottomShadowImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectSeafoodCategory))
        seafoodImageView.addGestureRecognizer(tapGesture)
        let db = Firestore.firestore()
        db.collection("categories").whereField("name", isEqualTo: "Seafood").getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(title: "Server error", message: error.localizedDescription)
            } else {
                for document in querySnapshot!.documents{
                    self.seafoodLabel.text = (document.data()["name"] as! String)
                    self.seafoodImageView.kf.setImage(with: URL(string: document.data()["image"] as! String))
                }
            }
        }
        db.collection("categories").whereField("name", isNotEqualTo: "Seafood").getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(title: "Server error", message: error.localizedDescription)
            } else {
                for document in querySnapshot!.documents{
                    self.categoriesList.append(CategoryItemModel(image: document.data()["image"] as! String, name: document.data()["name"] as! String))
                }
                DispatchQueue.main.async {
                    self.categoriesCollectionView.reloadData()
                }
            }
        }
        
        navigationItem.title = "Categories"
        if let navigationBar = self.navigationController?.navigationBar {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(named: "RedPinkMain")!
            ]
            navigationBar.titleTextAttributes = textAttributes
        }
        view.backgroundColor = UIColor(named: "WhiteBeige")
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        setupUI()
    }
    @objc
    private func didSelectSeafoodCategory(){
        let vc = CategoryProductsViewController(categoryName: "Sea Food")
        navigationController?.pushViewController(vc, animated: true)
    }
    private func setupUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentViewInScroll)
        view.addSubview(bottomShadowImageView)
        [
            seafoodCategoryStackView,
            categoriesCollectionView
        ].forEach(contentViewInScroll.addSubview)
        [
            seafoodLabel,
            seafoodImageView
        ].forEach(seafoodCategoryStackView.addArrangedSubview)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentViewInScroll.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        seafoodCategoryStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        categoriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(seafoodCategoryStackView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(531)
        }
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
extension CategoriesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as! CategoriesCollectionViewCell
        cell.configure(categoriesList[indexPath.row])
        return cell
    }
}
extension CategoriesViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CategoryProductsViewController(categoryName: categoriesList[indexPath.row].name)
        navigationController?.pushViewController(vc, animated: true)
    }
}
