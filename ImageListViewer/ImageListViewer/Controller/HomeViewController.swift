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

        fetchData()
        
       

        
        
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return countryDetailArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCollectionViewCell
        
        cell.countryDetail = countryDetailArray?[indexPath.item]
        //cell.imageView.backgroundColor = UIColor.red
        return cell
    }
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
