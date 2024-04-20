//
//  ImageItem.swift
//  UnsplashAssignment
//
//  Created by Devank on 14/04/24.
//

import UIKit

class ImageItem: UICollectionViewCell {
    
    
    @IBOutlet weak var imageviewItem: UIImageView!
    
    let blur_hash = ""
    
    override func awakeFromNib() {
        imageviewItem.makeRounded()
    }
    
    func setimages(item: HomeImage, isFile: Bool) {
        let height = item.height! / 120
        let width = item.width! / 120
        let hash = item.blur_hash ?? blur_hash
        let size = CGSize(width: CGFloat(width), height: CGFloat(height))
        
        DispatchQueue.global().async {
            if let url = URL(string: item.urls?.small ?? "") {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.imageviewItem.image = image
                    }
                }
            }
        }
    }


    
    func setLocalImage(url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.imageviewItem.image = image
                }
            }
        }
    }

    
}


