import UIKit

var todos: [TodoModel] = []
var filteredTodos:[TodoModel] = []

var saveflag = false

class MyTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate{

    @IBOutlet var MytableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //通知跳转监测器
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "drawAShape:", name: "actionOnePressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ShwoAMessage:", name: "actionTwoPressed", object: nil)
        
        self.navigationItem.leftBarButtonItem = editButtonItem()
        self.navigationController?.topViewController.title = NSLocalizedString("Todo_List",comment: "")
        
        var contentOffset = tableView.contentOffset
        contentOffset.y += searchDisplayController!.searchBar.frame.size.height
        
        tableView.contentOffset = contentOffset
        
        println("沙盒文件夹路径:\(documentsDirectory())")
        println("数据文件路径:\(dataFilePath())")
        loadListItems()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if saveflag == true { 
            saveListItems()
            saveflag = false
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy/MM/dd HH:mm", options: 0, locale: locale)
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
            if vc.remindSwitch.on {
                vc.todo?.remind = 1
            }else{
                vc.todo?.remind = 0
            }
            
            todos.append(vc.todo!)
            saveListItems()
            vc.todo?.scheduleNotification()
        
            //saveflag = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //过渡到详细信息
        if segue.identifier == "ToDetail"{
            var vc = segue.destinationViewController as! DetailInformViewController
            
            var indexPath = tableView.indexPathForSelectedRow()
            
            if let index = indexPath{
                vc.todo = todos[index.row]
            }
            //隐藏tabbar
            vc.hidesBottomBarWhenPushed = true
        }
        //过渡到创建事件
        if segue.identifier == "ToEvent" {
            var vc = segue.destinationViewController as! EventTypeController
            //隐藏tabbar
            vc.hidesBottomBarWhenPushed = true
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
    

    func loadListItems(){
        //获取本地数据文件地址
        let path = dataFilePath()
        //声明文件管理器
        let defaultManager = NSFileManager()
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExistsAtPath(path){
            //读取文件数据
            let data = NSData(contentsOfFile: path)
            //解码器
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
            //归档时设置还原todo
            todos = unarchiver.decodeObjectForKey("TodoList") as! [TodoModel]
            unarchiver.finishDecoding()
        }else{
            saveListItems()
        }
        
        //
        
        
    }
    
    func saveListItems(){
        var data = NSMutableData()
        //申明一个归档处理对象
        var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        //将todos进行编码
        archiver.encodeObject(todos, forKey: "TodoList")
        //编码结束
        archiver.finishEncoding()
        //数据写入
        data.writeToFile(dataFilePath(), atomically: true)
        println("保存成功")
        
        //保存到安装包目录下
        //let path = NSBundle.mainBundle().pathForResource("todol", ofType: "plist")
        
    }
    
    //通知执行
    func drawAShape(notification:NSNotification){
        println("5s")
    }
    
    func ShwoAMessage(notification:NSNotification){
        var message:UIAlertController = UIAlertController(title: "Todo", message: "请选择", preferredStyle: UIAlertControllerStyle.Alert)
        message.addAction(UIAlertAction(title: "我知道了", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(message, animated: true, completion: nil)
        
        
    }
}
