//
//  SearchViewController.swift
//  DishDash(Final)
//
//  Created by Apple on 11.07.24.
//

import UIKit

class SearchViewController: UIViewController {
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "WhiteBeige")
        view.layer.cornerRadius = 50
        return view
    }()
    private let searchTextField: UISearchTextField = {
        let stf = UISearchTextField()
        stf.backgroundColor = UIColor(named: "PinkBase")
        stf.layer.cornerRadius = 17
        stf.layer.masksToBounds = true
        stf.placeholder = "Search"
        stf.tintColor = UIColor(named: "RedPinkMain")
        let placeholderColor = UIColor(named: "RedPinkMain") ?? UIColor(named: "WhiteBeige")
            let placeholderFont = UIFont(name: "Poppins-Regular", size: 12)
            stf.attributedPlaceholder = NSAttributedString(
                string: stf.placeholder ?? "",
                attributes: [
                    NSAttributedString.Key.foregroundColor: placeholderColor ?? "",
                    NSAttributedString.Key.font: placeholderFont ?? UIFont.systemFont(ofSize: 12)
                ]
            )
        stf.textColor = UIColor(named: "RedPinkMain")
        stf.font = UIFont(name: "Poppins-Regular", size: 12)
        stf.leftView = nil
        return stf
    }()
    private let searchButton = CustomMiddleButton(title: "Search", backgroundColor: "RedPinkMain", textColor: "WhiteBeige")
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           presentSearchView()
    }
    private func setupUI(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSearchView))
        view.addGestureRecognizer(tapGesture)
        view.addSubview(contentView)
        contentView.addSubview(searchTextField)
        contentView.addSubview(searchButton)
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        searchTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(34)
        }
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(51)
        }
        contentView.frame = CGRect(x: 0, y: -view.frame.height, width: view.frame.width, height: view.frame.height / 2)
                searchTextField.alpha = 0
                searchButton.alpha = 0
    }
    func presentSearchView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 2)
            self.searchTextField.alpha = 1
            self.searchButton.alpha = 1
        })
    }
    @objc
    private func dismissSearchView(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !contentView.frame.contains(location) {
                dismiss(animated: false)
        }
    }
}
