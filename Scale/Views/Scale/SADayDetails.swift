//
//  SADayDetails.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/17/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage
import BIZPopupView
class SADayDetails: UIViewController ,UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    
    var isView = true
    var date  = ""
    var TCategory :NSArray = []
    var TMeals : NSArray = []
    var TAllMeals : NSArray = []
    var maxS = ""
    var TItems :NSArray = []
    var idS = 0
   var IdArray = [Int]()
    var unSelectedMeals : NSMutableArray = []
    var SelectedMeals : NSMutableArray = []
    var TSelectedMeal : NSArray = []
    var selectedMealId = ""
    var day_id = ""
    var meal_id = ""
    var category_id = ""
    var objData: [itemdata] = []
    var objDataMael: [[AllMeal]] = []

//    var selectedCategory: AnyObject? = nil{
//        didSet{
//            self.getMealsOfSelectedCategory()
//        }
//    }
//
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
        self.GetData()

     //   self.loadDate2()
    }
    
    func GetData(){

        _ = WebRequests.setup(controller: self).prepare(query: "getCategoryMeals2?date=\(date)", method: HTTPMethod.get).start(){ (response, error) in
            do {
                let Status =  try JSONDecoder().decode(Catogries.self, from: response.data!)
                self.objData = Status.categories!
            
    
                var  i = 0
                for _ in self.objData{
                self.objDataMael.append(self.objData[i].allMeals!)
                    i = i+1
                }
                for object in self.objDataMael[self.idS]{
                    if object.selected == 1{
                        self.IdArray.append(object.id!)
                    }
                }
           self.tbl.reloadData()
            } catch let jsonErr {
                print("Error serializing  respone json", jsonErr)
            }
        }
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
        return self.objData.count
           // return 3
        }
        else
        {
           // return 3
            if objDataMael.count == 0 {
                return 0
            }
            let item = objDataMael[idS]

           return item.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.section == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            let item = objData[indexPath.row]
            cell.lblTitle.text = item.title
            let counts = objDataMael[indexPath.row]
          
            cell.lblCount.text = "\(counts.count ?? 0)"
            maxS = item.maxSelected!

            if indexPath.row == idS{
                cell.icon.isHidden = false

            }else{
            cell.icon.isHidden = true
            }
         

            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MealsCell", for: indexPath) as! MealsCell
            
            let item = objDataMael[idS]
        
            cell.lblTitle.text = item[indexPath.row].name
            self.category_id = item[indexPath.row].categoryID!
//            if item[indexPath.row].selected == 1  && !IdArray.contains(item[indexPath.row].id!){
//                IdArray.append(item[indexPath.row].id!)
//            }else{
//
//            }
            if  IdArray.contains(item[indexPath.row].id!)  {
                cell.iconDon.isHidden = false
            }else{
                cell.iconDon.isHidden = true

            }


            cell.img.sd_setImage(with: URL(string: item[indexPath.row].logo!), placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
            
            cell.btnZoom.tag = indexPath.row
            cell.btnZoom.addTarget(self, action: #selector(didZoomImg), for: .touchUpInside)
        
            
            cell.img_circle.tag = indexPath.row
          
            
//            if cell.img_circle.tag == idS{
//             cell.iconDon.isHidden = true
//            }else{
//                cell.iconDon.isHidden = false
//
//            }
            cell.img_circle.addTarget(self, action: #selector(didSelect), for: .touchUpInside)

            
            
            return cell
        }
    }
    @objc func didSelect(_ sender: UIButton){
//        let item = objDataMael[idS]
//
//
//        if  IdArray.contains( item[sender.tag].id!){
//            if let index = IdArray.index(of:item[sender.tag].id!) {
//                IdArray.remove(at: index)
//            }
//        }else{
//
//        }
        
    }
    @objc func didZoomImg(_ sender: UIButton){
        
            let smallViewController = AppDelegate.storyboard.instantiateViewController(withIdentifier: "NSZoomImg") as! NSZoomImg
        
        
        
        let item = objDataMael[idS]

        
        smallViewController.objPass3 = item[sender.tag].logo!
        
        let popupViewController = BIZPopupViewController(contentViewController: smallViewController, contentSize: CGSize(width: CGFloat(320), height: CGFloat(600)))
       
            popupViewController?.showDismissButton = true
            popupViewController?.enableBackgroundFade = true
        self.present(popupViewController!, animated: true)
        
        
       
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
            idS = indexPath.row
            for object in self.objDataMael[idS]{
                if object.selected == 1{
                    IdArray.append(object.id!)
                }
            }
            self.tbl.reloadData()

        }
        else{
            let itemdata = objData[idS]

             let item = objDataMael[idS]
            maxS = itemdata.maxSelected!
          
            if  IdArray.contains(item[indexPath.row].id!){
                if let index = IdArray.index(of:item[indexPath.row].id!) {
                    IdArray.remove(at: index)
                }
            }else{
                if IdArray.count == Int(maxS)
                {
                    self.showOkAlert(title: "Error".localized, message: "The max selected meal\(maxS)".localized)

                    return
                }
                IdArray.append(item[indexPath.row].id!)
                
            }
           
           self.tbl.reloadData()
        }
        
    }
    
    
    @IBAction func btnClose(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    


//
    @IBAction func btnSaveAction(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
//            var arrselected : [Int] = []
//
//            for index in 0..<self.SelectedMeals.count
//            {
//                let id = self.SelectedMeals.object(at: index) as! Int
//                arrselected.append(id)
//            }
            
            
            MyApi.api.editPlanMeals(date: self.date, category_id: Int(self.category_id)!, meal_id: IdArray, pause: 2)
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
