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
    
    var countryDetailArray : [CountryDetail]?

    

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
            
            DispatchQueue.main.async {
                
                if let countryDetail = countrydata?.rows{
                    self?.countryDetailArray = countryDetail
                }
                self?.navigationItem.title = countrydata?.title
                self?.collectionview.reloadData()
                
            }
            
        })
    }
    
    @objc func refreshAction(){
        fetchData()
    }
    
    
    //Create the collectionView and constraint to the collectionView
    func setUpCollectionView(){
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        collectionview = UICollectionView(frame:self.view.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        layout.estimatedItemSize = CGSize(width: 1.0, height: 1.0)
        
        collectionview.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionview.backgroundColor = UIColor.white
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(collectionview)
        
        self.collectionview.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.collectionview.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.collectionview.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.collectionview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    //MARK: - CollectionView Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return countryDetailArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCollectionViewCell
        
        cell.countryDetail = countryDetailArray?[indexPath.item]
        return cell
    }
    

    
    
   

}
