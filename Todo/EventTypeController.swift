//
//  EventTypeController.swift
//  Todo
//
//  Created by air on 15/5/5.
//  Copyright (c) 2015年 air. All rights reserved.
//

import UIKit

class EventTypeController: UIViewController {

    @IBOutlet weak var childbutton: UIButton!
    @IBOutlet weak var phonebutton: UIButton!
    @IBOutlet weak var shoppingbutton: UIButton!
    @IBOutlet weak var travelbutton: UIButton!
    
    @IBOutlet weak var nextpage: UIBarButtonItem!
    //新建一个Todo对象
    var todo:TodoModel?
    
    var image = ""
    
    @IBAction func childTapped(sender: AnyObject) {
        ResetButtons()
        childbutton.selected = true
    }
    
    @IBAction func phoneTapped(sender: AnyObject) {
        ResetButtons()
        phonebutton.selected = true
    }

    @IBAction func shoppingTapped(sender: AnyObject) {
        ResetButtons()
        shoppingbutton.selected = true
    }
    
    @IBAction func travelTapped(sender: AnyObject) {
        ResetButtons()
        travelbutton.selected = true
    }
    
    func ResetButtons(){
        childbutton.selected = false
        phonebutton.selected = false
        shoppingbutton.selected = false
        travelbutton.selected = false
    }
    
    @IBOutlet weak var updateButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if todo == nil{
            childbutton.selected = true
            
            todo = TodoModel(id: "", image: "", title: "", date: NSDate(),detail: "",remind:0)
        }else{
            //已经存在的选项
            if todo?.image == "child-selected" {
                childbutton.selected = true
            }else if todo?.image == "shopping-cart-selected" {
                shoppingbutton.selected = true
            }else if todo?.image == "phone-selected" {
                phonebutton.selected = true
            }else if todo?.image == "travel-selected" {
                travelbutton.selected = true
            }
        }
        if todo!.id == ""{
           updateButton.hidden = true
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToDetail" {
            
            chooseImage()
            
            let vc = segue.destinationViewController as! TitleViewController
            
            vc.todo = todo
        }
    }
   
    func chooseImage(){
        if childbutton.selected {
            image = "child-selected"
        }else if phonebutton.selected {
            image = "phone-selected"
        }else if shoppingbutton.selected {
            image = "shopping-cart-selected"
        }else if travelbutton.selected {
            image = "travel-selected"
        }else {
            image = "child-selected"
        }
        todo!.image = image
    }

}
