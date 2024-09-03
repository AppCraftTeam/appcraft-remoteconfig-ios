//
//  ACMessageViewControllerProtocol.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit

public protocol ACMessageViewControllerProtocol: UIViewController {
    var image: UIImage? { get set }
    var titleText: String { get set }
    var subtitleText: String { get set }

    func addActions(_ actions: [ACMessageViewController.ActionModel])
}

open class ACMessageViewController: UIViewController, ACMessageViewControllerProtocol {
    
    public enum MessagePosition {
        case top, center
    }
    
    public private(set) lazy var titleLabel = UILabel()
    public private(set) lazy var subtitleLabel = UILabel()
    
    public private(set) lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    public private(set) lazy var actionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    public var titleText: String {
        get { titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }
    
    public var titleLabelStyle = Style<UILabel>(make: { label in
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = if #available(iOS 13, *) { .label } else { .black }
    })
    
    public var subtitleText: String {
        get { subtitleLabel.text ?? "" }
        set {
            self.subtitleLabel.text = newValue
            self.setupSubtitleLabel()
        }
    }
    
    public var subTitleLabelStyle = Style<UILabel>(make: { label in
        label.font = .systemFont(ofSize: 16)
        label.textColor = if #available(iOS 13, *) { .label } else { .black }
        label.numberOfLines = 0
    })
    
    public private(set) var imageView = UIImageView()
    
    open var image: UIImage? {
        get { imageView.image }
        set {
            self.imageView.image = newValue
            self.setupImageView()
        }
    }
    
    public var contentSpacing: CGFloat {
        get { contentStackView.spacing }
        set { contentStackView.spacing = newValue }
    }
    
    public var messagePosition: MessagePosition = .top {
        didSet {
            self.setupComponents()
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupComponents()
    }
    
    func setupComponents() {
        self.view.backgroundColor = .white
        self.contentStackView.removeFromSuperview()
        self.actionsStackView.removeFromSuperview()
                
        self.addSubviews([contentStackView, actionsStackView])
        self.contentStackView.translatesAutoresizingMaskIntoConstraints = false
        self.actionsStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            actionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        self.titleLabelStyle.make(titleLabel)
        self.subTitleLabelStyle.make(subtitleLabel)

        switch messagePosition {
        case .top:
            NSLayoutConstraint.activate([
                contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            ])
        case .center:
            NSLayoutConstraint.activate([
                contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
    
    func removeAllAction() {
        self.actionsStackView.removeAllArrangedSubviews()
    }
    
    public struct ActionModel {
        let text: String
        let style: Style<UIButton>
        let action: () -> Void
    }
    
    open func addActions(_ actions: [ActionModel]) {
        for action in actions {
            let button = ActionButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.setTitle(action.text, for: .normal)
            button.onAction = action.action
            action.style.make(button)
            self.actionsStackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Setup methods
    open func setupSubtitleLabel() {
        if subtitleText.isEmpty {
            self.subtitleLabel.removeFromSuperview()
            self.contentStackView.removeArrangedSubview(subtitleLabel)
        } else {
            if subtitleLabel.superview == nil {
                self.contentStackView.addArrangedSubview(subtitleLabel)
            }
        }
    }
    
    open func setupImageView() {
        if image == nil {
            self.imageView.removeFromSuperview()
        } else {
            if imageView.superview == nil {
                self.view.addSubview(imageView)
                self.imageView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
                    imageView.topAnchor.constraint(greaterThanOrEqualTo: contentStackView.bottomAnchor, constant: 16),
                    imageView.bottomAnchor.constraint(lessThanOrEqualTo: actionsStackView.topAnchor, constant: -16),
                    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
            }
        }
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach({ self.view.addSubview($0) })
    }
}

fileprivate extension UIStackView {
    func removeAllArrangedSubviews() {
        for subview in self.arrangedSubviews {
            subview.removeFromSuperview()
        }
    }
}
