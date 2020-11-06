//
//  Delegate.swift
//  Control
//
//  Created by Влад Овсюк on 02.11.2020.
//

extension ControlViewController: MenuTableViewControllerDelegate {
    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: nil)
        
        title = named.rawValue
        switch named {
        case .myAffairs:
            hideChildView()
        case .setting:
            hideChildView()
            showSettingViewController()
        }
    }
}

extension ControlViewController: AffairCellDelegate {
    func didSelect(affair: Affair) {
        saveSelectAffairSegue(affair: affair)
        performSegue(withIdentifier: "SelectedAffairTapped", sender: self)
    }
}
