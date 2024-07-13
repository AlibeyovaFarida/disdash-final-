//
//  CustomInvisibleInputView.swift
//  DishDash(Final)
//
//  Created by Apple on 03.06.24.
//

import UIKit
import SnapKit

class CustomInvisibleInputView: UIView {
    
    private let titlelabel: UILabel = {
        let lb = UILabel()
        lb.text = "Password"
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "BrownLetters")
        return lb
    }()
    
    private let textFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "PinkBase")
        view.layer.cornerRadius = 18
        return view
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .center
        return sv
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "● ● ● ● ● ● ● ●"
        tf.isSecureTextEntry = true
        tf.textColor = UIColor(named: "ComponenteBrownTextLight")
        tf.font = UIFont(name: "Poppins-Medium", size: 16)
        return tf
    }()
    
    private let eyeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "eye-off")
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let fullStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 9
        return sv
    }()
    
    init(frame: CGRect = .zero , title: String) {
        super.init(frame: frame)
        titlelabel.text = title
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupActions()
    }
    
    private func setupView() {
        addSubview(fullStackView)
        
        fullStackView.addArrangedSubview(titlelabel)
        fullStackView.addArrangedSubview(textFieldView)
        textFieldView.addSubview(stackView)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(eyeImageView)
        
        fullStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textFieldView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8.5)
            make.leading.equalToSuperview().inset(36)
            make.trailing.equalToSuperview().inset(20)
        }
        
        eyeImageView.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(20)
        }
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        eyeImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func togglePasswordVisibility() {
        textField.isSecureTextEntry.toggle()
        let imageName = textField.isSecureTextEntry ? "eye-off" : "eye-on"
        eyeImageView.image = UIImage(named: imageName)
    }
}

