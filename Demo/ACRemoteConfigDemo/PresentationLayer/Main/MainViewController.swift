//
//  MainViewController.swift
//  ACRemoteConfigDemo
//
//  Created by Дмитрий Поляков on 24.11.2021.
//

import UIKit

final class MainViewController: UIViewController {
    
    var model: MainViewModel = MainViewModel()
    
    // MARK: - UI components
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()
    
    lazy var sourceButton: UIButton = {
        var menuItems: [UIAction] = model.sources.reversed().map({ source in
            UIAction(title: source.title, handler: { (_) in
                self.model.currentSource = source
                self.sourceButton.setTitle(source.title, for: [])
            })
        })

        var menu: UIMenu {
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        let button = UIButton()
        button.setTitle(model.currentSource.title, for: [])
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: [])

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ACRemoteConfigDemo"
        self.view.backgroundColor = .systemGroupedBackground
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.backgroundColor = .systemGroupedBackground
        
        self.view.addSubview(tableView)
        self.view.addSubview(sourceButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: sourceButton.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sourceButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            sourceButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            sourceButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            sourceButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        tableView.reloadData()
        
        model.onReadyVerifiedConfig = { [weak self] configModel in
            guard let self else {
                return
            }
            self.model.verifyConfig(on: self, configModel: configModel)
        }
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        let rule = model.options[indexPath.row]
        
        cell.textLabel?.text = rule.title
        cell.detailTextLabel?.text = rule.subtitle
        cell.detailTextLabel?.textColor = .gray
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = model.options[indexPath.row]
        model.handleOption(option)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
