//
//  HomeViewModel.swift
//  UnsplashAssign
//
//  Created by Devank on 18/04/24.
//

import Foundation
import UIKit

class HomeViewModel {
    
    var newPhotos: [HomeImage] = [] {
            didSet {
                onDataUpdate?()
            }
        }
    
    
    var onDataUpdate: (() -> Void)?
    var pageNumber: Int = 0
    var isPageRefreshing: Bool = false
    var goToImageInfoAction: ((HomeImage) -> Void)?
    
  
    
    func getHotPhotos() {
            if newPhotos.isEmpty {
                // Show loader
            }

            let url = URL(string: "\(AppConst.baseurl)\(AppConst.photoUrl)?client_id=\(AppConst.clinetid)&order_by=latest&page=\(pageNumber)&per_page=100")!
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self = self else { return }

                guard let data = data, error == nil else {
                    // Handle error
                    self.isPageRefreshing = false
                    return
                }

                // Print the response
                if let httpResponse = response as? HTTPURLResponse {
                    print("API Response Status Code: \(httpResponse.statusCode)")
                }
                if let responseString = String(data: data, encoding: .utf8) {
                    print("API Response: \(responseString)")
                }

                do {
                    let photos = try JSONDecoder().decode([HomeImage].self, from: data)
                    self.newPhotos.append(contentsOf: photos)
                    DispatchQueue.main.async {
                        self.onDataUpdate?()
                        // Hide loader
                        self.isPageRefreshing = false
                    }
                } catch {
                    // Handle decoding error
                    self.isPageRefreshing = false
                }
            }
            task.resume()
        }

    
    

    
    func goToImageInfo(imageData: HomeImage) {
           goToImageInfoAction?(imageData)
       }
    
    
    
    
    
    // MARK: On end Scroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                pageNumber += 1
                getHotPhotos()
            }
        }
    }
 
    
}



