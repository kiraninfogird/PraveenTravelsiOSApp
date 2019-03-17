import UIKit

typealias CompletionHandlerBlock = (_ selectedDate:Date,_ status:Bool) -> Void
typealias CancelBlock = () -> Void

var  completionHandler:CompletionHandlerBlock?
var CancelHandler:CancelBlock?

class ASDatePickerTool: NSObject {
    
    var pickerBackgroundView:UIView?
    var datePicker:UIDatePicker?
    
    func addDatePickerWithpickerMode(_ datePickerMode:UIDatePickerMode?,onviewcontroller controller:UIViewController,onCompletion completionBlock:@escaping CompletionHandlerBlock, onCancelation cancel:@escaping CancelBlock) {
        
        completionHandler = completionBlock
        CancelHandler = cancel
        self.createDatepickerController(controller, with: datePickerMode!)
    }
    
    func createDatepickerController(_ contentViewcontroller:UIViewController,with contentMode:UIDatePickerMode) {
        if UIScreen.main.bounds.size.height < 568 {
            pickerBackgroundView = UIView(frame: CGRect(x: 0, y: 240, width: contentViewcontroller.view.frame.size.width, height: 240))
            datePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: contentViewcontroller.view.frame.size.width, height: 196))
        } else {
            pickerBackgroundView = UIView(frame: CGRect(x: 0, y: contentViewcontroller.view.frame.size.height - 260, width: contentViewcontroller.view.frame.size.width, height: 260))
            datePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: contentViewcontroller.view.frame.size.width, height: 216))
        }
        pickerBackgroundView?.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        datePicker?.datePickerMode = contentMode
        datePicker?.maximumDate = Date() as Date
        let titleLabel = UILabel(frame: CGRect(x: 70, y: 7, width: 180, height: 30))
        titleLabel.text = "Select Date"
        titleLabel.textAlignment = .center
        
        let doneButton = UIButton(type:.system)
        doneButton.frame =  CGRect(x: (pickerBackgroundView?.frame.size.width)!-70, y: 7, width: 50, height: 30)
        doneButton.setTitle("Done", for: UIControlState())

        doneButton.addTarget(self, action:#selector(ASDatePickerTool.doneButtonclick), for: .touchUpInside)
        let cancelutton = UIButton(type:.system)
        cancelutton.setTitle("Cancel", for: UIControlState())

        cancelutton.frame =  CGRect(x:10, y: 7, width: 50, height: 30)
        cancelutton.addTarget(self, action: #selector(ASDatePickerTool.cancelButtonclick), for: .touchUpInside)
       
        pickerBackgroundView?.addSubview(datePicker!)
        pickerBackgroundView?.addSubview(titleLabel)
        pickerBackgroundView?.addSubview(doneButton)
        pickerBackgroundView?.addSubview(cancelutton)
        contentViewcontroller.view.addSubview(pickerBackgroundView!)
    }
    
    @objc func doneButtonclick() {
        print("date: \(String(describing: datePicker?.date))")
        completionHandler!((datePicker?.date)!,true)
    }
    
    @objc func cancelButtonclick() {
        completionHandler!((datePicker?.date)!,false)
        
    }
}
