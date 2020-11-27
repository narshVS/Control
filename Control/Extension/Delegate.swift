//
//  Delegate.swift
//  Control
//
//  Created by Влад Овсюк on 02.11.2020.
//

extension ControlViewController: MenuTableViewControllerDelegate {
    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: nil)
        switch named {
        case .myAffairs:
            configureTheme()
            configureLogo()
            hideChildView()
            configureAfterUnwind()
        case .forework:
            hideChildView()
            showSettingViewController()
        case .setting:
            hideChildView()
            showForewordViewController()
        }
    }
}

extension ControlViewController: AffairCellDelegate {
    func didSelect(affair: Affair) {
        saveSelectAffairForSegue(affair: affair)
    }
}
