import UIKit

class UpdateTodoViewController: UIViewController {

    @IBOutlet weak var EventButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func changeRemind(sender: AnyObject) {
        if remindSwitch.on == true{
            todo?.remind = 1
        }else{
            todo?.remind = 0
        }
        todo?.scheduleNotification()
    }
    @IBOutlet weak var remindSwitch: UISwitch!
    var todo:TodoModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.topViewController.title = "修改Todo"
        
        updateInformaiton()
 
    }

    
    func updateInformaiton(){
        if todo?.image == "child-selected" {
            EventButton.setImage(UIImage(named: "child-selected"), forState: UIControlState.Normal)
        }else if todo?.image == "shopping-cart-selected" {
            EventButton.setImage(UIImage(named: "shopping-cart-selected"), forState: UIControlState.Normal)
        }else if todo?.image == "phone-selected" {
            EventButton.setImage(UIImage(named: "phone-selected"), forState: UIControlState.Normal)
        }else if todo?.image == "travel-selected" {
            EventButton.setImage(UIImage(named: "travel-selected"), forState: UIControlState.Normal)
        }
        
        titleLabel.text = todo?.title
        let locale = NSLocale.currentLocale()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy/MM/dd HH:mm", options: 0, locale: locale)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateLabel.text = dateFormatter.stringFromDate(todo!.date)
        if todo!.remind == 1{
            remindSwitch.on = true
        }else{
            remindSwitch.on = false
        }
        todo?.scheduleNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToChangeEvent" {
            var vc = segue.destinationViewController as! EventTypeController
            vc.nextpage.title = ""
            vc.todo = todo
            //vc.updateButton.hidden = true
        }
        if segue.identifier == "ToChangeTitle" {
            var vc = segue.destinationViewController as!
            TitleViewController
            vc.nextpage.title = ""
            vc.todo = todo
            //vc.updateButton.hidden = false
        }
        if segue.identifier == "ToChangeDate" {
            var vc = segue.destinationViewController as!
            DateChooserViewController
            vc.doneButton.title = ""
            vc.todo = todo
            //vc.updateButton.hidden = false
        }
    }
    
    @IBAction func updateTodo(segue:UIStoryboardSegue){
        if segue.identifier == "toFinishUpdateEvent" {
            var vc = segue.sourceViewController as! EventTypeController
            vc.chooseImage()
            todo!.image = vc.todo!.image
            
        }
        if segue.identifier == "ToFinishUpdateTitle" {
            var vc = segue.sourceViewController as! TitleViewController
            todo?.title = vc.titleTextField.text
            todo?.detail = vc.detailTextField.text
        }
        if segue.identifier == "ToFinishUpdateDate" {
            var vc = segue.sourceViewController as! DateChooserViewController
            todo?.date = vc.datetimePicker.date
            if remindSwitch.on == true{
                todo?.remind = 1
            }else{
                todo?.remind = 0
            }
        }
        
        updateInformaiton()
    }

}
