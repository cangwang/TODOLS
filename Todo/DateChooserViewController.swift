//
//  DateChooserViewController.swift
//  Todo
//
//  Created by air on 15/5/5.
//  Copyright (c) 2015年 air. All rights reserved.
//

import UIKit

class DateChooserViewController: UIViewController {

    var todo:TodoModel?
    
    @IBOutlet weak var remindSwitch: UISwitch!
    
    @IBOutlet weak var datetimePicker: UIDatePicker!
    
    @IBOutlet weak var updateButton: UIButton!
    
    
    @IBAction func SetAutoRemind(sender: AnyObject) {
        
    }
    
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if todo!.remind == 1 {
            remindSwitch.on = true
        }else{
            remindSwitch.on = false
        }
        if todo!.id == ""{
            updateButton.hidden = true
        }else{
            datetimePicker.setDate(todo!.date, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
