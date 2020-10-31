//
//  ControlViewController.swift
//  Control
//
//  Created by Влад Овсюк on 25.10.2020.
//

import UIKit
import SideMenu

final class ControlViewController: UIViewController {
    
    // MARK: - Date
    
    var numberCollectionViewCell: [DeteModel] = []
    var test: [Int] = []
    
    func numberOfMondaysInMonth(month: Int, year: Int) {
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month

        let calendar = NSCalendar.current
        let date = calendar.date(from: dateComponents as DateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let range1 = calendar.component(.weekday, from: date)
        
        var weekday = range1
        for day in range {
            numberCollectionViewCell.append(DeteModel(dayOfWeek: weekday, numberOfWeek: day))
            if weekday == 7 {
                weekday = 1
            } else {
                weekday += 1
            }
        }
    }
    
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var titleDateLabel: UILabel!
    
    // MARK: - Private properties
    
    private var sideMenu: SideMenuNavigationController?
    private var addAffairViewController = UIViewController()
    
    private var affairsOnView: Bool = true
    
    // MARK: - Properties
    
    var affair: [AffairModel] = [
        AffairModel(affairTitle: "Выгул собаки", affairDescription: "Взять пакеты", affairTime: "8:00", affaitIsDone: false),
        AffairModel(affairTitle: "Привести себя в порядок", affairDescription: "Паста RDA 150", affairTime: "9:00", affaitIsDone: false),
        AffairModel(affairTitle: "Закрыть квартиру", affairDescription: "Оставить ключ на вахте", affairTime: "9:30", affaitIsDone: false),
        AffairModel(affairTitle: "Купить кофе", affairDescription: "Латте без сахара", affairTime: "9:45", affaitIsDone: false),
        AffairModel(affairTitle: "Заказать домой воду", affairDescription: "Попросить оставить на входе", affairTime: "10:20", affaitIsDone: false),
        AffairModel(affairTitle: "Созвон", affairDescription: "Успеть до дедлайна", affairTime: "12:00", affaitIsDone: false),
        AffairModel(affairTitle: "Поздравить Алену", affairDescription: "Пожалуйста не забудь", affairTime: "13:00", affaitIsDone: false),
        AffairModel(affairTitle: "Заказать цветы", affairDescription: "51 роза", affairTime: "13:10", affaitIsDone: false),
        AffairModel(affairTitle: "Купить вино", affairDescription: "Красное полусладкое", affairTime: "18: 10", affaitIsDone: false)]
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSideMenu()
        
        numberOfMondaysInMonth(month: 11, year: 2020)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDateTitle()
    }
    
    // MARK: - Private metod
    
    private func setDateTitle() {
        let time = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 2)
        formatter.locale = Locale(identifier: "ru")
        let formatteddate = formatter.string(from: time as Date)
        titleDateLabel.text = formatteddate
    }
    
    private func configureSideMenu() {
        let storybord = UIStoryboard(name: "Control", bundle: .main)
        let menuController = storybord.instantiateViewController(identifier: "MenuTableViewController") as! MenuTableViewController
        menuController.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menuController)
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: true)
    }
    
    private func showAddAffairViewController() {
        let storybord = UIStoryboard(name: "SideMenu", bundle: .main)
        let addAffairViewController = storybord.instantiateViewController(identifier: "AddAffairViewController") as! AddAffairViewController
        addChild(addAffairViewController)
        view.addSubview(addAffairViewController.view)
        addAffairViewController.didMove(toParent: self)
    }
    
    private func showSettingViewController() {
        let storybord = UIStoryboard(name: "SideMenu", bundle: .main)
        let addAffairViewController = storybord.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
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

    // MARK: - Action
    
    @IBAction func sideMenuTapped(_ sender: Any) {
        present(sideMenu!, animated: true)
    }
    
    @IBAction func degubBattonTapped(_ sender: Any) {
        tableView.reloadData()
        print("Table view has been reloaded")
    }
    
    @IBSegueAction func selectedListSegue(_ coder: NSCoder) -> SelectedAffair? {
        let controller = SelectedAffair(coder: coder)
        return controller
    }
}

// MARK: - UITableViewDataSource

extension ControlViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        affair.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if affair.count > 1 {
//
//            switch indexPath.row {
//            case 0:
//                let firstCell = tableView.dequeueReusableCell(withIdentifier: AffairFirstCell.reusableId, for: indexPath) as! AffairFirstCell
//                firstCell.configure(with: affair[indexPath.row])
//                return firstCell
//
//            case affair.endIndex - 1:
//                let lastCell = tableView.dequeueReusableCell(withIdentifier: AffairLastCell.reusableId, for: indexPath) as! AffairLastCell
//                lastCell.configure(with: affair[indexPath.row])
//                return lastCell
//
//            default:
//                let middleCell = tableView.dequeueReusableCell(withIdentifier: AffairMiddleCell.reusableId, for: indexPath) as! AffairMiddleCell
//                middleCell.configure(with: affair[indexPath.row])
//                return middleCell
//            }
//
//        } else {
//
//            let aloneCell = tableView.dequeueReusableCell(withIdentifier: AffairAloneCell.reusableId, for: indexPath) as! AffairAloneCell
//            aloneCell.configure(with: affair[indexPath.row])
//            return aloneCell
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AffairFirstCell.reusableId, for: indexPath) as! AffairFirstCell
        cell.configure(with: affair[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            affair.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                tableView.reloadData()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if affair[indexPath.row].affaitIsDone == false {
            affair[indexPath.row] = .init(affairTitle: affair[indexPath.row].affairTitle, affairDescription: affair[indexPath.row].affairDescription, affairTime: affair[indexPath.row].affairTime, affaitIsDone: true)
            tableView.reloadData()
        } else {
            affair[indexPath.row] = .init(affairTitle: affair[indexPath.row].affairTitle, affairDescription: affair[indexPath.row].affairDescription, affairTime: affair[indexPath.row].affairTime, affaitIsDone: false)
            tableView.reloadData()
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension ControlViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberCollectionViewCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AffairCollectionViewCell.reusableId, for: indexPath) as! AffairCollectionViewCell
        cell.configure(with: numberCollectionViewCell[indexPath.row])
        return cell
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
            hideChildView()
            showAddAffairViewController()
            
        case .setting:
            hideChildView()
            showSettingViewController()
        }
    }
}
