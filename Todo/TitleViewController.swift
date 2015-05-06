import UIKit

class TitleViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var detailTextField: UITextView!
    
    @IBOutlet weak var nextpage: UIBarButtonItem!
    
    
    @IBOutlet weak var updateButton: UIButton!
    var todo:TodoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if todo!.id == ""{
            updateButton.hidden = true
        }else {
            titleTextField.text = todo?.title
            detailTextField.text = todo?.detail
        }
        
        titleTextField.delegate = self
        detailTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        titleTextField.resignFirstResponder()
        detailTextField.resignFirstResponder()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
           textView.resignFirstResponder()
           
        }
        return true
    }
    
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToDate" {
            let vc = segue.destinationViewController as! DateChooserViewController
            
            todo?.title = titleTextField.text
            todo?.detail = detailTextField.text
            vc.todo = todo
        }
    }
    

}
