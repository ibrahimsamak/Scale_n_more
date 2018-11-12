//
//  DayCell.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class PreviewDayCell: UITableViewCell, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource,UIScrollViewDelegate {
    
    @IBOutlet weak var col: UICollectionView!
    var customeVC : UIViewController =  UIViewController()
    var daysObj : [Int:String] = [:]
    var customVc :SAPreviewPlan = SAPreviewPlan()
    var selectedCategory : NSMutableArray = []
    var dayId = 0
    var tbl : UITableView = UITableView.init()
    var obj : NSArray = []
    var videos : NSArray = []
    var daysarr : [Int] = []
    var index = 0
    var localplan_day_id = 0
    var isSelect = false
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    func config()
    {
        self.col.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        self.col.register(UINib(nibName: "PreviewDayCollection", bundle: nil), forCellWithReuseIdentifier: "PreviewDayCollection")
        
        self.col.dataSource = self
        self.col.delegate = self
        self.col.reloadData()
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return daysObj.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewDayCollection", for: indexPath) as! PreviewDayCollection
        let index = indexPath.row
        
        let value = Array(self.daysObj)[index].value
        let key = Array(self.daysObj)[index].key
        cell.lbl.text = value
        
        if (self.selectedCategory.contains(key))
        {
            cell.Allview.layer.cornerRadius = 22.5
            cell.Allview.layer.masksToBounds = true
            cell.Allview.layer.borderWidth = 1
            cell.Allview.layer.borderColor = UIColor.white.cgColor
        }
        else{
            cell.Allview.layer.cornerRadius = 22.5
            cell.Allview.layer.masksToBounds = true
            cell.Allview.layer.borderWidth = 1
            cell.Allview.layer.borderColor = "9AC25B".color.cgColor
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 120, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as! PreviewDayCollection
        
        let id = Array(self.daysObj)[indexPath.row].key
        
        
        if(self.obj.count > 0)
        {
            // evaluate day_id with selectedday
            let key = Array(self.daysObj)[indexPath.row].key
            
            for index in 0..<self.obj.count
            {
                let conent = self.obj.object(at:index) as AnyObject
                let day_id = conent.value(forKey: "day_id") as! String
                if(key == Int(day_id))
                {
                    let videos = conent.value(forKey: "plan_vedios") as! NSArray
                    self.customVc.videos = videos
                    
                    self.isSelect = true
                    self.customVc.isSelect = self.isSelect
                    self.customVc.tbl.delegate = self.customVc
                    self.customVc.tbl.dataSource = self.customVc
                    self.customVc.tbl.reloadData()
                    
                    let dayName = conent.value(forKey: "day_name") as? String ?? ""
                    let dayNote = conent.value(forKey: "note") as? String ?? ""
                    
                    let tblindexpath = IndexPath(row: 1, section: 0)
                    let tblCell = self.tbl.cellForRow(at: tblindexpath) as! PreviewtxtDaycell
                    tblCell.txtDay.text = dayName
                    
                    let tblindexpath2 = IndexPath(row: 2, section: 0)
                    let tblCell2 = self.tbl.cellForRow(at: tblindexpath2) as! PreviewtxtExcersise
                    tblCell2.txtMsg.text = dayNote
                    
                    self.customVc.isSelect = self.isSelect
                    self.customVc.tbl.delegate = self.customVc
                    self.customVc.tbl.dataSource = self.customVc
                    self.customVc.tbl.reloadData()
                    
                    self.selectedCategory.removeAllObjects()
                    if cell.isSelected
                    {
                        cell.isSelected = false
                        if (!selectedCategory.contains(key))
                        {
                            self.selectedCategory.add(id)
                            cell.Allview.layer.cornerRadius = 22.5
                            cell.Allview.layer.masksToBounds = true
                            cell.Allview.layer.borderWidth = 1
                            cell.Allview.layer.borderColor = UIColor.white.cgColor
                        }
                        else
                        {
                            self.selectedCategory.remove(key)
                            self.selectedCategory.add(id)
                            cell.Allview.layer.cornerRadius = 22.5
                            cell.Allview.layer.masksToBounds = true
                            cell.Allview.layer.borderWidth = 1
                            cell.Allview.layer.borderColor = "9AC25B".color.cgColor
                        }
                    }
                    else
                    {
                        cell.isSelected = true
                        self.selectedCategory.add(id)
                        cell.Allview.layer.cornerRadius = 22.5
                        cell.Allview.layer.masksToBounds = true
                        cell.Allview.layer.borderWidth = 1
                        cell.Allview.layer.borderColor = UIColor.white.cgColor
                    }
                    self.col.reloadData()
                }
            }
            
            
            
            
            
            //            let contains = self.daysarr.contains(where: { $0 == index })
            //            if(contains)
            //            {
            //                let index_arr = daysarr.index(where: { (item) -> Bool in
            //                    item == index
            //                })
            //                let content = self.obj.object(at: self.index) as AnyObject
            //                let videos = content.value(forKey: "plan_vedios") as! NSArray
            //                if(videos.count > 0)
            //                {
            //                    self.localplan_day_id = content.value(forKey: "id") as! Int
            //                    self.customVc.videos = videos.mutableCopy() as! NSMutableArray
            //
            //                    let dayName = content.value(forKey: "day_name") as? String ?? ""
            //                    let dayNote = content.value(forKey: "note") as? String ?? ""
            //
            //                    let tblindexpath = IndexPath(row: 1, section: 0)
            //                    let tblCell = self.tbl.cellForRow(at: tblindexpath) as! txtDaycell
            //                    tblCell.txtDay.text = dayName
            //
            //                    let tblindexpath2 = IndexPath(row: 2, section: 0)
            //                    let tblCell2 = self.tbl.cellForRow(at: tblindexpath2) as! txtExcersise
            //                    tblCell2.txtMsg.text = dayNote
            //
            //                    self.customVc.tbl.delegate = self.customVc
            //                    self.customVc.tbl.dataSource = self.customVc
            //                    self.customVc.tbl.reloadData()
            //                }
            //                else{
            //                    self.customVc.videos = []
            //                    let tblindexpath = IndexPath(row: 1, section: 0)
            //                    let tblCell = self.tbl.cellForRow(at: tblindexpath) as! txtDaycell
            //                    tblCell.txtDay.text = ""
            //
            //                    let tblindexpath2 = IndexPath(row: 2, section: 0)
            //                    let tblCell2 = self.tbl.cellForRow(at: tblindexpath2) as! txtExcersise
            //                    tblCell2.txtMsg.text = ""
            //
            //                    self.customVc.tbl.delegate = self.customVc
            //                    self.customVc.tbl.dataSource = self.customVc
            //                    self.customVc.tbl.reloadData()
            //                }
            //            }
            //        }
            //        else
            //        {
            //            self.customVc.videos = []
            //            let tblindexpath = IndexPath(row: 1, section: 0)
            //            let tblCell = self.tbl.cellForRow(at: tblindexpath) as! txtDaycell
            //            tblCell.txtDay.text = ""
            //
            //            let tblindexpath2 = IndexPath(row: 2, section: 0)
            //            let tblCell2 = self.tbl.cellForRow(at: tblindexpath2) as! txtExcersise
            //            tblCell2.txtMsg.text = ""
            //
            //            self.customVc.tbl.delegate = self.customVc
            //            self.customVc.tbl.dataSource = self.customVc
            //            self.customVc.tbl.reloadData()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}

