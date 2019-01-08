//
//  DayCell.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource,UIScrollViewDelegate {
    
    @IBOutlet weak var col: UICollectionView!
    var customeVC : UIViewController =  UIViewController()
    var daysObj : [Int:String] = [:]
    var customVc :SAPlanDetails = SAPlanDetails()
    var selectedCategory : NSMutableArray = []
    var isEdit = false
    var editMode = false
    var dayId = 0
    var tbl : UITableView = UITableView.init()
    var obj : NSArray = []
    var videos : NSArray = []
    var daysarr : [Int] = []
    var index = 0
    var localplan_day_id = 0
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
    
    func config()
    {
        self.col.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        self.col.register(UINib(nibName: "DayCollection", bundle: nil), forCellWithReuseIdentifier: "DayCollection")
        
        self.col.dataSource = self
        self.col.delegate = self
        self.col.reloadData()
        
        if(self.isEdit)
        {
            self.selectedCategory.add(dayId)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return daysObj.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCollection", for: indexPath) as! DayCollection
        let index = indexPath.row+1
        let title = self.daysObj[index]
        cell.lbl.text = title
        
        
        if (self.selectedCategory.contains(index))
        {
            cell.isSelected = true
            cell.view.layer.cornerRadius = 22.5
            cell.view.layer.masksToBounds = true
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = UIColor.white.cgColor
        }
        else{
            cell.isSelected = false
            cell.view.layer.cornerRadius = 22.5
            cell.view.layer.masksToBounds = true
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = "9AC25B".color.cgColor
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 120, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as! DayCollection
        
        let id = indexPath.row + 1
            self.selectedCategory.removeAllObjects()
            if (!selectedCategory.contains(id))
            {
                self.selectedCategory.add(id)
                cell.view.layer.cornerRadius = 22.5
                cell.view.layer.masksToBounds = true
                cell.view.layer.borderWidth = 1
                cell.view.layer.borderColor = UIColor.white.cgColor
            }
            else
            {
                self.selectedCategory.remove(id)
                self.selectedCategory.add(id)
                cell.view.layer.cornerRadius = 22.5
                cell.view.layer.masksToBounds = true
                cell.view.layer.borderWidth = 1
                cell.view.layer.borderColor = "9AC25B".color.cgColor
            }
        
        self.col.reloadData()

        let index = indexPath.row+1
        
        if(self.obj.count > 0)
        {
            let contains = self.daysarr.contains(where: { $0 == index })
            if(contains)
            {
                let index_arr = daysarr.index(where: { (item) -> Bool in
                    item == index
                })
                let content = self.obj.object(at: self.index) as AnyObject
                let videos = content.value(forKey: "plan_vedios") as! NSArray
                if(videos.count > 0)
                {
                    self.localplan_day_id = content.value(forKey: "id") as! Int
                    self.customVc.plan_day_id = self.localplan_day_id
                    self.customVc.videos = videos.mutableCopy() as! NSMutableArray

                    self.customVc.isSelectedDay = false
                    let dayName = content.value(forKey: "day_name") as? String ?? ""
                    let dayNote = content.value(forKey: "note") as? String ?? ""
                    
                    let tblindexpath = IndexPath(row: 1, section: 0)
                    let tblCell = self.tbl.cellForRow(at: tblindexpath) as! txtDaycell
                    tblCell.txtDay.text = dayName
                    
                    let tblindexpath2 = IndexPath(row: 2, section: 0)
                    let tblCell2 = self.tbl.cellForRow(at: tblindexpath2) as! txtExcersise
                    tblCell2.txtMsg.text = dayNote
                    
                    self.customVc.tableView.delegate = self.customVc
                    self.customVc.tableView.dataSource = self.customVc
                    self.customVc.tableView.reloadData()
                }
                else{
//                    self.customVc.plan_day_id = 0
                    self.customVc.videos = []
                    self.customVc.isSelectedDay = true
                    if(self.isEdit == false)
                    {
                        self.customVc.plan_day_id = 0
                    }
                    else
                    {
                        self.customVc.plan_day_id = self.localplan_day_id
                    }
                    let tblindexpath = IndexPath(row: 1, section: 0)
                    let tblCell = self.tbl.cellForRow(at: tblindexpath) as! txtDaycell
                    tblCell.txtDay.text = ""
                    
                    let tblindexpath2 = IndexPath(row: 2, section: 0)
                    let tblCell2 = self.tbl.cellForRow(at: tblindexpath2) as! txtExcersise
                    tblCell2.txtMsg.text = ""
                    
                    self.customVc.tableView.delegate = self.customVc
                    self.customVc.tableView.dataSource = self.customVc
                    self.customVc.tableView.reloadData()
                }
            }
            else
            {
//                self.customVc.plan_day_id = 0
                self.customVc.videos = []
                self.customVc.isSelectedDay = true
                if(self.isEdit == false)
                {
                    self.customVc.plan_day_id = 0
                }
                else{
                    self.customVc.plan_day_id = self.localplan_day_id

                }
                let tblindexpath = IndexPath(row: 1, section: 0)
                let tblCell = self.tbl.cellForRow(at: tblindexpath) as! txtDaycell
                tblCell.txtDay.text = ""
                
                let tblindexpath2 = IndexPath(row: 2, section: 0)
                let tblCell2 = self.tbl.cellForRow(at: tblindexpath2) as! txtExcersise
                tblCell2.txtMsg.text = ""
                self.customVc.tableView.delegate = self.customVc
                self.customVc.tableView.dataSource = self.customVc
                self.customVc.tableView.reloadData()
            }
        }
        else
        {
//            self.customVc.plan_day_id = 0
            self.customVc.videos = []
            self.customVc.isSelectedDay = true
            if(self.isEdit == false)
            {
                self.customVc.plan_day_id = 0
            }
            else{
                self.customVc.plan_day_id = self.localplan_day_id
            }
            let tblindexpath = IndexPath(row: 1, section: 0)
            let tblCell = self.tbl.cellForRow(at: tblindexpath) as! txtDaycell
            tblCell.txtDay.text = ""
            
            let tblindexpath2 = IndexPath(row: 2, section: 0)
            let tblCell2 = self.tbl.cellForRow(at: tblindexpath2) as! txtExcersise
            tblCell2.txtMsg.text = ""
            
            self.customVc.tableView.delegate = self.customVc
            self.customVc.tableView.dataSource = self.customVc
            self.customVc.tableView.reloadData()
        }

        UserDefaults.standard.set(indexPath.row+1, forKey: "LastDayChoose")

    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}

