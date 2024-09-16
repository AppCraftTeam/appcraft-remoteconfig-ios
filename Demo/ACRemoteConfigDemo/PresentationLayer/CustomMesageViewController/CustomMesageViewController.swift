//
//  CustomMesageViewController.swift
//  ACRemoteConfigDemo
//
//  Created by Pavel Moslienko on 12.09.2024.
//

import ACRemoteConfig
import UIKit

final class CustomMesageViewController: ACMessageViewController {
    
    override func decorate() {
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = if #available(iOS 13, *) { .label } else { .black }
        
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = if #available(iOS 13, *) { .label } else { .black }
        subtitleLabel.numberOfLines = 0
        
        view.backgroundColor = .white
        
        actionsStackView.arrangedSubviews.filter({ $0 is UIButton }).forEach({
            ($0 as? UIButton)?.backgroundColor = .systemBlue
            ($0 as? UIButton)?.setTitleColor(.white, for: [])
            ($0 as? UIButton)?.layer.cornerRadius = 10
        })
    }
}
