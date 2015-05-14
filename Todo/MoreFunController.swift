//
//  MoreFunController.swift
//  Todo
//
//  Created by air on 15/5/14.
//  Copyright (c) 2015年 air. All rights reserved.
//

import UIKit

class MoreFunController: UIViewController {

    
    @IBOutlet weak var SettingButton: UIButton!
    
    @IBOutlet weak var WeatherButton: UIButton!
    
    @IBOutlet weak var MapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToWeather" {
            var vc = segue.destinationViewController as! WeatherViewController
            vc.hidesBottomBarWhenPushed = true
        }
    }
   

}
