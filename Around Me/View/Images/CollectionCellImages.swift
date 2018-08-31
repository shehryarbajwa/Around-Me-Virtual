//
//  CollectionCellImages.swift
//  Aroundme
//
//  Created by Shehryar Bajwa on 2018-08-27.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit

class CustomImageView: UIImageView {
    
    func downloadImage(stringURL: String,  completionHandler: @escaping() -> Void){
        self.image = nil
        print("applejobs")
        
        guard let url = URL(string: stringURL) else {return}
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {return}
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
                completionHandler()
            }
        }
    }
}
