
import UIKit

class ThirdViewController: UIViewController {
  /*
  TODO six: Hook up the number input text field, button and text label to this class. When the button is pressed, a message should be printed to the label indicating whether the number is even.
  
  */
    
    @IBOutlet weak var numberInput: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func calculateButtonClicked(sender: AnyObject) {
        var message:String = ""
        var number = numberInput.text.toInt()
        
        if let safeNumber = number {
        
            if (safeNumber % 2 == 0)
            {
                message = "is even"
            }
            else {
                message = "is not even"
            }
        
            messageLabel.text = message
        }
        
    }
    
}
