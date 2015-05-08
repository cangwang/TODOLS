//
//  DetailInformViewController.swift
//  Todo
//
//  Created by air on 15/5/7.
//  Copyright (c) 2015年 air. All rights reserved.
//

import UIKit

class DetailInformViewController: UIViewController {

    var todo:TodoModel?
    
    @IBOutlet weak var titleButton: UIButton!
    
    @IBOutlet weak var detailLab: UILabel!


    @IBOutlet weak var dateLab: UILabel!
    
    @IBOutlet weak var remindSwitch: UISwitch!
    
    var changeButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.topViewController.title = "详细日程"
        changeButton = UIBarButtonItem(title: "修改", style: UIBarButtonItemStyle.Plain, target: self, action: "ToUpdatePage:")
        self.navigationItem.rightBarButtonItem = changeButton
        
    }
    func ToUpdatePage(){
        //showViewController(UpdateTodoViewController.self, sender: changeButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        detailInformaiton()
    }
    
    func detailInformaiton(){
        if todo?.image == "child-selected" {
            titleButton.setImage(UIImage(named: "child-selected"), forState: UIControlState.Normal)
        }else if todo?.image == "shopping-cart-selected" {
            titleButton.setImage(UIImage(named: "shopping-cart-selected"), forState: UIControlState.Normal)
        }else if todo?.image == "phone-selected" {
            titleButton.setImage(UIImage(named: "phone-selected"), forState: UIControlState.Normal)
        }else if todo?.image == "travel-selected" {
            titleButton.setImage(UIImage(named: "travel-selected"), forState: UIControlState.Normal)
        }
        
        
        titleButton.setTitle(todo?.title, forState: UIControlState.Normal)
        detailLab.text = todo?.detail
        let locale = NSLocale.currentLocale()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy-MM-dd HH-mm", options: 0, locale: locale)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateLab.text = dateFormatter.stringFromDate(todo!.date)
        remindSwitch.on = todo!.remind
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToUpdate"{
           var vc = segue.destinationViewController as! UpdateTodoViewController
            vc.todo = todo
            saveflag = true
        }
    }
   

}
