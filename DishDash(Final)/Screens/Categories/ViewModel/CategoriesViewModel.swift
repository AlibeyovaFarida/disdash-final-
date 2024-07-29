
import Firebase

class CategoriesViewModel{
    private var categoriesList: [CategoryItemModel] = []
    private var seafoodCategory: CategoryItemModel?
    
    var categoriesUpdated: (() -> Void)?
    var seafoodCategoryUpdated: (() -> Void)?
    var errorOccured: ((String) -> Void)?
    
    func fetchcategories(){
        let db = Firestore.firestore()
        
        db.collection("categories").whereField("name", isEqualTo: "Seafood").getDocuments { [weak self] querySnapshot, error in
            if let error = error {
                self?.errorOccured?(error.localizedDescription)
            } else {
                if let document = querySnapshot?.documents.first {
                    let category = CategoryItemModel(image: document.data()["image"] as! String, name: document.data()["name"] as! String)
                    self?.seafoodCategory = category
                    self?.seafoodCategoryUpdated?()
                }
            }
        }
        
        db.collection("categories").whereField("name", isNotEqualTo: "Seafood").getDocuments { [weak self] querySnapshot, error in
            if let error = error {
                self?.errorOccured?(error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    let category = CategoryItemModel(image: document.data()["image"] as! String, name: document.data()["name"] as! String)
                    self?.categoriesList.append(category)
                }
                self?.categoriesUpdated?()
            }
        }
    }
    
    func getSeafoodCategory() -> CategoryItemModel? {
        return seafoodCategory
    }
    
    func getCategoriesCount() -> Int {
        return categoriesList.count
    }
    
    func getCategory(at index: Int) -> CategoryItemModel {
        return categoriesList[index]
    }
}

