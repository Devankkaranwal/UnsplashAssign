//
//  SelectedImageClass.swift
//  UnsplashAssignment
//
//  Created by Devank on 14/04/24.
//

import Foundation

struct SelectedImageClass {
    var description: String
    var urls: Urls?
}

class SelectedImageSingleton {
    static let selectedSelectedImage = SelectedImageSingleton()
    var selectedImage : SelectedImageClass!
    private init() {
    }
}
