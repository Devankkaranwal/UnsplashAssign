//
//  HomeCollectionViewController.swift
//  UnsplashAssign
//
//  Created by Devank on 18/04/24.
//

import UIKit
import CHTCollectionViewWaterfallLayout


class HomeCollectionViewController: UICollectionViewController,CHTCollectionViewDelegateWaterfallLayout {
    
    var viewModel: HomeViewModel!
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = HomeViewModel()
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }

        setUpImageList()
        viewModel.getHotPhotos()
    }

    
    
    
    func performNavigationToImageInfo(imageData: HomeImage) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageInfoViewController") as? ImageInfoViewController {
            let data: SelectedImageClass = SelectedImageClass(description: imageData.description ?? "NA", urls: imageData.urls!)
            SelectedImageSingleton.selectedSelectedImage.selectedImage = data
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    
    
    func goToImageInfo(imageData: HomeImage) {
            viewModel.goToImageInfo(imageData: imageData)
        }
    
    
    private func setUpImageList() {
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collectionView.delegate = self
            collectionView.dataSource = self
            
            let layout = CHTCollectionViewWaterfallLayout()
            layout.itemRenderDirection = .leftToRight
            layout.columnCount = 2
            layout.sectionInset = UIEdgeInsets(top: 1.0, left: 8.0, bottom: 0, right: 8.0)
            collectionView.setCollectionViewLayout(layout, animated: true)
        }
    
    

  
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
           viewModel.scrollViewDidScroll(scrollView)
       }
    
    // MARK: UICollectionViewDataSource
       
       override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return viewModel.newPhotos.count
       }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeItem", for: indexPath as IndexPath) as! ImageItem
          let item = viewModel.newPhotos[indexPath.row]
          cell.setimages(item: item, isFile: false)
          return cell
      }
    
    
    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let item = viewModel.newPhotos[indexPath.row]
            let h = item.height ?? 0
            return CGSize(width: CGFloat(item.width ?? 0), height: CGFloat(h))
        }
        
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let item = viewModel.newPhotos[indexPath.item]
            performNavigationToImageInfo(imageData: item)
        }
}
