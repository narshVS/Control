//
//  ControlViewController.swift
//  Control
//
//  Created by Влад Овсюк on 25.10.2020.
//

import UIKit
import SideMenu

final class ControlViewController: UIViewController {
    
    var menu: SideMenuNavigationController?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleDataLabel: UILabel!
    
    var deed: [DeedModel] = [
        DeedModel(deedTitle: "Выгул собаки", deedTime: "8:00"),
        DeedModel(deedTitle: "Привести себя в порядок", deedTime: "9:00"),
        DeedModel(deedTitle: "Закрыть квартиру", deedTime: "9:30"),
        DeedModel(deedTitle: "Купить кофе", deedTime: "9:45")]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureSideMenu()
        setDataTitle()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        titleDataLabel.text = "Сегодня \(formatteddate)"
    }
    
    private func configureSideMenu() {
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: true)
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    // MARK: - Action
    
    @IBAction func Test(_ sender: Any) {
        present(menu!, animated: true)
    }
    
    @IBAction func degubBattonTapped(_ sender: Any) {
        let deedCopy: [DeedModel] = [
            DeedModel(deedTitle: "Выгул собаки", deedTime: "8:00"),
            DeedModel(deedTitle: "Привести себя в порядок", deedTime: "9:00"),
            DeedModel(deedTitle: "Закрыть квартиру", deedTime: "9:30"),
            DeedModel(deedTitle: "Купить кофе", deedTime: "9:45")]
        deed.append(contentsOf: deedCopy)
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource

extension ControlViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        deed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if deed.count > 1 {
            
            switch indexPath.row {
            case 0:
                let firstCell = tableView.dequeueReusableCell(withIdentifier: DeedFirstCell.reusableId, for: indexPath) as! DeedFirstCell
                firstCell.configure(with: deed[indexPath.row])
                return firstCell
            
            case deed.endIndex - 1:
                let lastCell = tableView.dequeueReusableCell(withIdentifier: DeedLastCell.reusableId, for: indexPath) as! DeedLastCell
                lastCell.configure(with: deed[indexPath.row])
                return lastCell
            
            default:
                let middleCell = tableView.dequeueReusableCell(withIdentifier: DeedMiddleCell.reusableId, for: indexPath) as! DeedMiddleCell
                middleCell.configure(with: deed[indexPath.row])
                return middleCell
            }
            
        } else {
            
            let aloneCell = tableView.dequeueReusableCell(withIdentifier: DeedAloneCell.reusableId, for: indexPath) as! DeedAloneCell
            aloneCell.configure(with: deed[indexPath.row])
            return aloneCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                deed.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    tableView.reloadData()
                })
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deed.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                tableView.reloadData()
            })
        }
    }
    
    //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let headerView = UIView()
    //        headerView.backgroundColor = UIColor.clear
    //        return headerView
    //    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
