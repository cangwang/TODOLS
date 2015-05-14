import UIKit

class MyItemTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate{
    
    @IBOutlet var MytableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = editButtonItem()
        self.navigationController?.topViewController.title = NSLocalizedString("My_Todo",comment: "")
        //loadListItems()
        //println("沙盒文件夹路径:\(documentsDirectory())")
        //println("数据文件路径:\(dataFilePath())")
    }
    
    func loadMyList(){
        //filteredTodos = todos.filter(){$0.title.rangeOfString(searchString) != nil}
        filteredTodos = todos.filter(){
            $0.remind == 1
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if saveflag == true {
            saveListItems()
            saveflag = false
        }
        loadMyList()
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
        return filteredTodos.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        
        var todo: TodoModel
        
        todo = filteredTodos[indexPath.row] as TodoModel
        
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
        //保存新信息
        if segue.identifier == "ToSaveNew" {
            var vc = segue.sourceViewController as! DateChooserViewController
            let uuid = NSUUID().UUIDString
            vc.todo!.id = uuid
            vc.todo!.title = "\(todos.count+1).\(vc.todo!.title)"
            vc.todo!.date = vc.datetimePicker.date
            if vc.remindSwitch.on == true {
                vc.todo?.remind = 1
            }else {
                vc.todo?.remind = 0
            }
            
            todos.append(vc.todo!)
            vc.todo?.scheduleNotification()
            saveflag = true
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //过渡到事件信息
        if segue.identifier == "ToMyDetail"{
            var vc = segue.destinationViewController as! DetailInformViewController
            
            var indexPath = tableView.indexPathForSelectedRow()
            
            if let index = indexPath{
                vc.todo = filteredTodos[index.row]
            }
            //隐藏tabbar
            vc.hidesBottomBarWhenPushed = true
        }
        //过渡到创建事件
        if segue.identifier == "ToMyEvent" {
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
    }
}

