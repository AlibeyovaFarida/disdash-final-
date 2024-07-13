import UIKit
import RevolvTabBar

final class CustomTabBarController: RevolvTabBar {
    
    private let homeNavVc: UINavigationController = {
        let vc = UINavigationController(rootViewController: CommunityViewController())
        return vc
    }()
    
    private let categoriesNavVc: UINavigationController = {
        let vc = UINavigationController(rootViewController: CategoriesViewController())
        return vc
    }()
    
    private let communityNavVc: UINavigationController = {
        let vc = UINavigationController(rootViewController: HomeViewController())
        return vc
    }()
    
    private let profileNavVc: UINavigationController = {
        let vc = UINavigationController(rootViewController: ProfileViewController())
//        vc.tabBarItem.image = UIImage(named: "Profile")
//        vc.tabBarItem.selectedImage = UIImage(named: "ProfileSelected")
        return vc
    }()
    
    override var items: RevolvTabBarView.Item {
        .init(
                items: [
                    .init(icon: UIImage(named: "Home"), selectedIcon: UIImage(named: "HomeSelected")),
                    .init(icon: UIImage(named: "Categories"), selectedIcon: UIImage(named: "CategoriesSelected")),
                    .init(icon: UIImage(named: "Community"), selectedIcon: UIImage(named: "CommunitySelected")),
                    .init(icon: UIImage(named: "Profile"), selectedIcon: UIImage(named: "ProfileSelected"))
                ],
                tintColor: UIColor(named: "WhiteBeige")!,
                selectedTintColor: UIColor(named: "WhiteBeige")!
        )
    }
    override var tabBarBackgroundColor: UIColor? {
            return UIColor(named: "RedPinkMain")
        }
    // View Controllers-i tab bar-a əlavə edin
    override var viewControllers: [UIViewController] {
        [homeNavVc, categoriesNavVc, communityNavVc, profileNavVc]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar()
    }
    
//    private func setupTabBar() {
//        tabBar.layer.cornerRadius = 33
//        tabBar.backgroundImage = UIImage()
//        
//        tabBar.tintColor = UIColor(named: "WhiteBeige") // Seçilmiş icon rəngi
//        tabBar.unselectedItemTintColor = UIColor(named: "WhiteBeige")
//        
//    }
}
