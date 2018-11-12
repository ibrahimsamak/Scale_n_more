//
//  SADayDetails.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/17/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage

class SADayDetails: UIViewController ,UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btnSave: CustomeButton!
    
    var isView = true
    var date  = ""
    var TCategory :NSArray = []
    var TMeals : NSArray = []
    var unSelectedMeals : NSMutableArray = []
    var SelectedMeals : NSMutableArray = []
    var TSelectedMeal :NSArray = []
    var selectedMealId = ""
    var day_id = ""
    var meal_id = ""
    var category_id = ""
    
    var selectedCategory: AnyObject? = nil{
        didSet{
            self.getMealsOfSelectedCategory()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        self.tbl.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        self.tbl.register(UINib(nibName: "MealsCell", bundle: nil), forCellReuseIdentifier: "MealsCell")
        
        let nib = UINib(nibName: "SACategoryHeader", bundle: nil)
        self.tbl.register(nib, forHeaderFooterViewReuseIdentifier: "SACategoryHeader")
        
        if(isView){
            self.btnSave.isHidden = true
        }
        else{
            self.btnSave.isHidden = false
        }
        
        self.loadDate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 37.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SACategoryHeader") as! SACategoryHeader
        
        if(section == 0)
        {
            if(isView){
                cell.titleLabel.text = "Select Category".localized
            }
            else{
                cell.titleLabel.text = "Category".localized
            }
        }
        else{
            cell.titleLabel.text = "Meals Available".localized
        }
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(section == 0)
        {
            return self.TCategory.count
            
        }
        else
        {
            return self.TSelectedMeal.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.section == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            let conent = self.TCategory.object(at:indexPath.row) as AnyObject
            let title = conent.value(forKey: "title") as! String
            let count =  conent.value(forKey: "count_meal") as! Int
            let selecetedid = self.selectedCategory?.value(forKey: "id") as! Int
            let id =  conent.value(forKey: "id") as! Int
            cell.icon.isHidden = (selecetedid != id)
            cell.lblTitle.text = title
            cell.lblCount.text = String(count)

            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MealsCell", for: indexPath) as! MealsCell
            let conent = self.TSelectedMeal.object(at:indexPath.row) as AnyObject
            let title = conent.value(forKey: "name") as! String
            let category_id = conent.value(forKey: "category_id") as! String
            let id = conent.value(forKey: "id") as! String
            let logo = conent.value(forKey: "logo") as? String ?? ""
            let prefix = "http://scalenmore.com/"
         
            cell.lblTitle.text = title
            cell.img.sd_setImage(with: URL(string: prefix+logo), placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
          
            self.category_id = category_id
            self.meal_id = id
            
            if(isView)
            {
                cell.img_circle.isHidden = true
                cell.iconDon.isHidden = true
            }
            else
            {
                if(self.unSelectedMeals.contains(Int(id)))
                {
                    cell.img_circle.isHidden = false
                    cell.iconDon.isHidden = true
                }
                else
                {
                    cell.img_circle.isHidden = false
                    cell.iconDon.isHidden = false
                }
                
//                if(self.selectedMealId != id)
//                {
//                    cell.img_circle.isHidden = false
//                    cell.iconDon.isHidden = false
//                }else{
//                    cell.img_circle.isHidden = false
//                    cell.iconDon.isHidden = true
//                }
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.section == 0)
        {
            return 70.0
        }
        else{
            return 90.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.section == 0)
        {
            let content = self.TCategory.object(at:indexPath.row) as AnyObject
            self.selectedCategory = content
        }
        else{
            if(!isView)
            {
                let content = self.TSelectedMeal.object(at:indexPath.row) as AnyObject
                let id = content.value(forKey: "id") as! String
                
                
                if(self.SelectedMeals.contains(Int(id)))
                {
                    //exsist meal
                    self.SelectedMeals.remove(Int(id))
                    self.unSelectedMeals.add(Int(id))
                }
                else{
                    self.unSelectedMeals.remove(Int(id))
                    self.SelectedMeals.add(Int(id))
                }
                self.selectedMealId = id
                print("selected items:\(self.SelectedMeals)")
                print("unselected items:\(self.unSelectedMeals)")
                self.tbl.reloadData()
            }
        }
    }
    
    
    @IBAction func btnClose(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadDate()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.getCategoryMeals(date: self.date){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            self.hideIndicator()
                            
                            let items = JSON["items"] as! NSDictionary
                            self.TCategory = items.value(forKey: "categories") as! NSArray
                            self.TMeals = items.value(forKey: "meals") as! NSArray
                            
                            let conent = self.TCategory.firstObject as AnyObject
                            self.selectedCategory  = conent
                            
                            self.tbl.delegate = self
                            self.tbl.dataSource = self
                            self.tbl.reloadData()
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
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
    func getMealsOfSelectedCategory()
    {
        self.TSelectedMeal = self.TMeals.filter { (obj) -> Bool in
            let object = obj as AnyObject
            let category_id = object.value(forKey: "category_id") as! String
            self.SelectedMeals = []
            return category_id == String(self.selectedCategory?.value(forKey: "id") as! Int)
            } as NSArray
        
        self.SelectedMeals = []
        for index in 0..<self.TSelectedMeal.count
        {
            let conent = self.TSelectedMeal.object(at:index) as AnyObject
            let id = conent.value(forKey: "id") as! String
            let mealID = Int(id)
            self.SelectedMeals.add(mealID!)
        }
        
        self.tbl.reloadData()
    }
    
    @IBAction func btnSaveAction(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            var arrselected : [Int] = []
            
            for index in 0..<self.SelectedMeals.count
            {
                let id = self.SelectedMeals.object(at: index) as! Int
                arrselected.append(id)
            }
            
            
            MyApi.api.editPlanMeals(date: self.date, category_id: Int(self.category_id)!, meal_id: arrselected, pause: 0)
            { (response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let  status = JSON["status"] as? Int
                        if (status == 1)
                        {
                            self.hideIndicator()
                            self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as? String ?? "", completion: { (success) in
                                if(success)
                                {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                        }
                        else
                        {
                            self.hideIndicator()
                            self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                        }
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
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
}
