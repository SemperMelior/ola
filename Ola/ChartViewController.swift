
import UIKit
import QuartzCore

class ChartViewController: UIViewController, LineChartDelegate {

    
    
    var label = UILabel()
    var lineChart: LineChart?
    var label2 = UILabel()
    var glucoseData: Array<CGFloat> = [3, 4, 9, 11, 13, 15]
    var insulinData: Array<CGFloat> = [2, 3, 1, 4, 5, 4, 3]
    
    @IBOutlet weak var dataType: UISegmentedControl!
    @IBAction func dataTypeChanged(sender: UISegmentedControl) {
        self.lineChart!.clear()
        var data = glucoseData
        var unitString = "mg/dL"
        if sender.selectedSegmentIndex == 1 {
            data = insulinData
            unitString = "IU"
        }
        self.lineChart!.addLine(data)
        label.text = " "
        var average: Double = (data as AnyObject).valueForKeyPath("@avg.self") as Double
        var avgString = String(format: "%.2f", average)
        label2.text = "Average: \(avgString) \(unitString)"
    }
    
    @IBAction func timePeriodChanged(sender: UISegmentedControl) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawNewGraph()
        
        
    }
    
    func drawNewGraph() {
        var data = glucoseData
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
            label.text = "x: \(x)     \(yValues[0]) mg/dL"
        }else{
            label.text = "x: \(x)     \(yValues[0]) IU"
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
