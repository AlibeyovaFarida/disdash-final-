//
//  CreateRecipeViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 19.07.24.
//

import UIKit
import Firebase
import FirebaseStorage
import SPAlert
import FirebaseAuth


class CreateRecipeViewController: UIViewController, UINavigationControllerDelegate {
    let userId = Auth.auth().currentUser?.uid
    private let db = Firestore.firestore()
    private let picker = UIImagePickerController()
    private var ingredients: [String] = []
    private var instructions: [String] = []
    private var ingredientsTableViewHeightConstraint: NSLayoutConstraint?
    private var instructionsTableViewHeightConstraint: NSLayoutConstraint?
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    private let contentViewInScroll: UIView = {
        let view = UIView()
        return view
    }()
    private let publishDeleteButtonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 6
        return sv
    }()
    private let publishButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Publish", for: .normal)
        btn.backgroundColor = UIColor(named: "PinkBase")
        btn.setTitleColor(UIColor(named: "PinkSubColor"), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
        btn.frame = CGRect(x: 0, y: 0, width: 177, height: 27)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 13.5
        return btn
    }()
    private let deleteButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Delete", for: .normal)
        btn.backgroundColor = UIColor(named: "PinkBase")
        btn.setTitleColor(UIColor(named: "PinkSubColor"), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
        btn.frame = CGRect(x: 0, y: 0, width: 177, height: 27)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 13.5
        return btn
    }()
    private let selectImageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "PinkBase")
        view.layer.cornerRadius = 20
        return view
    }()
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    private let activateStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16.5
        sv.alignment = .center
        return sv
    }()
    private let activateButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "Activate"), for: .normal)
        btn.addTarget(self, action: #selector(didImagePicker), for: .touchUpInside)
        return btn
    }()
    @objc
    private func didImagePicker(){
        let alertVC = UIAlertController(title: "Select image", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Open camera", style: .default) { _ in
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true)
        }
        let galeryAction = UIAlertAction(title: "Open galery", style: .default) { _ in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true)
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        
        alertVC.addAction(cameraAction)
        alertVC.addAction(galeryAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
    }
    private let textFieldStackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 13
        sv.axis = .vertical
        return sv
    }()
    private let titleTextField = CustomVisibleInputView(placeholder: "Recipe title", title: "Title")
    private let descriptionTextField = CustomVisibleInputView(placeholder: "Recipe description", title: "Description")
    private let detailsTextField = CustomVisibleInputView(placeholder: "Recipe details", title: "Details")
    private let categoryTextField = CustomVisibleInputView(placeholder: "Recipe category", title: "Category")
    private let tasteTextField = CustomVisibleInputView(placeholder: "Recipe taste", title: "Taste")
    private let timeRecipeTextField = CustomVisibleInputView(placeholder: "1hour, 30min, ...", title: "Time Recipe")
    
    private let ingredientsLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Ingredients"
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "TextColorBrown")
        return lb
    }()
    private let ingredientsTableView: UITableView = {
        let tv = UITableView()
        tv.register(IngredientInstructionTableViewCell.self, forCellReuseIdentifier: IngredientInstructionTableViewCell.identifier)
        return tv
    }()
    private let addIngredientButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("+ Add Ingredient", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
        btn.setTitleColor(UIColor(named: "WhiteBeige"), for: .normal)
        btn.backgroundColor = UIColor(named: "RedPinkMain")
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 17.5
        btn.frame = CGRect(x: 0, y: 0, width: 211, height: 35)
        return btn
    }()
    private let instructionsLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Instructions"
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "TextColorBrown")
        return lb
    }()
    private let instructionsTableView: UITableView = {
        let tv = UITableView()
        tv.register(IngredientInstructionTableViewCell.self, forCellReuseIdentifier: IngredientInstructionTableViewCell.identifier)
        return tv
    }()
    private let addInstructionButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("+ Add Instruction", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
        btn.setTitleColor(UIColor(named: "WhiteBeige"), for: .normal)
        btn.backgroundColor = UIColor(named: "RedPinkMain")
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 17.5
        btn.frame = CGRect(x: 0, y: 0, width: 211, height: 35)
        return btn
    }()
    private let bottomShadowImageView = BottomShadowImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBackButton()
        navigationItem.title = "Create Recipe"
        if let navigationBar = self.navigationController?.navigationBar {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(named: "RedPinkMain")!
            ]
            navigationBar.titleTextAttributes = textAttributes
        }
        view.backgroundColor = UIColor(named: "WhiteBeige")
        ingredientsTableView.dataSource = self
        instructionsTableView.dataSource = self
        ingredientsTableView.separatorStyle = .none
        instructionsTableView.separatorStyle = .none
        addIngredientButton.addTarget(self, action: #selector(addIngredientButtonTapped), for: .touchUpInside)
        addInstructionButton.addTarget(self, action: #selector(addInstructionButtonTapped), for: .touchUpInside)
        publishButton.addTarget(self, action: #selector(didTapPublishButton), for: .touchUpInside)
        picker.delegate = self
        setupUI()
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
    @objc private func addIngredientButtonTapped() {
        ingredients.append("") // Add a new empty ingredient
        ingredientsTableView.insertRows(at: [IndexPath(row: ingredients.count - 1, section: 0)], with: .automatic)
        ingredientsTableView.reloadData()
        updateIngredientsTableViewHeight()
    }
    @objc private func addInstructionButtonTapped() {
        instructions.append("") // Add a new empty ingredient
        instructionsTableView.insertRows(at: [IndexPath(row: instructions.count - 1, section: 0)], with: .automatic)
        instructionsTableView.reloadData()
        updateInstructionsTableViewHeight()
    }
    @objc private func didTapPublishButton(){
        guard let image = imageView.image else{
            showAlert(title: "Validation failed", message: "Image can't be empty")
            return
        }
        guard let title = titleTextField.textField.text, !title.isEmpty else{
            showAlert(title: "Validation failed", message: "Title can't be empty")
            return
        }
        guard let description = descriptionTextField.textField.text, !description.isEmpty else{
            showAlert(title: "Validation failed", message: "Description can't be empty")
            return
        }
        guard let details = detailsTextField.textField.text, !details.isEmpty else{
            showAlert(title: "Validation failed", message: "Details can't be empty")
            return
        }
        guard let category = categoryTextField.textField.text, !category.isEmpty else{
            showAlert(title: "Validation failed", message: "Category can't be empty")
            return
        }
        guard let taste = tasteTextField.textField.text, !taste.isEmpty else{
            showAlert(title: "Validation failed", message: "Taste can't be empty")
            return
        }
        guard let timeRecipe = timeRecipeTextField.textField.text, !timeRecipe.isEmpty else{
            showAlert(title: "Validation failed", message: "Time Recipe can't be empty")
            return
        }
        guard let id = userId else {
            self.showAlert(title: "Invalid user", message: "No such user exists")
            return
        }
        var fullname: String = ""
        var name: String = ""
        var surname: String = ""
        db.collection("users").whereField("userId", isEqualTo: id).getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(title: "Server error", message: error.localizedDescription)
            } else {
                for document in querySnapshot!.documents{
                    fullname = document.data()["fullname"] as! String
                    name = fullname.components(separatedBy: " ")[0]
                    surname = fullname.components(separatedBy: " ")[1]
                }
            }
        }
        guard let image = imageView.image, let imageData = image.jpegData(compressionQuality: 0.75) else {
                return
            }

            let storageRef = Storage.storage().reference().child("recipe_images/\(UUID().uuidString).jpg")
            let uploadTask = storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        return
                    }

                    guard let imageUrl = url?.absoluteString else {
                        print("Error: No download URL")
                        return
                    }
                    
                    self.db.collection("recipes").addDocument(data: [
                        "name": title,
                        "description": description,
                        "image": imageUrl,
                        "details": details,
                        "category": category,
                        "taste": taste,
                        "cookingTime": timeRecipe,
                        "rating": 0,
                        "ingredients": self.ingredients,
                        "steps": self.instructions,
                        "date": FieldValue.serverTimestamp(),
                        "chef": [
                            "name": name,
                            "surname": surname,
                            "image": "",
                            "username": ""
                        ],
                        
                    ]) { error in
                        if let error = error {
                            print("Error adding document: \(error)")
                        } else {
                            print("Document added successfully!")
                            // Optionally, navigate away or clear the form
                            self.clearForm()
                        }
                    }
                }
            }
        let overlayView = UIView(frame: self.view.bounds)
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let alertView = SPAlertView(title: "New recipe successfully added", message: "Lorem ipsum dolor sit amet pretium cras id dui pellentesque ornare. Quisque malesuada.", preset: .custom(UIImage(named: "alert-user-icon")!))
        alertView.layer.cornerRadius = 40
        alertView.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 20)
        alertView.titleLabel?.textColor = UIColor(named: "ComponenteBrownText")
        alertView.titleLabel?.textAlignment = .center
        alertView.titleLabel?.numberOfLines = 0
        alertView.titleLabel?.lineBreakMode = .byWordWrapping
        alertView.subtitleLabel?.font = UIFont(name: "Poppis-Regular", size: 13)
        alertView.subtitleLabel?.textColor = UIColor(named: "ComponenteBrownText")
        alertView.layout.iconSize = .init(width: 82, height: 82)
        alertView.layout.margins.top = 23
        alertView.layout.margins.bottom = 23
        alertView.layout.margins.left = 36
        alertView.layout.margins.right = 30
        alertView.layout.spaceBetweenIconAndTitle = 10
        alertView.backgroundColor = UIColor(named: "WhiteBeige")
        alertView.center = overlayView.center
        overlayView.addSubview(alertView)
        
        self.view.addSubview(overlayView)
        alertView.present(haptic: .success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    private func clearForm() {
        titleTextField.textField.text = ""
        descriptionTextField.textField.text = ""
        timeRecipeTextField.textField.text = ""
        imageView.image = UIImage(named: "")
        ingredients.removeAll()
        instructions.removeAll()
        ingredientsTableView.reloadData()
        instructionsTableView.reloadData()
    }
    private func updateIngredientsTableViewHeight() {
        ingredientsTableViewHeightConstraint?.constant = CGFloat(ingredients.count * 56)
    }
    private func updateInstructionsTableViewHeight() {
        instructionsTableViewHeightConstraint?.constant = CGFloat(instructions.count * 56)
    }
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentViewInScroll)
        view.addSubview(bottomShadowImageView)

        [
            publishDeleteButtonsStackView,
            selectImageView,
            textFieldStackView,
            ingredientsLabel,
            ingredientsTableView,
            addIngredientButton,
            instructionsLabel,
            instructionsTableView,
            addInstructionButton
        ].forEach(contentViewInScroll.addSubview)

        [
            publishButton,
            deleteButton
        ].forEach(publishDeleteButtonsStackView.addArrangedSubview)

        [
            imageView,
            activateStackView
        ].forEach(selectImageView.addSubview)

        [
            activateButton
        ].forEach(activateStackView.addArrangedSubview)

        [
            titleTextField,
            descriptionTextField,
            detailsTextField,
            tasteTextField,
            categoryTextField,
            timeRecipeTextField
        ].forEach(textFieldStackView.addArrangedSubview)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentViewInScroll.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }

        publishDeleteButtonsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(28)
        }

        let screenWidth = UIScreen.main.bounds.width
        publishButton.snp.makeConstraints { make in
            make.width.equalTo((screenWidth - 62) / 2)
            make.height.equalTo(27)
        }
        deleteButton.snp.makeConstraints { make in
            make.width.equalTo((screenWidth - 62) / 2)
            make.height.equalTo(27)
        }

        selectImageView.snp.makeConstraints { make in
            make.top.equalTo(publishDeleteButtonsStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(281)
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalTo(selectImageView)
        }

        activateStackView.snp.makeConstraints { make in
            make.center.equalTo(selectImageView)
        }

        activateButton.snp.makeConstraints { make in
            make.size.equalTo(71)
        }

        textFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(selectImageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(28)
        }

        ingredientsLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(28)
        }

        ingredientsTableView.snp.makeConstraints { make in
            make.top.equalTo(ingredientsLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        ingredientsTableViewHeightConstraint = ingredientsTableView.heightAnchor.constraint(equalToConstant: CGFloat(ingredients.count * 56))
        ingredientsTableViewHeightConstraint?.isActive = true
        
        addIngredientButton.snp.makeConstraints { make in
            make.top.equalTo(ingredientsTableView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(211)
            make.height.equalTo(35)
        }

        instructionsLabel.snp.makeConstraints { make in
            make.top.equalTo(addIngredientButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(28)
        }

        instructionsTableView.snp.makeConstraints { make in
            make.top.equalTo(instructionsLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        instructionsTableViewHeightConstraint = instructionsTableView.heightAnchor.constraint(equalToConstant: CGFloat(instructions.count * 56))
        instructionsTableViewHeightConstraint?.isActive = true
        
        addInstructionButton.snp.makeConstraints { make in
            make.top.equalTo(instructionsTableView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(211)
            make.height.equalTo(35)
            make.bottom.equalToSuperview().offset(-120)
        }

        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

}

extension CreateRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientsTableView {
            return ingredients.count
        }
        else if tableView == instructionsTableView {
            return instructions.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientInstructionTableViewCell.identifier, for: indexPath) as! IngredientInstructionTableViewCell
            cell.delegate = self
            cell.delegate2 = self
        if tableView == ingredientsTableView {
            cell.configure(with: ingredients[indexPath.row])
        } else if tableView == instructionsTableView {
            cell.configure(with: instructions[indexPath.row])
        }
        
        return cell
    }
}
extension CreateRecipeViewController: IngredientInstructionTableViewCellDelegate {
    func didTapDeleteButton(in cell: IngredientInstructionTableViewCell) {
        if let indexPath = ingredientsTableView.indexPath(for: cell) {
            ingredients.remove(at: indexPath.row)
            ingredientsTableView.deleteRows(at: [indexPath], with: .automatic)
            updateIngredientsTableViewHeight()
        } else if let indexPath = instructionsTableView.indexPath(for: cell) {
            instructions.remove(at: indexPath.row)
            instructionsTableView.deleteRows(at: [indexPath], with: .automatic)
            updateInstructionsTableViewHeight()
        }
    }
}
extension CreateRecipeViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageView.image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true)
    }
}

extension CreateRecipeViewController: IngredientInstructionTableViewCellDelegate2 {
    func didUpdateText(in cell: IngredientInstructionTableViewCell, with text: String) {
        if let indexPath = ingredientsTableView.indexPath(for: cell) {
            ingredients[indexPath.row] = text
        } else if let indexPath = instructionsTableView.indexPath(for: cell) {
            instructions[indexPath.row] = text
        }
    }
}
