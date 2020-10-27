//
//  ControlViewController.swift
//  Control
//
//  Created by Влад Овсюк on 25.10.2020.
//

import UIKit
import SideMenu

final class ControlViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleDataLabel: UILabel!
    
    // MARK: - Private properties
    
    private var sideMenu: SideMenuNavigationController?
    private var addAffairViewController = UIViewController()
    
    private var affairsOnView: Bool = true
    
    // MARK: - Properties
    
    var Affair: [AffairModel] = [
        AffairModel(affairTitle: "Выгул собаки", affairTime: "8:00"),
        AffairModel(affairTitle: "Привести себя в порядок", affairTime: "9:00"),
        AffairModel(affairTitle: "Закрыть квартиру", affairTime: "9:30"),
        AffairModel(affairTitle: "Купить кофе", affairTime: "9:45"),
        AffairModel(affairTitle: "Заказать домой воду", affairTime: "10:20"),
        AffairModel(affairTitle: "Созвон", affairTime: "12:00"),
        AffairModel(affairTitle: "Поздравить Алену", affairTime: "13:00"),
        AffairModel(affairTitle: "Заказать цветы", affairTime: "13:10"),
        AffairModel(affairTitle: "Купить вино", affairTime: "18: 10")]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSideMenu()
        setDataTitle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Private metod
    
    private func setDataTitle() {
        let time = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        formatter.timeZone = TimeZone(secondsFromGMT: 2)
        let formatteddate = formatter.string(from: time as Date)
        titleDataLabel.text = "   Сегодня \(formatteddate)"
    }
    
    private func configureDelegate() {
        
    }
    
    private func configureSideMenu() {
        let storybord = UIStoryboard(name: "Control", bundle: .main)
        let menuController = storybord.instantiateViewController(identifier: "MenuTableViewController") as! MenuTableViewController
        menuController.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menuController)
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: true)
        
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    private func showAddAffairViewController() {
        let storybord = UIStoryboard(name: "SideMenu", bundle: .main)
        let addAffairViewController = storybord.instantiateViewController(identifier: "AddAffairViewController") as! AddAffairViewController
        addChild(addAffairViewController)
        view.addSubview(addAffairViewController.view)
        addAffairViewController.didMove(toParent: self)
    }
    
    private func hideChildView() {
        if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
    }
    
    // MARK: - Public metod
    
    private func didSelectMenuItem(named: Int) {
        
    }
    
    // MARK: - Action
    
    @IBAction func sideMenuTapped(_ sender: Any) {
        present(sideMenu!, animated: true)
    }
    
    @IBAction func degubBattonTapped(_ sender: Any) {
        let affairCopy: [AffairModel] = [
            AffairModel(affairTitle: "Выгул собаки", affairTime: "8:00"),
            AffairModel(affairTitle: "Привести себя в порядок", affairTime: "9:00"),
            AffairModel(affairTitle: "Закрыть квартиру", affairTime: "9:30"),
            AffairModel(affairTitle: "Купить кофе", affairTime: "9:45"),
            AffairModel(affairTitle: "Заказать домой воду", affairTime: "10:20"),
            AffairModel(affairTitle: "Созвон", affairTime: "12:00"),
            AffairModel(affairTitle: "Поздравить Алену", affairTime: "13:00"),
            AffairModel(affairTitle: "Заказать цветы", affairTime: "13:10"),
            AffairModel(affairTitle: "Купить вино", affairTime: "18: 10")]
        
        Affair.append(contentsOf: affairCopy)
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource

extension ControlViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Affair.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if Affair.count > 1 {
            
            switch indexPath.row {
            case 0:
                let firstCell = tableView.dequeueReusableCell(withIdentifier: AffairFirstCell.reusableId, for: indexPath) as! AffairFirstCell
                firstCell.configure(with: Affair[indexPath.row])
                return firstCell
                
            case Affair.endIndex - 1:
                let lastCell = tableView.dequeueReusableCell(withIdentifier: AffairLastCell.reusableId, for: indexPath) as! AffairLastCell
                lastCell.configure(with: Affair[indexPath.row])
                return lastCell
                
            default:
                let middleCell = tableView.dequeueReusableCell(withIdentifier: AffairMiddleCell.reusableId, for: indexPath) as! AffairMiddleCell
                middleCell.configure(with: Affair[indexPath.row])
                return middleCell
            }
            
        } else {
            
            let aloneCell = tableView.dequeueReusableCell(withIdentifier: AffairAloneCell.reusableId, for: indexPath) as! AffairAloneCell
            aloneCell.configure(with: Affair[indexPath.row])
            return aloneCell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Affair.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                tableView.reloadData()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}


// MARK: - MenuTableViewControllerDelegate

extension ControlViewController: MenuTableViewControllerDelegate {
    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: nil)
        
        title = named.rawValue
        switch named {
        case .myAffairs:
            hideChildView()
        
        case .addAffair:
            showAddAffairViewController()
            
        }
    }
}
