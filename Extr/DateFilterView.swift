//
//  DateFilterView.swift
//  Extr
//
//  Created by Zekun Wang on 11/29/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class DateFilterView: UIView {

    @IBOutlet var startDateSwitch: UISwitch!
    @IBOutlet var endDateSwitch: UISwitch!
    @IBOutlet var startDatePicker: UIDatePicker!
    @IBOutlet var endDatePicker: UIDatePicker!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    var expenseViewController: ExpenseViewController?
    var reportExpenseViewController: ReportExpenseViewController?
    var grayoutView: UIView!
    var startDate: Date! {
        didSet {
            startDateSwitch.isOn = startDate != nil
            print("date: \(startDate)")
            if startDate == nil {
                let calendar = Calendar.current
                let date = startDate == nil ? Date() : startDate
                var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
                components.hour = 0
                components.minute = 0
                components.second = 0
                
                startDatePicker.setDate(calendar.date(from: components)!, animated: false)
            } else {
                startDatePicker.setDate(startDate, animated: false)
            }
            
            startDatePicker.isEnabled = startDate != nil
        }
    }
    
    var endDate: Date! {
        didSet {
            endDateSwitch.isOn = endDate != nil
            
            if endDate == nil {
                let calendar = Calendar.current
                let date = endDate == nil ? Date() : endDate
                var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
                components.hour = 23
                components.minute = 59
                components.second = 59
                endDatePicker.setDate(calendar.date(from: components)!, animated: false)
            } else {
                endDatePicker.setDate(endDate, animated: false)
            }
            
            endDatePicker.isEnabled = endDate != nil
        }
    }
    
    func saveDates() {
        if expenseViewController == nil && reportExpenseViewController == nil {
            return
        }
        expenseViewController?.startDate = startDateSwitch.isOn ? startDatePicker.date : nil
        expenseViewController?.endDate = endDateSwitch.isOn ? endDatePicker.date : nil
        expenseViewController?.loadData()
        
        reportExpenseViewController?.startDate = startDateSwitch.isOn ? startDatePicker.date : nil
        reportExpenseViewController?.endDate = endDateSwitch.isOn ? endDatePicker.date : nil
        reportExpenseViewController?.loadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 25
        self.backgroundColor = UIColor.white
        let smallSize = UIScreen.main.bounds.width - 16
        self.layer.frame.size.width = min(350, smallSize)
    }
    
    @IBAction func startDateSwitchChanged(_ sender: UISwitch) {
        startDatePicker.isEnabled = sender.isOn
    }
    
    @IBAction func endDateSwitchChanged(_ sender: UISwitch) {
        endDatePicker.isEnabled = sender.isOn
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
        saveDates()
        cancelClicked(cancelButton)
    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        grayoutView?.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
