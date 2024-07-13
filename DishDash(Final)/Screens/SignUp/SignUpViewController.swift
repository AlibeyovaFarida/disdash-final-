import UIKit
import SnapKit
import SPAlert
import FirebaseAuth
import FirebaseFirestore
class SignUpViewController: UIViewController {
    private let myTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Sign Up"
        lb.font = UIFont(name: "Poppins-SemiBold", size: 20)
        lb.textColor = UIColor(named: "RedPinkMain")
        return lb
    }()
    
    private let formStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 9
        return sv
    }()
    
    private let fullNameContainerView: CustomVisibleInputView = {
        let view = CustomVisibleInputView(placeholder: "John Doe", title: "Full Name")
        return view
    }()
    
    private let emailContainerView: CustomVisibleInputView = {
        let view = CustomVisibleInputView(placeholder: "example@example.com", title: "Email")
        return view
    }()
    
    private let phoneContainerView: CustomVisibleInputView = {
        let view = CustomVisibleInputView(placeholder: "+ 123 456 789", title: "Mobile Number")
        return view
    }()
    
    private let birthdateContainerView: CustomVisibleInputView = {
        let view = CustomVisibleInputView(placeholder: "DD / MM /YYY", title: "Date of birth")
        return view
    }()
    
    private let passwordContainerView: CustomInvisibleInputView = {
        let view = CustomInvisibleInputView(title: "Password")
        return view
    }()
    
    private let confirmPasswordContainerView: CustomInvisibleInputView = {
        let view = CustomInvisibleInputView(title: "Confirm Password")
        return view
    }()
    
    private let submitStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.alignment = .center
        return sv
    }()
    
    private let privacyLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Regular", size: 14)
        lb.textColor = UIColor(named: "TextColorBrown")
        lb.text = "By continuing, you agree to Terms of Use and Privacy Policy."
        lb.textAlignment = .center
        lb.numberOfLines = 2
        return lb
    }()
    
    private let signUpButton = CustomMiddleButton(title: "Sign up", backgroundColor: "RedPinkMain", textColor: "WhiteBeige")
    
    private let redirectionToLoginStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 4
        sv.alignment = .center
        return sv
    }()
    
    private let redirectionPart1Label: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 13)
        lb.text = "Already have an account?"
        lb.textColor = UIColor(named: "TextColorBrown")
        return lb
    }()
    
    private let redirectionPart2Label: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "LeagueSpartan-Light", size: 13)
        lb.text = "Log In"
        lb.textColor = UIColor(named: "PinkSubColor")
        lb.isUserInteractionEnabled = true
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(redirectLoginTapped))
        redirectionPart2Label.addGestureRecognizer(tapGesture)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        setupUI()
    }
    
    @objc
    private func redirectLoginTapped(){
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc
    private func signUpButtonTapped(){
        guard let fullname = fullNameContainerView.textField.text, !fullname.isEmpty else {
            showAlert(title: "Validation failed", message: "Fullname can't be empty")
            return
        }
        guard let email = emailContainerView.textField.text, !email.isEmpty else {
            showAlert(title: "Validation failed", message: "Email can't be empty")
            return
        }
        guard let phoneNumber = phoneContainerView.textField.text, !phoneNumber.isEmpty else {
            showAlert(title: "Validation failed", message: "Mobile number can't be empty")
            return
        }
        guard let birthDate = birthdateContainerView.textField.text, !birthDate.isEmpty else {
            showAlert(title: "Validation failed", message: "Date of birth can't be empty")
            return
        }
        guard let password = passwordContainerView.textField.text, !password.isEmpty else {
            showAlert(title: "Validation failed", message: "Password can't be empty")
            return
        }
        guard let confirmPassword = confirmPasswordContainerView.textField.text, !confirmPassword.isEmpty else {
            showAlert(title: "Validation failed", message: "Confirm Password can't be empty")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authDataResult, signUpError in
            if let error = signUpError {
                self?.showAlert(title: "Something went wrong", message: error.localizedDescription)
            }
            
            let newUserInfo = Auth.auth().currentUser
            if let userId = newUserInfo?.uid {
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["fullname": fullname, "email": email, "phoneNumber": phoneNumber, "birthDate": birthDate, "userId": userId])
            }
        }
        let vc = LoginViewController()
        let overlayView = UIView(frame: self.view.bounds)
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let alertView = SPAlertView(title: "Sign up Succesful!", message: "Lorem ipsum dolor sit amet pretium cras id dui pellentesque ornare. Quisque malesuada.", preset: .custom(UIImage(named: "alert-user-icon")!))
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
            
            // Add the overlay view to the main view
            self.view.addSubview(overlayView)
        alertView.present(haptic: .success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
               vc.modalPresentationStyle = .fullScreen
               self.present(vc, animated: true, completion: nil)
           }
    }
    
    private func setupUI(){
        view.addSubview(myTitleLabel)
        view.addSubview(formStackView)
        view.addSubview(submitStackView)
        
        [
            fullNameContainerView,
            emailContainerView,
            phoneContainerView,
            birthdateContainerView,
            passwordContainerView,
            confirmPasswordContainerView
        ].forEach(formStackView.addArrangedSubview)
        
        [
            privacyLabel,
            signUpButton,
            redirectionToLoginStackView
        ].forEach(submitStackView.addArrangedSubview)
        
        [
            redirectionPart1Label,
            redirectionPart2Label
        ].forEach(redirectionToLoginStackView.addArrangedSubview)
        
        myTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(28)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        formStackView.snp.makeConstraints { make in
            make.top.equalTo(myTitleLabel.snp.bottom).offset(70)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        
        submitStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
    }
}
