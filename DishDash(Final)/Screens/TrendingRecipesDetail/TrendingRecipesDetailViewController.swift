//
//  TrendingRecipesDetailViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 18.06.24.
//

import UIKit
import Firebase
import Kingfisher

enum TrendingRecipeDetailSections {
    case recipeAuthor
    case details
    case ingredients
    case easySteps
}

struct TrendingRecipeDetailModel: Hashable{
    let id: String = UUID().uuidString
    let ingredients: [String]
    let easySteps: [EasyStep]
    let recipeAuthor: RecipeAuthorModel?
    let details: RecipeDetailCellModel?
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

typealias TrendingRecipeDetailDataSource = UITableViewDiffableDataSource<TrendingRecipeDetailSections, TrendingRecipeDetailModel>

class TrendingRecipesDetailViewController: UIViewController {
    private var author: RecipeAuthorModel?
    private var detailsCell: RecipeDetailCellModel?
    private var ingredientsList: [String] = []
    private var stepsList: [EasyStep] = []
    private var productName: String = ""
    private lazy var trendingRecipeDetailDataSource: TrendingRecipeDetailDataSource = makeTrendingRecipeDetailDataSource()
    private let trendingRecipeVideoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "RedPinkMain")
        view.layer.cornerRadius = 10
        return view
    }()
    private let trendingRecipeTumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "tumbnail-pizza")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    private let trendingRecipeVideoDetailsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        return sv
    }()
    private let trendingRecipeVideoTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Salami and cheese pizza"
        lb.font = UIFont(name: "Poppins-Medium", size: 18)
        lb.textColor = UIColor(named: "WhiteBeige")
        return lb
    }()
    private let trendingRecipeVideoRatingCommentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10
        return sv
    }()
    private let ratingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.alignment = .center
        return sv
    }()
    private let ratingImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "white-star")
        return iv
    }()
    private let ratingLabel: UILabel = {
        let lb = UILabel()
        lb.text = "5"
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "BrownLetters")
        return lb
    }()
    private let commentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.alignment = .center
        return sv
    }()
    private let commentImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "comment")
        return iv
    }()
    private let commentLabel: UILabel = {
        let lb = UILabel()
        lb.text = "28"
        lb.font = UIFont(name: "Poppins-Regular", size: 12)
        lb.textColor = UIColor(named: "BrownLetters")
        return lb
    }()
    private let trendingRecipeDetailTableView: UITableView = {
        let tv = UITableView()
        tv.register(TrendingRecipeDetailAuthorTableViewCell.self, forCellReuseIdentifier: TrendingRecipeDetailAuthorTableViewCell.identifier)
        tv.register(TrendingRecipeDetailDetailsTableViewCell.self, forCellReuseIdentifier: TrendingRecipeDetailDetailsTableViewCell.identifier)
        tv.register(TrendingRecipeDetailIngredientsTableViewCell.self, forCellReuseIdentifier: TrendingRecipeDetailIngredientsTableViewCell.identifier)
        tv.register(TrendingRecipeDetail6EasyStepsTableViewCell.self, forCellReuseIdentifier: TrendingRecipeDetail6EasyStepsTableViewCell.identifier)
        return tv
    }()
    private let bottomShadowImageView = BottomShadowImageView()
    override func viewDidLoad() {
        setupCustomBackButton()
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        db.collection("recipes").whereField("name", isEqualTo: productName).getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(title: "Server error", message: error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    self.trendingRecipeTumbnailImageView.kf.setImage(with: URL(string: document.data()["image"] as! String))
                    self.trendingRecipeVideoTitleLabel.text = document.data()["name"] as? String
                    self.ratingLabel.text = "\(document.data()["rating"] as! Int)"
                    self.ingredientsList = document.data()["ingredients"] as! [String]
                    self.detailsCell = .init(cookingTime: document.data()["cookingTime"] as! String, details: document.data()["details"] as! String)
                    if let chef = document.data()["chef"] as? [String:String]{
                        if let username = chef["username"], let name = chef["name"], let surname = chef["surname"], let image = chef["image"]{
                            self.author = .init(username: username, name: name, surname: surname, image: image)
                        } else {
                            print("Server error")
                        }
                    } else {
                        print("Server error")
                    }
                    
                    if let stepsData = document.data()["steps"] as? [String] {
                        for (index, step) in stepsData.enumerated() {
                            // Alternate background colors based on index
                            let bgColor: String
                            if index % 2 == 0 {
                                bgColor = "PinkSubColor"
                            } else {
                                bgColor = "PinkBase"
                            }

                            self.stepsList.append(.init(step: step, bgColor: bgColor))
                        }
                    } else {
                        print("Error: `steps` field is missing or not an array of strings")
                    }
                }
                DispatchQueue.main.async {
                    self.applySnapshot()
                }
            }
        }
        navigationItem.title = productName
        if let navigationBar = self.navigationController?.navigationBar {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(named: "RedPinkMain")!
            ]
            navigationBar.titleTextAttributes = textAttributes
        }
        view.backgroundColor = UIColor(named: "WhiteBeige")
        trendingRecipeDetailTableView.separatorStyle = .none
        setupUI()
        trendingRecipeDetailTableView.dataSource = trendingRecipeDetailDataSource
        DispatchQueue.main.async {
            self.applySnapshot()
        }
    }
    init(productName: String){
        super.init(nibName: nil, bundle: nil)
        self.productName = productName
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
        view.addSubview(trendingRecipeVideoView)
        view.addSubview(trendingRecipeDetailTableView)
        view.addSubview(bottomShadowImageView)
        trendingRecipeVideoView.addSubview(trendingRecipeTumbnailImageView)
        trendingRecipeVideoView.addSubview(trendingRecipeVideoDetailsStackView)
        [
            trendingRecipeVideoTitleLabel,
            trendingRecipeVideoRatingCommentStackView
        ].forEach(trendingRecipeVideoDetailsStackView.addArrangedSubview)
        [
            ratingStackView,
            commentStackView
        ].forEach(trendingRecipeVideoRatingCommentStackView.addArrangedSubview)
        [
            ratingImageView,
            ratingLabel
        ].forEach(ratingStackView.addArrangedSubview)
        [
            commentImageView,
            commentLabel
        ].forEach(commentStackView.addArrangedSubview)
        
        trendingRecipeVideoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(29)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        trendingRecipeTumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-15)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(281)
        }
        trendingRecipeVideoDetailsStackView.snp.makeConstraints { make in
            make.top.equalTo(trendingRecipeTumbnailImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(16)
        }
        ratingImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        commentImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        trendingRecipeDetailTableView.snp.makeConstraints { make in
            make.top.equalTo(trendingRecipeVideoView.snp.bottom).offset(26)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    private func makeTrendingRecipeDetailDataSource() -> TrendingRecipeDetailDataSource{
        return TrendingRecipeDetailDataSource(tableView: trendingRecipeDetailTableView) { tableView, indexPath, itemIdentifier in
            switch indexPath.section {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TrendingRecipeDetailAuthorTableViewCell.identifier, for: indexPath) as! TrendingRecipeDetailAuthorTableViewCell
                cell.configure(self.author ?? .init(username: "", name: "", surname: "", image: ""))
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TrendingRecipeDetailDetailsTableViewCell.identifier, for: indexPath) as! TrendingRecipeDetailDetailsTableViewCell
                cell.configure(self.detailsCell ?? .init(cookingTime: "", details: ""))
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TrendingRecipeDetailIngredientsTableViewCell.identifier, for: indexPath) as! TrendingRecipeDetailIngredientsTableViewCell
                cell.configure(itemIdentifier.ingredients)
                    return cell
                case 3:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TrendingRecipeDetail6EasyStepsTableViewCell.identifier, for: indexPath) as! TrendingRecipeDetail6EasyStepsTableViewCell
                    cell.configure(itemIdentifier.easySteps)
                    return cell
                default:
                    return UITableViewCell()
            }
        }
    }
    private func applySnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<TrendingRecipeDetailSections, TrendingRecipeDetailModel>()
        snapshot.appendSections([.recipeAuthor, .details, .ingredients, .easySteps])
        snapshot.appendItems([.init(ingredients: [], easySteps: [], recipeAuthor: author, details: nil)], toSection: .recipeAuthor)
        snapshot.appendItems([.init(ingredients: [], easySteps: [], recipeAuthor: nil, details: detailsCell)], toSection: .details)
        snapshot.appendItems([.init(ingredients: ingredientsList, easySteps: [], recipeAuthor: nil, details: nil)], toSection: .ingredients)
        snapshot.appendItems([.init(ingredients: [], easySteps: stepsList, recipeAuthor: nil, details: nil)], toSection: .easySteps)
        trendingRecipeDetailDataSource.apply(snapshot, animatingDifferences: true)
    }
}
