
import UIKit

class SecondViewController: UIViewController {
  
  //TODO five: Display the cumulative sum of all numbers added every time the ‘add’ button is pressed. Hook up the label, text box and button to make this work.
    
    
    @IBOutlet weak var numberInput: UITextField!
    @IBOutlet weak var numberLabel: UILabel!
    
    var currentNumber = 0
    
    @IBAction func addButtonClicked(sender: AnyObject) {
        var inputNum = numberInput.text.toInt()
        if let safeInput = inputNum {
            currentNumber = currentNumber + safeInput
            numberLabel.text = String(currentNumber)
        }
    }
}
