
import UIKit
import QuartzCore

class ChartViewController: UIViewController, LineChartDelegate {

    let healthManager:HealthManager = HealthManager()
    
    var label = UILabel()
    var lineChart: LineChart?
    var label2 = UILabel()
    
    var xLabels = ["12pm", "2pm", "6pm", "10pm", "2am", "6am", "10am", "2pm"]
    var day = ["12pm", "2pm", "6pm", "10pm", "2am", "6am", "10am", "2pm"]
    var week = ["Tue", "Wed", "Thu", "Fri", "Sat", "Sun", "Mon", "Tue"]
    var month = ["Feb 3", "Feb 8", "Feb 13", "Feb 18", "Feb 23", "Feb 28", "Mar 3"]
    var year = ["Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar"]
    
    var currData: Array<CGFloat> = [3, 4, 9, 11, 13, 15, 12]
    var glucoseDay: Array<CGFloat> = [3, 4, 9, 11, 13, 15, 12]
    var glucoseWeek: Array<CGFloat> = [14, 14, 19, 21, 13, 15, 22]
    var glucoseMonth: Array<CGFloat> = [24, 14, 9, 21, 9, 15, 21]
    var insulinWeek: Array<CGFloat> = [4, 4, 9, 1, 3, 5, 2]
    var insulinDay: Array<CGFloat> = [2, 3, 1, 4, 5, 4, 6]
    var glucoseYear: Array<CGFloat> = [12, 4, 9, 5, 16, 15, 12, 13, 5, 12, 7, 8]
    var insulinYear: Array<CGFloat> = [2, 4, 3, 5, 6, 5, 2, 3, 5, 2, 7, 8]
    
    @IBOutlet weak var dataType: UISegmentedControl!
    @IBOutlet weak var timeType: UISegmentedControl!
    func setCurrentData(){
        var unitString = "mg/dL"
        if dataType.selectedSegmentIndex == 0{
            if timeType.selectedSegmentIndex == 0{
                currData = glucoseDay
                xLabels = day
            }else if timeType.selectedSegmentIndex == 1{
                currData = glucoseWeek
                xLabels = week
            }else if timeType.selectedSegmentIndex == 2{
                currData = glucoseMonth
                xLabels = month
            }else {
                currData = glucoseYear
                xLabels = year
            }
        }else{
            unitString = "IU"
            if timeType.selectedSegmentIndex == 0{
                currData = insulinDay
                xLabels = day
            }else if timeType.selectedSegmentIndex == 1{
                currData = insulinWeek
                xLabels = week
            }else if timeType.selectedSegmentIndex == 2{
                currData = glucoseWeek
                xLabels = month
            }else {
                currData = insulinYear
                xLabels = year
            }
            
        }
        var average: Double = (currData as AnyObject).valueForKeyPath("@avg.self") as Double
        var avgString = String(format: "%.2f", average)
        label2.text = "Average: \(avgString) \(unitString)"
    }
    @IBAction func dataTypeChanged(sender: UISegmentedControl) {
        self.lineChart!.clear()
        self.setCurrentData()
        self.lineChart!.addLine(currData)
        label.text = " "
        
    }
    
    @IBAction func timePeriodChanged(sender: UISegmentedControl) {
        self.lineChart!.clear()
        self.setCurrentData()
        self.lineChart!.addLine(currData)
        self.lineChart!.changeXAxisTimePeriod(sender.selectedSegmentIndex)
        label.text = " "
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()
        drawNewGraph()
        
        
    }
    func authorizeHealthKit() {
        healthManager.authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                println("HealthKit authorization received.")
            }
            else
            {
                println("HealthKit authorization denied!")
                if error != nil {
                    println("\(error)")
                }
            }
        }
    }
    
    func drawNewGraph() {
        var data = currData
        var views: Dictionary<String, AnyObject> = [:]
        
        label.text = " "
        label.textColor = UIColor.darkGrayColor()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        views["label"] = label
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: nil, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-85-[label]", options: nil, metrics: nil, views: views))
        
        
        var average: Double = (data as AnyObject).valueForKeyPath("@avg.self") as Double
        var avgString = String(format: "%.2f", average)
        lineChart = LineChart()
        lineChart!.areaUnderLinesVisible = true
        //lineChart!.addLine(data)
        //lineChart!.addLine(data2)
        lineChart!.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineChart!.delegate = self
        self.view.addSubview(lineChart!)
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: nil, metrics: nil, views: views))
        let height = UIScreen.mainScreen().applicationFrame.height - 250
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==\(height))]", options: nil, metrics: nil, views: views))
        label2.text = "Average: \(avgString) mg/dL"
        label2.textColor = UIColor.darkGrayColor()
        label2.setTranslatesAutoresizingMaskIntoConstraints(false)
        label2.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label2)
        views["label2"] = label2
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label2]-|", options: nil, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[chart]-[label2]", options: nil, metrics: nil, views: views))
        //var delta: Int64 = 4 * Int64(NSEC_PER_SEC)
        //var time = dispatch_time(DISPATCH_TIME_NOW, delta)
        
        //dispatch_after(time, dispatch_get_main_queue(), {
        //self.lineChart!.clear()
        self.lineChart!.addLine(data)
        //});
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        if dataType.selectedSegmentIndex == 0 {
            label.text = "\(xLabels[Int(x)])     \(yValues[0]) mg/dL"
        }else{
            label.text = "\(xLabels[Int(x)])     \(yValues[0]) IU"
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  "addData" {
            
            let dvc = segue.destinationViewController as AddDataTableViewController
            dvc.healthManager = healthManager
            
        }
    }
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }

}
