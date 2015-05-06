//
//  DetailInformationController.swift
//  Todo
//
//  Created by air on 15/4/3.
//  Copyright (c) 2015年 air. All rights reserved.
//

import UIKit

protocol DetailInformationProtcol {
    func onChangeDetail(detail:String)
}

class DetailInformationController: UIViewController,UITextViewDelegate{

    var detailtext:String?
    var detaildelegate:DetailInformationProtcol?
    
    @IBOutlet weak var detailInformationView: UITextView!
    @IBAction func savedetail(sender: UIBarButtonItem) {
        detailtext = detailInformationView.text
        detaildelegate?.onChangeDetail(detailtext!)
        //self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        super.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        detailInformationView.delegate = self
        // Do any additional setup after loading the view.
        detailInformationView.text = detailtext
        if detailtext == nil{
            navigationController?.topViewController.title = "新增信息"
        }else{
            navigationController?.topViewController.title = "修改信息"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    func textViewDidEndEditing(textView: UITextView) {
        detailInformationView.resignFirstResponder()
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        detailInformationView.resignFirstResponder()
    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
