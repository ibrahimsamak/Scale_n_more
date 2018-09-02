//
//  SAPlan.swift
//  Scale

//  Created by ibrahim M. samak on 8/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.


import UIKit
import ActionCell

class SAPlan: UIViewController, UITableViewDelegate , UITableViewDataSource , ActionCellDelegate {
    
    public func didActionTriggered(cell: UITableViewCell, action: String)
    {
        let xCell = cell as! PlanCell
        let indexpath = self.tableView.indexPath(for: xCell)
        let content = self.TItems.object(at: (indexpath?.row)!) as AnyObject
        let name = content.value(forKey: "name") as! String
        let id = content.value(forKey: "id") as! Int
        let plan_daysArr =  content.value(forKey: "plan_days") as! NSArray
        if(action == "deleteAction")
        {
            print("delete")
            self.showCustomAlert(okFlag: false, title: "Warning".localized, message: "Are you sure you want to delete plan?".localized, okTitle: "Delete".localized, cancelTitle: "Cancel".localized)
            {(success) in
                if(success)
                {
                    self.delete(planID:id)
                }
            }
        }
        else
        {
            print("Edit")
            self.Edit(planID: id, name: name,DaysArr: plan_daysArr.mutableCopy() as! NSMutableArray)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var TItems :NSArray = []
    var id = 0
    var planName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "PlanCell", bundle: nil), forCellReuseIdentifier: "PlanCell")
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.TItems = []
        self.loadDate()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.TItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! PlanCell
        var days = ""
        let content = self.TItems.object(at: indexPath.row) as AnyObject
        let name = content.value(forKey: "name") as! String
        let id = content.value(forKey: "id") as! Int
        let dayNameArr = content.value(forKey: "plan_days") as! NSArray
        
        for index in 0..<dayNameArr.count
        {
            let cont = dayNameArr.object(at: index) as AnyObject
            let n  = cont.value(forKey: "day_name") as! String
            days = days+n+", "
        }
        
        
        let dayName =  content.value(forKey: "plan_days") as! NSArray
        
        cell.lblDay.text = days
        cell.lblPlanName.text = name
        
        let wrapper = ActionCell()
        wrapper.delegate = self
        wrapper.animationStyle = .concurrent
        wrapper.wrap(cell: cell,
                     actionsLeft: [],
                     actionsRight:[
                        {
                            let action = IconAction(action: "deleteAction")
                            action.icon.image  = #imageLiteral(resourceName: "DeleteCell")
                            action.icon.tintColor = UIColor.white
                            action.backgroundColor = UIColor.clear
                            self.id = id
                            return action
                        }(),
                        {
                            let action = IconAction(action: "editAction")
                            action.icon.image = #imageLiteral(resourceName: "EditCell")
                            action.icon.tintColor = UIColor.white
                            action.backgroundColor = UIColor.clear
                            self.id = id
                            self.planName = name
                            return action
                        }(),
                        ])
        return cell
    }
    
    func cellButtonClicked()
    {
        print("cell button clicked")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let content = self.TItems.object(at: indexPath.row) as AnyObject
        let name = content.value(forKey: "name") as! String
        let id = content.value(forKey: "id") as! Int
        let vc:SAPreviewPlan = AppDelegate.storyboard.instanceVC()
        vc.plainId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    
    func loadDate()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetPans(){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            self.hideIndicator()
                            
                            let items = JSON["items"] as! NSArray
                            self.TItems = items
                            
                            self.tableView.delegate = self
                            self.tableView.dataSource = self
                            self.tableView.reloadData()
                        }
                        else
                        {
                            self.hideIndicator()
                            self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                            
                        }
                    }
                    else
                    {
                        self.hideIndicator()
                        self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                    }
                    
                }
                else
                {
                    self.hideIndicator()
                    self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                }
            }
        }
        else
        {
            self.showOkAlert(title: "Error", message: "No Internet Connection")
        }
    }
    
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    
    func delete(planID:Int)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.DeletePlan(PlanID: planID)
            { (response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let  status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            self.hideIndicator()
                            self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as? String ?? "", completion: { (suc) in
                                if(suc)
                                {
                                    self.loadDate()
                                }
                            })
                        }
                        else
                        {
                            self.hideIndicator()
                            self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                        }
                        self.hideIndicator()
                    }
                }
                else
                {
                    self.hideIndicator()
                    self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                }
            }
        }
        else
        {
            self.showOkAlert(title: "Error", message: "No Internet Connection")
        }
    }
    
    func Edit(planID:Int , name:String , DaysArr:NSMutableArray)
    {
        let vc :SAAddPlan = AppDelegate.storyboard.instanceVC()
        vc.name = name
        vc.id = planID
//        vc.TItems = DaysArr
        vc.isEdit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
