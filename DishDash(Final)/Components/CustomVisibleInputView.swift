//  CustomVisibleInputView.swift
//  DishDash(Final)
//
//  Created by Apple on 25.05.24.
//

import UIKit
import SnapKit

class CustomVisibleInputView: UIView {
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Email"
        lb.font = UIFont(name: "Poppins-Medium", size: 15)
        lb.textColor = UIColor(named: "BrownLetters")
        return lb
    }()
    
    private let textfieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "PinkBase")
        view.layer.cornerRadius = 18
        return view
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor(named: "ComponenteBrownTextLight")
        tf.font = UIFont(name: "Poppins-Medium", size: 16)
        return tf
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 9
        return stackView
    }()
    
    init(frame: CGRect = .zero, placeholder: String, title: String) {
        super.init(frame: frame)
        textField.placeholder = placeholder
        titleLabel.text = title
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textfieldView)
        textfieldView.addSubview(textField)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textfieldView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8.5)
            make.leading.trailing.equalToSuperview().inset(36)
        }
    }
}
