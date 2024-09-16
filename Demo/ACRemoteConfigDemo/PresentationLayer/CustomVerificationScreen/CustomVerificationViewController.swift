//
//  CustomVerificationViewController.swift
//  ACRemoteConfigDemo
//
//  Created by Pavel Moslienko on 06.09.2024.
//

import UIKit

final class CustomVerificationViewController: UIViewController {
    
    var model: CustomVerificationViewModel = CustomVerificationViewModel(mode: .techWorks)
    
    // MARK: - UI components
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        
        return label
    }()

    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continiue without update", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: [])
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var gotoStoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update via App Store", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: [])
        button.addTarget(self, action: #selector(gotoStoreButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var tryAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Try again", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: [])
        button.addTarget(self, action: #selector(tryAgainButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        self.view.backgroundColor = .systemGroupedBackground
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.backgroundColor = .systemGroupedBackground
        
        view.addSubview(stackView)
        
        switch model.mode {
        case .techWorks:
            stackView.addArrangedSubview(tryAgainButton)
            titleLabel.text = "Tech works, please try later"
        case let .needToUpdate(to):
            stackView.addArrangedSubview(gotoStoreButton)
            titleLabel.text = "Need update for \(to)"
        case let .possibleToUpdate(to):
            titleLabel.text = "Version \(to) available in App Store"
            stackView.addArrangedSubview(gotoStoreButton)
            stackView.addArrangedSubview(continueButton)
        }
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc
    private func continueButtonTapped() {
        model.onContinueTapped?()
    }
    
    @objc
    private func gotoStoreButtonTapped() {
        model.onOpenStoreTapped?()
    }
    
    @objc
    private func tryAgainButtonTapped() {
        model.onRepeatTapped?()
    }
}
