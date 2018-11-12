//
//  SACountry.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/11/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
protocol CategoryProtocol
{
    func sendFilter(countryId:String , CountryName :String)
}

class SACountry: UIViewController , UITableViewDelegate , UITableViewDataSource
{
    @IBOutlet var tbl_popUp: UITableView!
    var delegate:CategoryProtocol?
    
    var TClass : NSArray = []
    var TCategory : NSArray = []
    var selectedCategory : NSMutableArray = []
    var selectedClass : NSMutableArray = []
    var arrayIndex = 0
    var Category = ""
    var Class = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.TCategory = UserDefaults.standard.value(forKey: "Country") as! NSArray
        self.tbl_popUp.reloadData()
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //self.LoadDataCategory()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return TCategory.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let content = self.TCategory.object(at: indexPath.row) as AnyObject
        let Title = content.value(forKey: "name") as! String
        if(Language.currentLanguage().contains("ar")){
            cell.textLabel?.textAlignment = .right
        }
        else{
            cell.textLabel?.textAlignment = .left
        }
        cell.textLabel?.text = Title
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let content = self.TCategory.object(at: indexPath.row) as AnyObject
        let  id  = content.value(forKey: "id") as! Int
        let  name  = content.value(forKey: "name") as! String
        self.dismiss(animated: true) {
            self.delegate?.sendFilter(countryId: String(id), CountryName: name)
        }
    }
    
}
