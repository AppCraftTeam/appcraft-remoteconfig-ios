//
//  ACMessageViewControllerProtocol.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit

// Protocol defining the required interface for a message view controller
public protocol ACMessageViewControllerProtocol: UIViewController {
    // The image that can be displayed in the view
    var image: UIImage? { get set }
    
    // The main title text of the view
    var titleText: String { get set }
    
    // The subtitle text of the view
    var subtitleText: String { get set }
    
    // Add action buttons to the view controller
    // Parameters:
    // - actions: An array of button actions
    func addActions(_ actions: [ACMessageViewController.ActionModel])
}

// A customizable message view controller that conforms to `ACMessageViewControllerProtocol
open class ACMessageViewController: UIViewController, ACMessageViewControllerProtocol {
    
    public var model: ACMessageViewModel?
    
    
    // A button action with a text, style, and tap closure.
    public struct ActionModel {
        let text: String
        let action: () -> Void
        
        public init(text: String, action: @escaping () -> Void) {
            self.text = text
            self.action = action
        }
    }
    
    // Enum to define where the message content should be displayed
    public enum MessagePosition {
        case top, center
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
            self.subtitleLabel.text = newValue
            self.setupSubtitleLabel()
        }
    }

    // Icon image view
    public private(set) var imageView = UIImageView()
    
    // View image
    open var image: UIImage? {
        get { imageView.image }
        set {
            self.imageView.image = newValue
            self.setupImageView()
        }
    }
    
    // Configure the spacing between the content stack view elements.
    public var contentSpacing: CGFloat {
        get { contentStackView.spacing }
        set { contentStackView.spacing = newValue }
    }
    
    // Controls the message components position
    public var messagePosition: ACMessageViewController.MessagePosition = .top {
        didSet {
            self.setupComponents()
        }
    }
        
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupComponents()
        self.addActions(model?.actions ?? [])
    }
    
    // Sets up the UI components
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
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        titleLabel.textColor = if #available(iOS 13, *) { .label } else { .black }
        
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = if #available(iOS 13, *) { .label } else { .black }
        subtitleLabel.numberOfLines = 0
        
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
    
    // Removes all action buttons
    func removeAllAction() {
        self.actionsStackView.removeAllArrangedSubviews()
    }
    
    // Adds an array of action buttons to the stack view
    open func addActions(_ actions: [ACMessageViewController.ActionModel]) {
        model?.actions = actions
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
    
    // MARK: - Setup methods
    
    // Configures the subtitle label
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
    
    // Configures the image view
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
    
    // Add an array of subviews to the view.
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach({ self.view.addSubview($0) })
    }
    
    
    @objc
    private func buttonTapped(_ sender: UIButton) {
        if ((model?.actions.indices.contains(sender.tag)) != nil) {
            model?.actions[sender.tag].action()
        }
    }
}

private extension UIStackView {
    func removeAllArrangedSubviews() {
        for subview in self.arrangedSubviews {
            subview.removeFromSuperview()
        }
    }
}
