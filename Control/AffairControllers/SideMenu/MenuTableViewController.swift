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
    private let userDefaults = UserDefaults.standard
    
    // MARK: - View Controller Delegate
    
    weak var delegate: MenuTableViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureTheme()
    }
    
    // MARK: - Private metod
    
    private func configureTheme() {
        if userDefaults.bool(forKey: "themeSwitchWasPressed") == true {
            userDefaults.bool(forKey: "darkModeIsOn") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        }
        
        if userDefaults.bool(forKey: "themeIsReset") == true {
            userDefaults.bool(forKey: "systemThemeIsDark") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = menuItems[indexPath.row]
        delegate?.didSelectMenuItem(named: selectedItem)
    }
}
