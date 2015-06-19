
import UIKit

class FirstViewController: UIViewController {
  /*
  TODO one: hook up a button in interface builder to a new function (to be written) in this class. Also hook up the label to this class. When the button is clicked, the function to be written must make a label say ‘hello world!’
  TODO two: Connect the ‘name’ and ‘age’ text boxes to this class. Hook up the button to a NEW function (in addition to the function previously defined). That function must look at the string entered in the text box and print out “Hello {name}, you are {age} years old!”
  TODO three: Hook up the button to a NEW function (in addition to the two above). Print “You can drink” below the above text if the user is above 21. If they are above 18, print “you can vote”. If they are above 16, print “You can drive”
  TODO four: Hook up the button to a NEW function (in additino to the three above). Print “you can drive” if the user is above 16 but below 18. It should print “You can drive and vote” if the user is above 18 but below 21. If the user is above 21, it should print “you can drive, vote and drink (but not at the same time!”.
  */
    
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBAction func buttonClicked(sender: AnyObject) {
        label.numberOfLines = 0
        
        // Make label say 'Hello world!'
        label.text = "Hello world!\n"
        
        // Greets the user
        label.text = label.text! + greeting()
        
        // Prints things user can do based on age
        label.text = label.text! + thingsUserCanDoByAge()
        
        // Prints all things user can do based on age
        label.text = label.text! + allThingsUserCanDoByAge()
    }
    
    var age:Int = 0;
    
    // Greets the user
    func greeting() -> String {
        var name:String = nameTextField.text
        age = ageTextField.text.toInt()!
        
        var greet:String = "Hello " + name + ", you are " + String(age) + " years old!\n"
        println(greet)
        
        return greet
    }
    
    // Prints things user can do based on age
    func thingsUserCanDoByAge() -> String {
        var things:String = "";
        
        if (age >= 16)
        {
            things = things + "You can drive\n"
        }
        
        if (age >= 18)
        {
            things = things + "You can vote\n"
        }
        
        if (age >= 21)
        {
            things = things + "You can drink\n"
        }

        println(things)
        
        return things
    }
    
    // Prints all things user can do based on age
    func allThingsUserCanDoByAge() -> String {
        var things:String = "";
        
        if (age >= 21) {
            things = "You can drive, vote and drink (but not at the same time)!"
        }
        else if (age >= 18) {
        	things = "You can drive and vote"
        }
        else if (age >= 16) {
            things = "You can drive"
        }

        println(things)
        
        return things
    }
}
