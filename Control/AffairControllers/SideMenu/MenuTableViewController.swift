//
//  MenuTableViewController.swift
//  Control
//
//  Created by Влад Овсюк on 25.10.2020.
//

import UIKit

protocol MenuTableViewControllerDelegate: class {
    func didSelectMenuItem(named: SideMenuItem)
}

class MenuTableViewController: UITableViewController {
    
    // MARK: - Private Properties
    
    private var menuItems: [SideMenuItem] = [SideMenuItem.myAffairs, SideMenuItem.forework, SideMenuItem.setting]
    
    private var selectedCell: UITableViewCell?
    
    // MARK: - View Controller Delegate
    
    weak var delegate: MenuTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeSwitched()
        ThemeHelper.theme.configureTheme()
    }
    
    // MARK: - Dark Mode Switche
    
    private func darkModeSwitched() {
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    @objc private func darkModeEnabled(_ notification: Notification) {
        overrideUserInterfaceStyle = .dark
    }

    @objc private func darkModeDisabled(_ notification: Notification) {
        overrideUserInterfaceStyle = .light
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = menuItems[indexPath.row]
        delegate?.didSelectMenuItem(named: selectedItem)
    }
}
