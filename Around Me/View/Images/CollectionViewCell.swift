//
//  CollectionViewCell.swift
//  Aroundme
//
//  Created by Shehryar Bajwa on 2018-08-27.
//  Copyright © 2018 Shehryar. All rights reserved.
//
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var highlightedView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
  
    var photo: Photos?{
        
        didSet{
            guard let url = photo?.url else {
                return
            }
            self.showActivityIndicator(true)
            
            if let imageData = photo?.image {
                self.showActivityIndicator(false)
                let image = UIImage(data: imageData)
                mainImageView.image = image
            } else {
                print("No existing photos found")
                downloadImage(url)
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.layer.cornerRadius = 2
        showActivityIndicator(false)
    }
    
    func showActivityIndicator(_ show: Bool){
        self.activityIndicator.isHidden = !show
        show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func downloadImage(_ stringURL: String){
        self.isUserInteractionEnabled = false
        mainImageView.downloadImage(stringURL: stringURL) {
            print("downloading")
            guard let image = self.mainImageView.image else {return}
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            self.photo?.image = imageData
            if CoreDataManager.share.saveContext(){
                self.showActivityIndicator(false)
                self.isUserInteractionEnabled = true
            }
        }
    }
}
