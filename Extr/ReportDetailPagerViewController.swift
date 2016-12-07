//
//  ReportDetailPagerViewController.swift
//  Extr
//
//  Created by Zekun Wang on 12/6/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit
import Charts

class ReportDetailPagerViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet var barChartView: BarChartView!
    @IBOutlet var pieChartView: PieChartView!
    @IBOutlet var tableView: UITableView!
    
    let ANIMATION_TIME_MILLISECOND: Int = 1200
    let DAYS_OF_WEEK: Int = 7
    let MONTHS_OF_YEAR: Int = 12;
    let PIE_CHART_VALUE_THRESHOLD: Int = 5
    
    var chartType: Int = 0
    var requestCode: Int = 0
    var dates: [Date] = []
    var userId: String!
    var groupId: String!
    var expenses: [RExpense] = [] {
        didSet {
            invalidateViews()
        }
    }
    
    var timeSlotsLength: Int = 0
    var amountsTime: [Double] = []
    var categoryPositionDictionary: [String : Int] = [:]
    var categories: [RCategory?] = []
    var amounts: [Double] = []
    var latestPosition: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBarChartView()
        setUpPieChartView()
        
        let userDefaults = UserDefaults.standard
        userId = userDefaults.string(forKey: RMember.JsonKey.userId)
        groupId = userDefaults.string(forKey: RMember.JsonKey.groupId)
        
        loadData()
        if chartType == ReportDetailViewController.PIE_CHART {
            setUpPieChartView()
            updatePieChartView()
        } else {
            setUpBarChartView()
            updateBarChartView()
        }
    }
    
    func loadData() {
        if groupId == nil {
            print("No groupId saved")
            return
        }
        
        expenses = Array(RExpense.getExpensesByFiltersAndGroupId(groupId: groupId, member: nil, category: nil, startDate: dates[0], endDate: dates[1]))
        if expenses.count == 0 {
            pieChartView.isHidden = true
            barChartView.isHidden = true
            tableView.isHidden = true
        }
        
        if chartType == ReportDetailViewController.PIE_CHART {
            // Fetch data
            fetchCategoriesAndAmounts()
        } else {
            // Initialize bar chart data set
            switch requestCode {
            case ReportViewController.WEEKLY: timeSlotsLength = DAYS_OF_WEEK + 2
            case ReportViewController.MONTHLY:
                var components = Calendar.current.dateComponents([.day], from: dates[0], to: dates[1])
                timeSlotsLength = components.day! + 3
            case ReportViewController.YEARLY: timeSlotsLength = MONTHS_OF_YEAR + 2
            default: timeSlotsLength = 0
            }
            
            amountsTime = [Double](repeating: 0, count: timeSlotsLength)
            // Fetch data
            fetchTimeAndAmounts()
        }
    }
    
    func invalidateViews() {
        tableView.reloadData()
    }
    
    func fetchCategoriesAndAmounts() {
        for expense in expenses {
            if let position = categoryPositionDictionary[expense.categoryId] {
                print("position: \(position)")
                amounts[position] += expense.amount
            } else {
                let category = RCategory.getCategoryById(id: expense.categoryId)
                
                // Store position of new category into categoryPositionDictionary
                categoryPositionDictionary[expense.categoryId] = categories.count
                // Add new category to list
                categories.append(category)
                // Add first amount to list
                amounts.append(expense.amount)
            }
        }
    }
    
    func fetchTimeAndAmounts() {
        for expense in expenses {
            switch requestCode {
            case ReportViewController.WEEKLY:
                let dateNum = Helpers.getDayOfWeek(date: expense.spentAt)
                amountsTime[dateNum] += expense.amount
            case ReportViewController.MONTHLY:
                let dateNum = Helpers.getDayOfMonth(date: expense.spentAt)
                amountsTime[dateNum] += expense.amount
            case ReportViewController.YEARLY:
                let dateNum = Helpers.getMonthOfYear(date: expense.spentAt)
                amountsTime[dateNum] += expense.amount
            default: break
            }
        }
    }
    /*
     
     // Do any additional setup after loading the view.
     let ys1 = Array(1..<10).map { x in return sin(Double(x) / 2.0 / 3.141 * 1.5) }
     let ys2 = Array(1..<10).map { x in return cos(Double(x) / 2.0 / 3.141) }
     
     let yse1 = ys1.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
     let yse2 = ys2.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
     
     let data = BarChartData()
     let ds1 = BarChartDataSet(values: yse1, label: "Hello")
     ds1.colors = [NSUIColor.red]
     data.addDataSet(ds1)
     
     let ds2 = BarChartDataSet(values: yse2, label: "World")
     ds2.colors = [NSUIColor.blue]
     data.addDataSet(ds2)
     self.barChartView.data = data
     
     self.barChartView.gridBackgroundColor = NSUIColor.white
     
     self.barChartView.chartDescription?.text = "Barchart Demo"
     */
    func setUpBarChartView() {
        // Animate chart
        barChartView.animate(yAxisDuration: TimeInterval(ANIMATION_TIME_MILLISECOND), easingOption: .easeInCubic)
        // Show description on bottom right corner
        barChartView.chartDescription?.text = nil
        // Set min value for x axis
        if expenses.count == 0 {
            barChartView.xAxis.enabled = false
        } else {
            barChartView.xAxis.axisMinimum = 0
            // Set max value for x axis
            barChartView.xAxis.axisMaximum = Double(timeSlotsLength - 1)
            // Hide grid line of x axis
            barChartView.xAxis.drawGridLinesEnabled = false
            // Place x axis to bottom
            barChartView.xAxis.labelPosition = .bottom
        }
        // Hide grid lines from left y axis
        barChartView.leftAxis.drawGridLinesEnabled = false
        // Hide grid lines from right y axis
        barChartView.rightAxis.drawGridLinesEnabled = false
        // Hide right y axis
        barChartView.rightAxis.enabled = false
        // Hide left y axis
        barChartView.leftAxis.enabled = false
    }
    
    func updateBarChartView() {
        barChartView.xAxis.valueFormatter = MyAixsValueFormatter(requestCode: requestCode, timeSlotsLength: timeSlotsLength)
        barChartView.animate(xAxisDuration: 1000, easingOption: .easeInCubic)
        
        var colors: [NSUIColor] = []
        for c in ChartColorTemplates.colorful() {
            colors.append(c);
        }
        for c in ChartColorTemplates.joyful() {
            colors.append(c);
        }
        for c in ChartColorTemplates.pastel() {
            colors.append(c);
        }
        for c in ChartColorTemplates.liberty() {
            colors.append(c);
        }
        
        var entries: [BarChartDataEntry] = []
        
        for i in 0..<timeSlotsLength - 1 {
            entries.append(BarChartDataEntry(x: Double(i), y: amountsTime[i]))
        }
        
        let dataSet = BarChartDataSet(values: entries, label: nil)
        dataSet.colors = colors
        dataSet.formSize = 10
        
        let dataSets: [IBarChartDataSet] = [dataSet]
        let data = BarChartData(dataSets: dataSets)
        // Default x axis width is 1, bar width is 0.9, spacing is 0.1
        data.barWidth = 0
        data.setValueFormatter(BarValueFormatter())
        
        barChartView.data = data
        // Disable scalable
        barChartView.setScaleEnabled(false)
        // Disable tab to highlight
        barChartView.highlightPerTapEnabled = false
        // Disable highlight during drag
        barChartView.highlightPerDragEnabled = false
        
        let isCurrentFrame: Bool = Date() <= dates[1]
        switch(requestCode) {
        case ReportViewController.WEEKLY:
            // Limit view port to smaller data set
            barChartView.setVisibleXRangeMaximum(9)
            break;
        case ReportViewController.MONTHLY:
            // Limit view port to smaller data set
            barChartView.setVisibleXRangeMaximum(7)
            if (isCurrentFrame) {
                latestPosition = Helpers.getDayOfMonth(date: Date())
            } else {
                latestPosition = Calendar.current.dateComponents([.day], from: dates[0], to: dates[1]).day! + 1
            }
            barChartView.moveViewToX(Double(max(latestPosition - 5, 0)))
            break;
        case ReportViewController.YEARLY:
            // Limit view port to smaller data set
            barChartView.setVisibleXRangeMaximum(7)
            if (isCurrentFrame) {
                latestPosition = Helpers.getMonthOfYear(date: Date())
            } else {
                latestPosition = MONTHS_OF_YEAR;
            }
            barChartView.moveViewToX(Double(max(latestPosition - 6, 0)))
        default: break
        }
    }
    /*
     
     // Do any additional setup after loading the view.
     let ys1 = Array(1..<10).map { x in return sin(Double(x) / 2.0 / 3.141 * 1.5) * 100.0 }
     
     let yse1 = ys1.enumerated().map { x, y in return PieChartDataEntry(value: y, label: String(x)) }
     
     let data = PieChartData()
     let ds1 = PieChartDataSet(values: yse1, label: "Hello")
     
     ds1.colors = ChartColorTemplates.vordiplom()
     
     data.addDataSet(ds1)
     
     let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
     paragraphStyle.lineBreakMode = .byTruncatingTail
     paragraphStyle.alignment = .center
     let centerText: NSMutableAttributedString = NSMutableAttributedString(string: "Charts\nby Daniel Cohen Gindi")
     centerText.setAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 15.0)!, NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, centerText.length))
     centerText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 13.0)!, NSForegroundColorAttributeName: UIColor.gray], range: NSMakeRange(10, centerText.length - 10))
     centerText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-LightItalic", size: 13.0)!, NSForegroundColorAttributeName: UIColor(red: 51 / 255.0, green: 181 / 255.0, blue: 229 / 255.0, alpha: 1.0)], range: NSMakeRange(centerText.length - 19, 19))
     
     self.pieChartView.centerAttributedText = centerText
     
     self.pieChartView.data = data
     
     self.pieChartView.chartDescription?.text = "Piechart Demo"
     
     }
     */
    func setUpPieChartView() {
        // Animate chart
        pieChartView.animate(yAxisDuration: TimeInterval(ANIMATION_TIME_MILLISECOND), easingOption: .easeInCirc)
        // Show description on bottom right corner
        pieChartView.chartDescription?.text = nil
        // Disable label on pie chart
        pieChartView.drawEntryLabelsEnabled = false
        // Set legends
        let legend = pieChartView.legend
//        legend.position = .rightOfChart
        legend.horizontalAlignment = .right
        legend.xEntrySpace = 7
        legend.yEntrySpace = 0
        legend.yOffset = 0
    }
    
    func updatePieChartView() {
        // Get colors from categories
        var colors: [NSUIColor] = []
        for category in categories {
            if let category = category {
                colors.append(NSUIColor.HexToColor(hexString: category.color))
            } else {
                colors.append(NSUIColor.lightGray)
            }
        }
        
        // Calculate total expense
        var totalAmount: Double = 0
        print("categories count: \(categories.count)")
        for i in 0..<categories.count {
            totalAmount += amounts[i]
        }
        
        // Update entries
        var entries: [PieChartDataEntry] = []
        for i in 0..<categories.count {
            // Calculate percentage
            let percentage = 10000 * amounts[i] / totalAmount
            let newValue = Int(percentage)
            entries.append(PieChartDataEntry(value: Double(newValue) / 100, label: categories[i] != nil ? categories[i]!.name : "No Category"))
        }
        // Create dataset
        let dataSet = PieChartDataSet(values: entries, label: "")
        dataSet.sliceSpace = 3
        // Set data text size
        dataSet.formSize = 12
        // Add colors list
        dataSet.colors = colors
        // Create data
        let data = PieChartData(dataSet: dataSet)
        // Set value color
        data.setValueTextColor(NSUIColor.white)
        // Set data value format
        data.setValueFormatter(PieValueFormatter())
        
        pieChartView.data = data
    }
    
    class PieValueFormatter: DefaultValueFormatter {
        let PIE_CHART_VALUE_THRESHOLD: Double = 5
        override func stringForValue(_ value: Double, entry: ChartDataEntry,
                                     dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            if value <= PIE_CHART_VALUE_THRESHOLD {
                return "";
            }
            return "\(value)%";
        }
    }
    
    class BarValueFormatter: DefaultValueFormatter {
        override func stringForValue(_ value: Double, entry: ChartDataEntry,
                                     dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            return value != 0.0 ? Helpers.getFormattedAmount(amount: value) : ""
        }
    }
    
    class MyAixsValueFormatter: DefaultAxisValueFormatter {
        var requestCode: Int = 0
        var timeSlotsLength: Int = 0
        
        init(requestCode: Int, timeSlotsLength: Int) {
            super.init()
            self.requestCode = requestCode
            self.timeSlotsLength = timeSlotsLength
        }
        
        override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            if value == 0 || value.truncatingRemainder(dividingBy: 1) != 0 || value > Double(timeSlotsLength - 2) {
                return ""
            }
            let pos = Int(value)
            
            switch(requestCode) {
            case ReportViewController.WEEKLY:
                return Helpers.getDayOfWeekString(day: pos);
            case ReportViewController.MONTHLY:
                return Helpers.getDayOfMonthString(day: pos);
            case ReportViewController.YEARLY:
                return Helpers.getMonthOfYearString(month: pos);
            default: break
            }
            return ""
        }
    }
}
