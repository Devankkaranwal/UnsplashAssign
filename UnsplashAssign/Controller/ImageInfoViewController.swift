//
//  ImageInfoViewController.swift
//  UnsplashAssignment
//
//  Created by Devank on 14/04/24.
//

import UIKit

class ImageInfoViewController: UIViewController {
        
    @IBOutlet weak var infoImageView: UIImageView!
       
       var viewModel: ImageInfoViewModel!
       
       override func viewDidLoad() {
           super.viewDidLoad()
           viewModel = ImageInfoViewModel(selectedImage: SelectedImageSingleton.selectedSelectedImage.selectedImage)
           bindViewModel()
       }
       
       func bindViewModel() {
           viewModel.onImageUpdate = { [weak self] image in
               DispatchQueue.main.async {
                   self?.infoImageView.image = image
               }
           }
           viewModel.loadImage()
       }
    
       
@IBAction func downloadButtonOnClick(_ sender: Any) {
    
    if viewModel.localFile {
        saveToStorage()
    } else {
        askWhereToSave()
    }
    }
        
    
    
    
    func askWhereToSave() {
        let alertController = UIAlertController(title: viewModel.selectedImage.description, message: "Select where to save image", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Camera Roll", style: .default) { _ in
            self.showDownloadOption(pathType: .cameraRoll)
        })
        alertController.addAction(UIAlertAction(title: "Save to Files", style: .default) { _ in
            self.showDownloadOption(pathType: .phoneStorage)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true, completion: nil)
    }
    

    
    func showDownloadOption(pathType:imagePathType) {
        var imageURLLocal: String!
        var actionsButtons :[UIAlertAction] = []
        
        var urlList :[DownlodClass] = []
        let url1 = DownlodClass(title: "Small", subTitle: "Smallest size", url: viewModel.selectedImage.urls?.small ?? "", size: "1MB+")
        let url2 = DownlodClass(title: "Regular", subTitle: "For mobile wallpaper", url: viewModel.selectedImage.urls?.regular ?? "", size: "3MB+")
        let url3 = DownlodClass(title: "Full", subTitle: "For Desktop", url: viewModel.selectedImage.urls?.full ?? "", size: "6MB+")
        let url4 = DownlodClass(title: "Raw", subTitle: "Original file", url: viewModel.selectedImage.urls?.raw ?? "", size: "10MB+")
        urlList = [url1,url2,url3,url4]
        
        
        for urls in urlList {
            let urlButton = UIHelper().makeUIAlertButton(title: urls.title, style: UIAlertAction.Style.default, actionFunction: {
                imageURLLocal = urls.url
                
                if(pathType == imagePathType.phoneStorage){
                    let imageData : UIImage = DownloadHelper().createUIImage(url: imageURLLocal)
                    DownloadHelper().shareImage(imageData: [imageData], vc: self)
                }
                if(pathType == imagePathType.cameraRoll){
                    let imageData : UIImage = DownloadHelper().createUIImage(url: imageURLLocal)
                    UIImageWriteToSavedPhotosAlbum(imageData, self, #selector(self.saveCompleted), nil)
                }
            })
            actionsButtons.append(urlButton)
        }
        
        UIHelper().showBootmSheet(title: viewModel.selectedImage.description, message: "Select image quality", vc: self, actionsList: actionsButtons)
    }
    
    
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print("Error!")
            
        } else {
            UIHelper().showAlertAction(title: "Image Saved", message: "Image is saved to you camera rool you can check now.", vc: self, actionClosure: {
                print("Ok Taped")
            })
        }
    }
    
    
    func saveToStorage() {
            if let imageData = try? Data(contentsOf: viewModel.localImageUrl ?? URL(fileURLWithPath: "path_to_default_image")), let image = UIImage(data: imageData)
        
        {
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        }
    }
    

    
    
   }
    
    
