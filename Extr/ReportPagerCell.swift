//
//  ReportPagerCell.swift
//  Extr
//
//  Created by Zekun Wang on 12/6/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class ReportPagerCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    let categoryReportRankCellString = "CategoryReportRankCell"
    
    var requestCode: Int = -1
    var dates: [Date] = [] {
        didSet {
            var timeString = ""
            switch requestCode {
            case ReportViewController.WEEKLY: timeString = Helpers.getReportWeeklyDateString(dates: dates)
            case ReportViewController.MONTHLY: timeString = Helpers.getReportMonthlyDateString(dates: dates)
            case ReportViewController.YEARLY: timeString = Helpers.getReportYearlyDateString(dates: dates)
            default: break;
            }
            
            timeLabel.text = timeString
        }
    }
    
    var categoryIds: [String] = []
    var categoryDictionary: [String : Double] = [:] {
        didSet {
            if categoryDictionary.count == 0 {
                containerView.isHidden = true
                amountLabel.text = "$0"
                return
            }
            
            containerView.isHidden = false
            var total: Double = 0
            let sortedDictionary = categoryDictionary.sorted {$0.value > $1.value}

            for pair in categoryDictionary {
                total += pair.value
            }

            amountLabel.text = "$\(Helpers.getFormattedAmount(amount: total))"
            
            categoryIds = []
            for i in 0..<min(sortedDictionary.count, 6) {
                categoryIds.append(sortedDictionary[i].key)
            }
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: categoryReportRankCellString, bundle: nil), forCellWithReuseIdentifier: categoryReportRankCellString)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: 43, height: 35)
        collectionView.collectionViewLayout = flowLayout
        collectionView.isScrollEnabled = false
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryIds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryReportRankCellString, for: indexPath) as! CategoryReportRankCell
        cell.categoryId = categoryIds[indexPath.row]
        return cell
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
