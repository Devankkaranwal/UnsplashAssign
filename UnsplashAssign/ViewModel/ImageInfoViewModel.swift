//
//  ImageInfoViewModel.swift
//  UnsplashAssign
//
//  Created by Devank on 18/04/24.
//

import UIKit
import Photos

class ImageInfoViewModel {
    
    var localFile: Bool = false
    var localImageUrl: URL?
    var selectedImage: SelectedImageClass
    var image: UIImage?
    var onImageUpdate: ((UIImage?) -> Void)?
    
    init(selectedImage: SelectedImageClass) {
        self.selectedImage = selectedImage
    }
    
    func loadImage() {
        if localFile {
            if let localImageUrl = localImageUrl {
                image = UIImage(contentsOfFile: localImageUrl.path)
                onImageUpdate?(image)
            }
        } else {
            let imageUrlString = selectedImage.urls?.regular ?? "https://cdn.pixabay.com/photo/2021/08/25/20/42/field-6574455__480.jpg"
            if let imageUrl = URL(string: imageUrlString) {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: imageUrl) {
                        if let loadedImage = UIImage(data: imageData) {
                            self.image = loadedImage
                            self.onImageUpdate?(loadedImage)
                        }
                    }
                }
            }
        }
    }
    
    func saveToStorage(completion: @escaping (Bool) -> Void) {
        if let image = image, let data = image.jpegData(compressionQuality: 1.0) {
            let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            if let topViewController = UIApplication.shared.windows.first?.rootViewController {
                topViewController.present(activityViewController, animated: true, completion: nil)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func saveToCameraRoll(completion: @escaping (Bool) -> Void) {
            if let image = image {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { success, error in
                    DispatchQueue.main.async {
                        completion(success)
                    }
                }
            } else {
                completion(false)
            }
        }
    
   
    
    
}
