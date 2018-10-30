//
//  HomeViewController.swift
//  ImageListViewer
//
//  Created by khusboo on 23/10/18.
//  Copyright © 2018 Khusboo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var collectionview : UICollectionView!
    var cellId = "Cell"
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let cellMaxPadding : CGFloat = 150.0
    let cellMinPadding : CGFloat = 50.0
    let contentInset : CGFloat = 64.0


    var countryDetailArray = [CountryDetail]()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: UIBarButtonItemStyle.plain, target: self, action:#selector(refreshAction))
        fetchData()
    }
    
    // Fetch the data from the api and reload the collectionView
    func fetchData(){
        NetworkManager.shared().processRequest(completion: {
            [weak self] (countrydata,response,error) in
            if let error = error{
                let alertController = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction) in
                }
                
                
                alertController.addAction(action)
                self?.present(alertController, animated: true, completion: nil)
                
                
                
            }
            else{
            DispatchQueue.main.async {
                
                if let _ = countrydata{
                
                if let countryDetail = countrydata?.rows{
                    self?.countryDetailArray = countryDetail
                    self?.countryDetailArray = countryDetail.filter({ (model) -> Bool in
                        if model.title == nil &&  model.description == nil && model.imageHref == nil {
                            return false
                        }
                        else{
                            return true
                        }
                        
                    })
                    
                }
                self?.navigationItem.title = countrydata?.title
                self?.collectionview.reloadData()
                }
                
            }
            }
            
        })
    }
    
    @objc func refreshAction(){
        fetchData()
    }
    
    
    //Create the collectionView and constraint to the collectionView
    func setUpCollectionView(){
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        collectionview = UICollectionView(frame:self.view.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        
        collectionview.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionview.backgroundColor = UIColor.white
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(collectionview)
        
        self.collectionview.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.collectionview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.collectionview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.collectionview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    //MARK: - CollectionView Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return countryDetailArray.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCollectionViewCell
        
        cell.countryDetail = countryDetailArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = self.view.frame.size.width
        let countryDetail = countryDetailArray[indexPath.item]
        var titleHeight : CGFloat = 0.0
        var descriptionHeight : CGFloat = 0.0
        var cellHeight : CGFloat = 0.0

        if let titleText = countryDetail.title{
        titleHeight = getHeightForLable(labelWidth: screenWidth - cellMinPadding , labelText: titleText, labelFont: UIFont.boldSystemFont(ofSize: 14))
        }
        
        if let descriptionText = countryDetail.description{
            descriptionHeight = getHeightForLable(labelWidth: screenWidth - cellMinPadding , labelText: descriptionText, labelFont: UIFont.systemFont(ofSize: 12))
        }
        if let _ = countryDetail.imageHref{
            cellHeight = titleHeight + descriptionHeight + cellMaxPadding
        }
        else{
            if titleHeight > 0.0 && descriptionHeight > 0.0{
            cellHeight = titleHeight + descriptionHeight + cellMinPadding
            }
        }
        return CGSize(width: self.view.frame.size.width - cellMinPadding, height: cellHeight)
    }
    
    //Calculate Label height
    func getHeightForLable(labelWidth: CGFloat, numberOfLines: Int = 0, labelText: String, labelFont: UIFont) -> CGFloat {
        let tempLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
        tempLabel.numberOfLines = numberOfLines
        tempLabel.text = labelText
        tempLabel.font = labelFont
        tempLabel.sizeToFit()
        return tempLabel.frame.height
    }
    

    
    
   

}
