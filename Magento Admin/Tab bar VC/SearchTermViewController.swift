//
//  SearchTermViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 28/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class SearchTermViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var top5SearchArr = NSArray()
    @IBOutlet var top5SearchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"

        self.top5SearchTableView.reloadData()
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItems = ObjRef.sharedInstance.navigationbarLeftButton(viewController: self, buttonImage: UIImage(named: "defaultBack")!)
        
    }
    
    func navigationBtnLeftTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchTermTableViewCell
        
        var fontSize = Int()
        fontSize = 14
        

        if indexPath.row > 0 {//
            if top5SearchArr.count > 0 {
                let dict = top5SearchArr.object(at: indexPath.row - 1) as! NSDictionary
                cell.valSearchTerm.text = dict["term"] as? String
                cell.valueResult.text = "\(dict["result"]!)"
                cell.valueUser.text = "\(dict["uses"]!)"
                
                cell.valSearchTerm.font = ObjRef.sharedInstance.updateFont(fontName: (cell.valSearchTerm.font?.fontName)!, fontSize: fontSize)
                cell.valueResult.font = ObjRef.sharedInstance.updateFont(fontName: (cell.valueResult.font?.fontName)!, fontSize: fontSize)
                cell.valueUser.font = ObjRef.sharedInstance.updateFont(fontName: (cell.valueUser.font?.fontName)!, fontSize: fontSize)
                
            }
            else {
                cell.valSearchTerm.text = ""
                cell.valueResult.text = ""
                cell.valueUser.text = ""
            }
            //cell = tableView.dequeueReusableCell(withIdentifier: "cellBarChart") as! SearchTermTableViewCell
            cell.selectionStyle = .none
            
        }
        else {
            
            cell.valSearchTerm.font = ObjRef.sharedInstance.updateFont(fontName: (cell.valueUser.font?.fontName)!, fontSize: fontSize + 2)
            cell.valueResult.font = ObjRef.sharedInstance.updateFont(fontName: (cell.valueUser.font?.fontName)!, fontSize: fontSize + 2)
            cell.valueUser.font = ObjRef.sharedInstance.updateFont(fontName: (cell.valueUser.font?.fontName)!, fontSize: fontSize + 2)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        headView.backgroundColor = ObjRef.sharedInstance.magentoGreen
        
        let labTitle = CustomLabel(frame: headView.frame)
        if section == 0 {
            labTitle.text = "Top 5 Search Terms"
        }
        
        headView.addSubview(labTitle)
        labTitle.textColor = UIColor.white
        
        return headView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
        //return UITableViewAutomaticDimension
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {//
//            return 50
//        }
//        
//        return 70
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
