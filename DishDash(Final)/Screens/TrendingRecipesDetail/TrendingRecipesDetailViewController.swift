//
//  TrendingRecipesDetailViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 18.06.24.
//

import UIKit

enum TrendingRecipeDetailSections {
    case recipeAuthor
    case details
    case ingredients
    case easySteps
}

struct TrendingRecipeDetailModel: Hashable{
    let id: String = UUID().uuidString
    let ingredients: [IngredientItemModel]
    let easySteps: [EasyStep]
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

typealias TrendingRecipeDetailDataSource = UITableViewDiffableDataSource<TrendingRecipeDetailSections, TrendingRecipeDetailModel>

class TrendingRecipesDetailViewController: UIViewController {
    
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
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        trendingRecipeDetailTableView.separatorStyle = .none
        setupUI()
        trendingRecipeDetailTableView.dataSource = trendingRecipeDetailDataSource
        applySnapshot()
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
            make.top.equalToSuperview()
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
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TrendingRecipeDetailDetailsTableViewCell.identifier, for: indexPath) as! TrendingRecipeDetailDetailsTableViewCell
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
        snapshot.appendItems([.init(ingredients: [], easySteps: [])], toSection: .recipeAuthor)
        snapshot.appendItems([.init(ingredients: [], easySteps: [])], toSection: .details)
        snapshot.appendItems([.init(ingredients: [
            .init(quantity: "1", ingredient: "pre-made pizza dough (store-bought or homemade)"),
            .init(quantity: "1/2", ingredient: "cup pizza sauce"),
            .init(quantity: "11/2", ingredient: "cups shredded mozzarella cheese"),
            .init(quantity: "1/2", ingredient: "cup sliced salami"),
            .init(quantity: "1/4", ingredient: "cup sliced black olives (optional)"),
            .init(quantity: "1/4", ingredient: "cup sliced red onion (optional)"),
            .init(quantity: "1/4", ingredient: "cup sliced mushrooms (optional)"),
            .init(quantity: "", ingredient: "Fresh basil leaves for garnish (optional)"),
            .init(quantity: "", ingredient: "Olive oil for brushing")
        ], easySteps: [])], toSection: .ingredients)
        snapshot.appendItems([.init(ingredients: [], easySteps: [
            .init(step: "1. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam pellentesque aliquet augue. ", bgColor: "PinkSubColor"),
            .init(step: "2. Phasellus faucibus aliquam tincidunt. Ut et elementum quam. Proin mi felis, dignissim at elit id, ullamcorper mattis est.", bgColor: "PinkBase"),
            .init(step: "3. Nunc molestie orci in mauris pretium ullamcorper. Vivamus et gravida felis. Nam bibendum libero turpis, ut facilisis justo hendrerit in. ", bgColor: "PinkSubColor"),
            .init(step: "4. Donec euismod magna est, quis blandit leo eleifend vitae. Maecenas ac luctus tortor, vel condimentum enim.", bgColor: "PinkBase"),
            .init(step: "5. Morbi non commodo erat. Aliquam id massa aliquet, porttitor dui at, commodo mi. Aliquam et semper nisl. Morbi sit amet aliquet tellus.", bgColor: "PinkSubColor"),
            .init(step: "6. Nam varius, diam in finibus congue, turpis eros lacinia nulla, vitae rutrum dolor dui at elit. Vestibulum id viverra felis, non gravida odio.", bgColor: "PinkBase")
        ])], toSection: .easySteps)
        trendingRecipeDetailDataSource.apply(snapshot, animatingDifferences: true)
    }
}
