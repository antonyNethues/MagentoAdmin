//
//  CouponViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 20/12/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class CouponViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var couponArr = NSMutableArray()
    @IBOutlet var couponTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        couponTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func activateButtonTapped(_ sender: Any) {
        _ = sender as! UIButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return couponArr.count
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CouponTableViewCell
        cell.activeButton.tag = indexPath.row
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
