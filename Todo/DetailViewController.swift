import UIKit

class DetailViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate,DetailInformationProtcol{

    @IBOutlet weak var childButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var travelButton: UIButton!
    @IBOutlet weak var shoppingCartButton: UIButton!
    @IBOutlet weak var todoItem: UITextField!
    @IBOutlet weak var todoDate: UIDatePicker!
    
    @IBOutlet weak var TodoDetail: UITextView!
    
    var todo:TodoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        todoItem.delegate = self
        TodoDetail.delegate = self
        
        if todo == nil{
            childButton.selected = true
            navigationController?.topViewController.title = "新增Todo"
        }else{
            navigationController?.topViewController.title = "修改Todo"
            if todo?.image == "child-selected" {
                childButton.selected = true
            }else if todo?.image == "shopping-cart-selected" {
                shoppingCartButton.selected = true
            }else if todo?.image == "phone-selected" {
                phoneButton.selected = true
            }else if todo?.image == "travel-selected" {
                travelButton.selected = true
            }
            
            todoItem.text = todo?.title
            todoDate.setDate(todo!.date, animated: false)
            TodoDetail.text = todo?.detail
        }
    }

    func ResetButtons(){
        childButton.selected = false
        phoneButton.selected = false
        shoppingCartButton.selected = false
        travelButton.selected = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func childTapped(sender: AnyObject) {
        ResetButtons()
        childButton.selected = true
    }

    @IBAction func phoneTapped(sender: AnyObject) {
        ResetButtons()
        phoneButton.selected = true
    }
    
    @IBAction func shoppingCartTapped(sender: AnyObject) {
        ResetButtons()
        shoppingCartButton.selected = true
    }

    
    @IBAction func travelTapped(sender: AnyObject) {
        ResetButtons()
        travelButton.selected = true
    }

    
    @IBAction func OKTapped(sender: AnyObject) {
        var image = ""
        if childButton.selected {
            image = "child-selected"
        }else if phoneButton.selected {
            image = "phone-selected"
        }else if shoppingCartButton.selected {
            image = "shopping-cart-selected"
        }else if travelButton.selected {
            image = "travel-selected"
        }else {
            image = "child-selected"
        }
        
        if todo == nil{
            let uuid = NSUUID().UUIDString
            
            var todo = TodoModel(id: uuid, image: image, title: "\(todos.count+1).\(todoItem.text)", date: todoDate.date,detail: TodoDetail.text,remind:true)
            println(uuid)
            todos.append(todo)
        }else{
            todo?.image = image
            todo?.title = todoItem.text
            todo?.date  = todoDate.date
            todo?.detail = TodoDetail.text
        }
        
        //saveListItems()
        
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    

    
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
        
    }
    
    
    /*
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        todoItem.resignFirstResponder()
    }
    */
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        todoItem.resignFirstResponder()
        //TodoDetail.resignFirstResponder()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailpush" {
            var vc = segue.destinationViewController as! DetailInformationController
           vc.detailtext = TodoDetail.text
           vc.detaildelegate = self

        }

    }
    
    
    
    func onChangeDetail(detail:String){
        TodoDetail.text = detail
    }
    //获取沙盒路径
    func documentsDirectory()->String{
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        var documentDirectory:String = paths.first as! String
        return documentDirectory
    }
    //获取数据文件地址
    func dataFilePath()->String{
        return documentsDirectory().stringByAppendingString("Todo.plist")
    }
    
    func saveListItems(){
        var data = NSMutableData()
        var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(todo, forKey: "TodoList")
        
        archiver.finishEncoding()
        
        data.writeToFile(dataFilePath(), atomically: true)
    }
    

}
