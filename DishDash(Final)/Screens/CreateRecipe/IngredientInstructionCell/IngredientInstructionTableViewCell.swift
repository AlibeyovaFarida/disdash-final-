//
//  IngredientInstructionTableViewCell.swift
//  DishDash(Final)
//
//  Created by Apple on 20.07.24.
//

import UIKit

protocol IngredientInstructionTableViewCellDelegate: AnyObject {
    func didTapDeleteButton(in cell: IngredientInstructionTableViewCell)
}
protocol IngredientInstructionTableViewCellDelegate2: AnyObject {
    func didUpdateText(in cell: IngredientInstructionTableViewCell, with text: String)
}
class IngredientInstructionTableViewCell: UITableViewCell {
    weak var delegate: IngredientInstructionTableViewCellDelegate?
    weak var delegate2: IngredientInstructionTableViewCellDelegate2?
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 7
        sv.axis = .horizontal
        return sv
    }()
    private let textfieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "PinkBase")
        view.layer.cornerRadius = 18
        return view
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor(named: "ComponenteBrownTextLight")
        tf.font = UIFont(name: "Poppins-Medium", size: 16)
        return tf
    }()
    private let deleteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "Delete"), for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 20.5
        return btn
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func deleteButtonTapped() {
        delegate?.didTapDeleteButton(in: self)
    }
    @objc private func textFieldDidChange() {
        guard let text = textField.text else { return }
        delegate2?.didUpdateText(in: self, with: text)
    }
    private func setupUI(){
        contentView.addSubview(stackView)
        [
            textfieldView,
            deleteButton
        ].forEach(stackView.addArrangedSubview)
        textfieldView.addSubview(textField)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(7.5)
            make.leading.trailing.equalToSuperview()
        }
        textfieldView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8.5)
            make.leading.trailing.equalToSuperview().inset(36)
        }
        deleteButton.snp.makeConstraints { make in
            make.size.equalTo(41)
        }
    }
    func configure(with text: String) {
        textField.text = text
    }
}

