//
//  LoginViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 31.05.24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore

class LoginViewController: UIViewController {
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Login"
        lb.font = UIFont(name: "Poppins-SemiBold", size: 20)
        lb.textColor = UIColor(named: "RedPinkMain")
        return lb
    }()
    private let formStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    private let emailContainerView: CustomVisibleInputView = {
        let view = CustomVisibleInputView(placeholder: "example@example.com", title: "Email")
        return view
    }()
    private let passwordContainerView: CustomInvisibleInputView = {
            let view = CustomInvisibleInputView(title: "Password")
            return view
        }()
    private let buttonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 27
        sv.alignment = .center
        return sv
    }()
    private let loginButton = CustomMiddleButton(title: "Log In", backgroundColor: "PinkBase", textColor: "PinkSubColor")
    private let signUpButton = CustomMiddleButton(title: "Sign Up", backgroundColor: "PinkBase", textColor: "PinkSubColor")
    private let forgotPasswordLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Forgot Password?"
        lb.font = UIFont(name: "LeagueSpartan-SemiBold", size: 14)
        lb.textAlignment = .center
        return lb
    }()
    private let alternativeLoginStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 24
        sv.alignment = .center
        return sv
    }()
    private let alternativeLoginLabel: UILabel = {
        let lb = UILabel()
        lb.text = "or sign up with"
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 13)
        lb.textAlignment = .center
        return lb
    }()
    private let optionsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 14
        sv.alignment = .center
        return sv
    }()
    private let instagramImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "instagram")
        return iv
    }()
    private let googleImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "google")
        iv.isUserInteractionEnabled = true
        return iv
    }()
    private let facebookImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "facebook")
        return iv
    }()
    private let whatsappImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "whatsapp")
        return iv
    }()
    private let redirectionToSignUpLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Don’t have an account? Sign Up"
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 13)
        lb.textAlignment = .center
        lb.isUserInteractionEnabled = true
        return lb
    }()
    override func viewDidLoad() {
        let tapGestureGoogle = UITapGestureRecognizer(target: self, action: #selector(didTapSignInGoogle))
        googleImageView.addGestureRecognizer(tapGestureGoogle)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signUpTapped))
        redirectionToSignUpLabel.addGestureRecognizer(tapGesture)
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        setupUI()
    }
    @objc
    private func didTapSignInGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
                
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { authentication, error in
            if let error = error {
                print("There is an error signing the user in ==> \(error)")
                return
            }
            guard let user = authentication?.user, let idToken = user.idToken?.tokenString else {return}
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { [weak self] authDataResult, error in
                if let error = error{
                    self?.showAlert(title: "Something went wrong", message: error.localizedDescription)
                    return
                }
                let newUserInfo = authDataResult?.user
                if let userId = newUserInfo?.uid {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["fullname": newUserInfo?.displayName, "email": newUserInfo?.email, "phoneNumber": newUserInfo?.phoneNumber, "birthDate": "", "userId": newUserInfo?.uid])
                }
                let tvc = CustomTabBarController()
                UIApplication.shared.keyWindow?.rootViewController = tvc
            }
            
        }
    }
    @objc
    private func loginButtonTapped(){
        guard let email = emailContainerView.textField.text, !email.isEmpty else{
            showAlert(title: "Validation failed", message: "Email can't be empty")
            return
        }
        guard let password = passwordContainerView.textField.text, !password.isEmpty else{
            showAlert(title: "Validation failed", message: "Password can't be empty")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] authDataResult, error in
            if let error = error{
                self?.showAlert(title: "Something went wrong", message: error.localizedDescription)
                return
            }
            let tvc = CustomTabBarController()
            UIApplication.shared.keyWindow?.rootViewController = tvc
        }
    }
    @objc
    private func signUpTapped(){
        let vc = SignUpViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    private func setupUI(){
        view.addSubview(titleLabel)
        view.addSubview(formStackView)
        view.addSubview(alternativeLoginStackView)
        [
            emailContainerView,
            passwordContainerView,
            buttonsStackView
        ].forEach(formStackView.addArrangedSubview)
        formStackView.setCustomSpacing(69, after: passwordContainerView)
        [
            loginButton,
            signUpButton
        ].forEach(buttonsStackView.addArrangedSubview)
        [
            forgotPasswordLabel,
            alternativeLoginLabel,
            optionsStackView,
            redirectionToSignUpLabel
        ].forEach(alternativeLoginStackView.addArrangedSubview)
        [
            instagramImageView,
            googleImageView,
            facebookImageView,
            whatsappImageView
        ].forEach(optionsStackView.addArrangedSubview)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(28)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        formStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(120)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        alternativeLoginStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
