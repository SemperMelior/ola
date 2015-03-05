//
//  AddDataTableViewController.swift
//  Ola
//
//  Created by Lucille Benoit on 2/19/15.
//  Copyright (c) 2015 cs147. All rights reserved.
//

import UIKit


class AddDataTableViewController: UITableViewController {
    var healthManager:HealthManager?
    @IBAction func toggleDataType(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            unitsLabel.text = "IU"
        }else {
            unitsLabel.text = "mg/dL"
        }
    }
    /*MOST IMPORTANT FUNCTION THIS WILL ADD THE DATA AND MAYBE PUSH IT TO HEALTHKIT*/
    @IBAction func addData(sender: UIBarButtonItem) {
        var date = DatePickerView.date
        var time = NSDateComponents()
        var value = (unitsField.text as NSString).doubleValue
        healthManager?.saveGlucose(value, date:date)
        let alert = UIAlertView()
        alert.title = "Added"
        alert.message = "Added data to Healthkit"
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var unitsField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var DatePickerView : UIDatePicker = UIDatePicker()
    var TimePickerView : UIDatePicker = UIDatePicker()
    
    
    
    
    func checkAllFields() {
        if (!dateField.text.isEmpty && !timeField.text.isEmpty && !unitsField.text.isEmpty) {
            addButton.enabled = true
        } else {
            addButton.enabled = false
        }
    }
    
    func handleDatePicker(){
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateField.text = dateFormatter.stringFromDate(DatePickerView.date)
    }
    func handleTimePicker(){
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        timeField.text = dateFormatter.stringFromDate(TimePickerView.date)
    }
    
    @IBAction func changedUnits() {
        checkAllFields()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.enabled = false
        
        unitsField.becomeFirstResponder()
        
        DatePickerView.datePickerMode = UIDatePickerMode.Date
        dateField.inputView = DatePickerView
        
        TimePickerView.datePickerMode = UIDatePickerMode.Time
        timeField.inputView = TimePickerView
        
        timeField.text = DateUtil().getCurrentTime()
        dateField.text = DateUtil().getCurrentDate()
        
        DatePickerView.addTarget(self, action: Selector("handleDatePicker"), forControlEvents: UIControlEvents.ValueChanged)
        TimePickerView.addTarget(self, action: Selector("handleTimePicker"), forControlEvents: UIControlEvents.ValueChanged)
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
        return 4
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(44.0)
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}
