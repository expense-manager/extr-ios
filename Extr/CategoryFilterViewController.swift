//
//  CategoryFilterViewController.swift
//  Extr
//
//  Created by Zekun Wang on 11/29/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class CategoryFilterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    
    let categoryFilterCell = "CategoryFilterCell"
    var expenseViewController: ExpenseViewController!
    var reportExpenseViewController: ReportExpenseViewController!
    var selectedCategory: RCategory?
    var userId: String!
    var groupId: String!
    var categories: [RCategory?] = [] {
        didSet {
            invalidateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: categoryFilterCell, bundle: nil), forCellWithReuseIdentifier: categoryFilterCell)
        
        // UICollectionViewFlowLayout
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let screenWidth = UIScreen.main.bounds.width
        print("screen width: \(screenWidth)")
        flowLayout.itemSize = CGSize(width: screenWidth/3 - 10, height: 120);
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 10
        self.collectionView.collectionViewLayout = flowLayout
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blankOnTap))
    }
    
    func blankOnTap(sender : UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    func invalidateViews() {
        if viewIfLoaded == nil {
            return
        }
        
        collectionView.reloadData()
    }
    
    func loadData() {
        let userDefault = UserDefaults.standard
        self.userId = userDefault.string(forKey: RMember.JsonKey.userId)
        self.groupId = userDefault.string(forKey: RMember.JsonKey.groupId)
        
        if self.groupId == nil {
            print("no group saved")
            return
        }
        
        var array: [RCategory?] = []
        array.append(nil)
        let sortedCategory = RCategory.getCategoriesByGroupId(groupId: groupId)
        for category in sortedCategory {
            array.append(category)
        }
        categories = array
        
        SyncCategory.getAllCategoriesByGroupId(groupId: groupId, success: { (categories: [RCategory]) -> () in
            var array: [RCategory?] = []
            array.append(nil)
            let sortedCategory = categories.sorted{ $0.0.name < $0.1.name }
            for category in sortedCategory {
                array.append(category)
            }
            self.categories = array
            print("caategories count: \(self.categories.count)")
        }) { (error: Error) -> () in
            print(error)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryFilterCell, for: indexPath) as! CategoryFilterCell
        cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        let category = categories[indexPath.row]
        if selectedCategory != nil && category != nil {
            cell.isSelectedCategory = selectedCategory!.id == category!.id
        } else if selectedCategory != nil && category == nil {
            cell.isSelectedCategory = selectedCategory!.id == ""
        } else {
            cell.isSelectedCategory = false
        }
        cell.category = category
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var category: RCategory? = categories[indexPath.row]
        if category == nil {
            category = RCategory()
            category!.id = ""
        }
        if selectedCategory != nil && category!.id == selectedCategory!.id {
            category = nil
        }
        expenseViewController?.setCategoryFilter(category: category)
        reportExpenseViewController?.setCategoryFilter(category: category)
        collectionView.deselectItem(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
        //self.view.removeFromSuperview()
    }
}
