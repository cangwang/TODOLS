import UIKit

var todos: [TodoModel] = []
var filteredTodos:[TodoModel] = []

func dateFromString(dateStr:String)->NSDate?{
    let dateFormater = NSDateFormatter()
    dateFormater.dateFormat = "yyyy-MM-dd HH-mm"
    let date = dateFormater.dateFromString(dateStr)
    
    return date
    
}


class MyTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate{

    @IBOutlet var MytableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todos = [TodoModel(id:"1",image:"child-selected",title:"1.去游乐场",date: dateFromString("2015-11-2 22-20")!,detail:"游",remind:true),
        TodoModel(id:"2",image:"shopping-cart-selected",title:"2.购物",date: dateFromString("2015-10-28 12-22")!,detail:"买",remind:true),
        TodoModel(id:"3",image:"phone-selected",title:"3.打电话",date: dateFromString("2015-10-30 14-34")!,detail:"打",remind:false),
        TodoModel(id:"4",image:"travel-selected",title:"4.Travel to Europe",date: dateFromString("2015-10-31 13-22")!,detail:"行",remind:false)]
        
        //loadListItems()
        self.navigationItem.leftBarButtonItem = editButtonItem()
        self.navigationController?.topViewController.title = "Todo"
        
        var contentOffset = tableView.contentOffset
        contentOffset.y += searchDisplayController!.searchBar.frame.size.height
        
        tableView.contentOffset = contentOffset
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if tableView == searchDisplayController?.searchResultsTableView {
            return filteredTodos.count
        }else{
            return todos.count
        }

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
    
        var todo: TodoModel
        
        if tableView == searchDisplayController?.searchResultsTableView{
            todo = filteredTodos[indexPath.row] as TodoModel
        }else{
            todo = todos[indexPath.row] as TodoModel
        }
        
        var image = cell.viewWithTag(101) as! UIImageView
        var title = cell.viewWithTag(102) as! UILabel
        var date = cell.viewWithTag(103) as! UILabel
        
        image.image = UIImage(named: todo.image)
        title.text = todo.title
        
        let locale = NSLocale.currentLocale()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy-MM-dd", options: 0, locale: locale)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        date.text = dateFormatter.stringFromDate(todo.date)
        
        return cell
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool{
        filteredTodos = todos.filter(){$0.title.rangeOfString(searchString) != nil}
        return true
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            todos.removeAtIndex(indexPath.row)
            //self.tableView.reloadData()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated:animated)
    }
    
    @IBAction func close(segue: UIStoryboardSegue){
        println("closed")
        if segue.identifier == "ToSaveNew" {
            var vc = segue.sourceViewController as! DateChooserViewController
            let uuid = NSUUID().UUIDString
            vc.todo!.id = uuid
            vc.todo!.title = "\(todos.count+1).\(vc.todo!.title)"
            vc.todo!.date = vc.datetimePicker.date
            vc.todo?.remind = vc.remindSwitch.on
            todos.append(vc.todo!)
        }
        
        //self.tableView.reloadData()
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditTodo" {
            var vc = segue.destinationViewController as! UpdateTodoViewController
            var indexPath = tableView.indexPathForSelectedRow()
            
            if let index = indexPath{
                vc.todo = todos[index.row]
            }
        }
        
        if segue.identifier == "ToEvent" {
            var vc = segue.destinationViewController as! EventTypeController
            
        }
    }
    //Move cell
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return editing
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath){
        let todo = todos.removeAtIndex(sourceIndexPath.row)
        todos.insert(todo, atIndex: destinationIndexPath.row)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    /*
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
    
    func loadListItems(){
        //获取本地数据文件地址
        let path =  self.dataFilePath()
        //声明文件管理器
        let defaultManager = NSFileManager()
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExistsAtPath(path){
            //读取文件数据
            let data = NSData(contentsOfFile: path)
            //解码器
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
            //归档时设置还原todo
            todos = unarchiver.decodeObjectForKey("TodoList") as! Array
            unarchiver.finishDecoding()
        }
    }
    
    */
}
