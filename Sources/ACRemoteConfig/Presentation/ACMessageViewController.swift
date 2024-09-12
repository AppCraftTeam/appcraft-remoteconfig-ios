//
//  ACMessageViewControllerProtocol.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit

public protocol ACMessageViewControllerProtocol: UIViewController {
    var model: ACMessageViewModel { get set }
    var image: UIImage? { get set }
    var titleText: String { get set }
    var subtitleText: String { get set }
    
    func addActions(_ actions: [ACMessageViewModel.ActionModel])
}

open class ACMessageViewController: UIViewController, ACMessageViewControllerProtocol {
    
    public var model: ACMessageViewModel = ACMessageViewModel.default() {
        didSet {
            configureView(with: model)
        }
    }
    
    // Label for the title
    public private(set) lazy var titleLabel = UILabel()
    
    // Label for the subtitle
    public private(set) lazy var subtitleLabel = UILabel()
    
    // Stack view to organize the content
    public private(set) lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    // Stack view to the buttons
    public private(set) lazy var actionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // Title text
    public var titleText: String {
        get { titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }
    
    // Subtitle text
    public var subtitleText: String {
        get { subtitleLabel.text ?? "" }
        set {
            subtitleLabel.text = newValue
            setupSubtitleLabel()
        }
    }
    
    // Icon image view
    public private(set) var imageView = UIImageView()
    
    // View image
    open var image: UIImage? {
        get { imageView.image }
        set {
            imageView.image = newValue
            setupImageView()
        }
    }
    
    public var contentSpacing: CGFloat {
        get { contentStackView.spacing }
        set { contentStackView.spacing = newValue }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        configureView(with: model)
    }
    
    // MARK: - Setup Methods
    
    private func configureView(with model: ACMessageViewModel) {
        self.titleText = model.title
        self.subtitleText = model.subtitle
        self.image = model.image
        self.addActions(model.actions)
    }
    
    private func setupComponents() {
        decorate()
        removeSubviews([contentStackView, actionsStackView])
        addSubviews([contentStackView, actionsStackView])
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        switch model.messagePosition {
        case .top:
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        case .center:
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    private func setupSubtitleLabel() {
        if subtitleText.isEmpty {
            removeSubviews([subtitleLabel])
        } else if subtitleLabel.superview == nil {
            contentStackView.addArrangedSubview(subtitleLabel)
        }
    }
    
    private func setupImageView() {
        if imageView.image != nil {
            if imageView.superview == nil {
                view.addSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
                    imageView.topAnchor.constraint(greaterThanOrEqualTo: contentStackView.bottomAnchor, constant: 16),
                    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
            }
        } else {
            removeSubviews([imageView])
        }
    }
    
    open func addActions(_ actions: [ACMessageViewModel.ActionModel]) {
        removeAllAction()
        for (index, action) in actions.enumerated() {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.setTitle(action.text, for: .normal)
            if #available(iOS 13.0, *) {
                button.setTitleColor(.label, for: [])
            } else {
                button.setTitleColor(.black, for: [])
            }
            button.tag = index
            button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
            
            self.actionsStackView.addArrangedSubview(button)
        }
    }
    
    private func removeSubviews(_ subviews: [UIView]) {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func removeAllAction() {
        actionsStackView.removeAllArrangedSubviews()
    }
    
    open func decorate() {
        view.backgroundColor = if #available(iOS 13, *) { .systemBackground } else { .white }
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        titleLabel.textColor = if #available(iOS 13, *) { .label } else { .black }
        
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = if #available(iOS 13, *) { .label } else { .black }
        subtitleLabel.numberOfLines = 0
    }
    
    @objc
    private func buttonTapped(_ sender: UIButton) {
        if model.actions.indices.contains(sender.tag) {
            model.actions[sender.tag].action()
        }
    }
    
    private func addSubviews(_ subviews: [UIView]) {
        subviews.forEach({ self.view.addSubview($0) })
    }
}

private extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
