import UIKit
import SnapKit

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
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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
