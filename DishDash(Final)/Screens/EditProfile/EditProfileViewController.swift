//
//  EditProfileViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 05.07.24.
//

import UIKit

class EditProfileViewController: UIViewController, UINavigationControllerDelegate{
    private let picker = UIImagePickerController()
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "profile-image")
        let pickerAction = UITapGestureRecognizer(target: self, action: #selector(didImagePicker))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(pickerAction)
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 48.5
        return iv
    }()
    private let inputsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        return sv
    }()
    private let nameTextField = CustomVisibleInputView(placeholder: "Dianne Russell", title: "Name")
    private let usernameTextField = CustomVisibleInputView(placeholder: "dianne_r", title: "Username")
    private let presentationTextField = CustomVisibleInputView(placeholder: "My passion is cooking and sharing new recipes with the world.", title: "Presentation")
    private let linkTextField = CustomVisibleInputView(placeholder: "", title: "Add Link")
    private let saveButton = CustomSmallButton(title: "Save", backgroundColor: "RedPinkMain", textColor: "WhiteBeige")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        profileImageView.isUserInteractionEnabled = true
        picker.delegate = self
        setupUI()
    }
    private func setupUI(){
        setupCustomBackButton()
        view.addSubview(profileImageView)
        view.addSubview(inputsStackView)
        [
            nameTextField,
            usernameTextField,
            presentationTextField,
            linkTextField
        ].forEach(inputsStackView.addArrangedSubview)
        view.addSubview(saveButton)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(28.5)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(97)
        }
        inputsStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(38)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(inputsStackView.snp.bottom).offset(80)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
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
}
extension EditProfileViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.profileImageView.image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true)
    }
}
