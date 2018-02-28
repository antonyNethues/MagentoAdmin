//
//  ModuleDescViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 01/12/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class ModuleDescViewController: UIViewController,UITextViewDelegate {

    @IBOutlet var heightConstTextView: NSLayoutConstraint!
    @IBOutlet var moduleDescTextview: UITextView!
    @IBOutlet var moduleButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let linkText = "https://www.apple.com"
        let linkAttributes = [
            NSLinkAttributeName: NSURL(string: linkText)!,
            NSForegroundColorAttributeName: UIColor.blue
            ] as [String : Any]
        
        let attributedString = NSMutableAttributedString(string: moduleDescTextview.text + " " + linkText)
        
        // Set the 'click here' substring to be the link
        attributedString.setAttributes(linkAttributes, range: NSMakeRange(moduleDescTextview.text.characters.count + 1, linkText.characters.count))
        
        moduleDescTextview.delegate = self
        moduleDescTextview.attributedText = attributedString
        moduleDescTextview.isEditable = false
        
        // Do any additional setup after loading the view.
    }

    @IBAction func moduleButtonTapped(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://google.com")!)

    }
    @IBAction func bottomLinkTapped(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://google.com")!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let fontSize = 13

        moduleDescTextview.font = ObjRef.sharedInstance.updateFont(fontName: (moduleDescTextview.font?.fontName)!, fontSize: fontSize)
        moduleDescTextview.frame.size.height = moduleDescTextview.contentSize.height
        heightConstTextView.constant = moduleDescTextview.frame.size.height
        
       
    }
    @IBAction func backTapped(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
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
