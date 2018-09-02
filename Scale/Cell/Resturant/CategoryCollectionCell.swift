//
//  CategoryCollectionCell.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/17/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UITableViewCell, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource,UIScrollViewDelegate  {
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var col: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var CustomJoinVC : SADayDetails = SADayDetails()
    
    var customVC : UIViewController =  UIViewController()
    var object : NSArray = []
    var type = ""
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        if(Language.currentLanguage().contains("ar")){
            lblTitle.textAlignment = .right
        }
        else{
            lblTitle.textAlignment = .left
        }
    }
    
    
    func config()
    {
        if(self.type == "details")
        {
            btnEdit.isHidden = true

            self.col.register(UINib(nibName: "TagCell2", bundle: nil), forCellWithReuseIdentifier: "TagCell2")
        }
        
        if(self.type != "details")
        {
            view.layer.cornerRadius = 15
            view.layer.masksToBounds = true
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.white.cgColor
        }
        
        self.lblTitle.text = "Breackfast"
        self.col.dataSource = self
        self.col.delegate = self
        self.col.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 30
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell2", for: indexPath) as! TagCell2
        //let content = self.object.object(at: indexPath.row) as AnyObject
        //let name  = content.value(forKey: "name") as! String
        //cell.lblTag.text = "test"
        cell.lblText.text = "test"
        cell.ColorView.backgroundColor = UIColor.getRandomColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        //            let content = self.object.object(at: indexPath.row) as AnyObject
        //            let starString = content.value(forKey: "name") as! String
        let starString = "Milk"
        let width: CGSize = starString.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11.0)])
        return CGSize(width: Int(50), height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
}
