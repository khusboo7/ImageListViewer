//
//  ImageCollectionViewCell.swift
//  ImageListViewer
//
//  Created by khusboo on 23/10/18.
//  Copyright © 2018 Khusboo. All rights reserved.
//

import UIKit


class ImageCollectionViewCell: UICollectionViewCell {
    
    var imageHeightConstraint : NSLayoutConstraint!
    let imageCache = NSCache<NSString,UIImage>()
    let imageViewDefaultHeight : CGFloat = 100.0

    
    let contentview : UIView = {
    
       let viewContent = UIView(frame: CGRect.zero)
        viewContent.translatesAutoresizingMaskIntoConstraints = false
       return viewContent
    
    }()
    
    
   
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView : UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "placeholder")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let separatorView : UIView = {
       let viewSeparator = UIView()
        viewSeparator.translatesAutoresizingMaskIntoConstraints = false
        viewSeparator.backgroundColor = UIColor.lightGray
        return viewSeparator
    }()
    
    var countryDetail : CountryDetail? {
        didSet {
            
            titleLabel.text = countryDetail?.title
            descriptionLabel.text = countryDetail?.description

            
            
            if let imageUrl = countryDetail?.imageHref{
                if let cachedImage = self.imageCache.object(forKey: imageUrl as NSString) {
                    imageHeightConstraint.constant = imageViewDefaultHeight
                    self.imageView.image = cachedImage

                }
                else{
                self.imageView.image = UIImage(named: "placeholder")
                NetworkManager.shared().downloadImage(with: imageUrl, onCompletion: {
                    [weak self] responseData in
                    if let data = responseData{
                        self?.imageHeightConstraint.constant = (self?.imageViewDefaultHeight)!
                        self?.contentview.layoutIfNeeded()

                        self?.imageView.image = UIImage(data: data)
                        if let image = self?.imageView.image{
                        self?.imageCache.setObject(image, forKey: imageUrl as NSString)
                        }
                        else{
                            self?.imageView.image = UIImage(named: "placeholder")
                            
                        }
                    }
                    else{

                        self?.imageView.image = UIImage(named: "placeholder")


                    }
                    
                })
                }
                
            }
            else{
                imageHeightConstraint.constant = 0.0

            }
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.contentview)
        self.contentview.translatesAutoresizingMaskIntoConstraints = false

        
        contentview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        contentview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        contentview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        contentview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true

        
        let screenwidth = UIScreen.main.bounds.size.width
        self.contentview.widthAnchor.constraint(equalToConstant: screenwidth - 40).isActive = true

        
        
        addConstraintToViews()
        
    }
    
    func addConstraintToViews(){
        self.contentview.addSubview(imageView)
        self.contentview.addSubview(titleLabel)
        self.contentview.addSubview(descriptionLabel)
        self.contentview.addSubview(separatorView)
        
        
        
        imageView.topAnchor.constraint(equalTo: self.contentview.topAnchor, constant: 5).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageViewDefaultHeight).isActive = true
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageViewDefaultHeight)
        imageView.leadingAnchor.constraint(equalTo: self.contentview.leadingAnchor, constant: 8).isActive = true
        imageHeightConstraint.isActive = true

        
        titleLabel.leadingAnchor.constraint(equalTo: self.contentview.leadingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.contentview.trailingAnchor, constant: 0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 8).isActive = true


        descriptionLabel.leadingAnchor.constraint(equalTo: self.contentview.leadingAnchor, constant: 8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.contentview.trailingAnchor, constant: 0).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: self.contentview.bottomAnchor, constant: 0).isActive = true
        
        separatorView.leadingAnchor.constraint(equalTo: self.contentview.leadingAnchor, constant: 0).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: self.contentview.trailingAnchor, constant: 0).isActive = true
//        separatorView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 2).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: self.contentview.bottomAnchor, constant: 10).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
   
    

    
    
}
