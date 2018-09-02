//
//  SAAddPlane.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/14/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import ActionCell

class SAAddPlan: UIViewController,UITableViewDelegate , UITableViewDataSource,  ActionCellDelegate {
    
    public func didActionTriggered(cell: UITableViewCell, action: String)
    {
        let xCell = cell as! PlanCell
        let indexpath = self.tableView.indexPath(for: xCell)
        let content = self.TItems.object(at: (indexpath?.row)!) as AnyObject
        let day_name = content.value(forKey: "day_name") as! String
        let note = content.value(forKey: "note") as! String
        let id = content.value(forKey: "id") as! Int
        let day_id = content.value(forKey: "day_id") as! String
        let vedio_obj = content.value(forKey: "plan_vedios") as! NSArray
        
        
        if(action == "deleteAction")
        {
            print("delete")
            self.showCustomAlert(okFlag: false, title: "Warning".localized, message: "Are you sure you want to delete day?".localized, okTitle: "Delete".localized, cancelTitle: "Cancel".localized)
            {(success) in
                if(success)
                {
                    self.delete(ID:id,at:(indexpath?.row)!)
                }
            }
        }
        else
        {
            print("Edit")
            self.Edit(planID: self.id, dayName: day_name, plan_day_id: id, note: note, dayId: Int(day_id)!,videoArr:content , obj:self.TItems,index:(indexpath?.row)!)
        }
    }
    
    
    
    
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtPlan: UITextField!
    var name = ""
    var id = 0
    var isEdit = false
    var TItems :NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(isEdit){
            self.txtPlan.text = name
            self.btnsave.isHidden = false
        }
        self.tableView.register(UINib(nibName: "PlanCell", bundle: nil), forCellReuseIdentifier: "PlanCell")
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if(self.id != 0)
        {
            self.TItems.removeAllObjects()
            self.loadData()
            self.tableView.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnAdd(_ sender: UIButton)
    {
        if(isEdit)
        {
            let vc:SAPlanDetailsNew = AppDelegate.storyboard.instanceVC()
            vc.planName = self.txtPlan.text!
            vc.PlanID = self.id
            vc.planDetailsType = .edit
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            if(txtPlan.text?.count == 0)
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter plan name".localized)
            }
            else{
                let vc:SAPlanDetailsNew = AppDelegate.storyboard.instanceVC()
                vc.planName = self.txtPlan.text!
                vc.planDetailsType = .add
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    
    func Edit()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.postEditPlan(plan_id: self.id, name: self.txtPlan.text!)
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
                                    self.loadData()
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.TItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! PlanCell
        let content = self.TItems.object(at: indexPath.row) as AnyObject
        let name = content.value(forKey: "day_name") as! String
        let id = content.value(forKey: "id") as! Int
        let note = content.value(forKey: "note") as! String
        
        
        cell.lblDay.text = note
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
                            return action
                        }(),
                        {
                            let action = IconAction(action: "editAction")
                            action.icon.image = #imageLiteral(resourceName: "EditCell")
                            action.icon.tintColor = UIColor.white
                            action.backgroundColor = UIColor.clear
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
        //        let content = self.TItems.object(at: indexPath.row) as AnyObject
        //        let name = content.value(forKey: "name") as! String
        //        let id = content.value(forKey: "id") as! Int
        print(id)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    func delete(ID:Int,at:Int)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.DeleteDay(ID: ID)
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
                                    self.TItems.removeObject(at:at)
                                    self.loadData()
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
    
    func Edit(planID:Int , dayName:String ,plan_day_id:Int , note:String  , dayId:Int , videoArr:AnyObject , obj:NSArray , index:Int )
    {
        let vc :SAPlanDetailsNew = AppDelegate.storyboard.instanceVC()
        vc.PlanID = planID
        vc.planName = self.txtPlan.text!
        vc.currentDayObjectTemp = videoArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSave(_ sender: UIButton)
    {
        self.Edit()
    }
    
    func loadData(){
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetPlanDays(plan_id: self.id)
            { (response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let  status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            self.hideIndicator()
                            self.TItems = (JSON["items"] as! NSArray).mutableCopy() as! NSMutableArray
                            
                            self.tableView.delegate = self
                            self.tableView.dataSource = self
                            self.tableView.reloadData()
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
}
