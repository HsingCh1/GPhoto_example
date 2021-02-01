//
//  File.swift
//  GPhoto_test
//
//  Created by cin on 2021/2/1.
//

import Foundation
import GPhotos

class PhotoDocument: ObservableObject {
    @Published var items: [MediaItem] = []
    @Published var currentPhoto: UIImage? = nil

    var photoIndex = 0
    
    func listMediaItems() {
        let request = MediaItemsSearch.Request()
        GPhotosApi.mediaItems.search(with: request) { items in
            self.items.append(contentsOf: items)
        }        
    }
    
    func showListItems(atInstex index: Int = 0) {
        if let url = items[photoIndex].baseUrl {
            DispatchQueue.global(qos: .userInitiated).async {
                if let photoData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.currentPhoto = UIImage(data: photoData) ?? nil
                    }
                }
            }
        }
    }
    
    func pagingPhoto(_ indexChange: Int) {
        if indexChange < 0 && photoIndex + indexChange >= 0 {
            showListItems(atInstex: photoIndex + indexChange)
            photoIndex += indexChange
        }
        else if indexChange > 0 && photoIndex+indexChange < items.count {
            showListItems(atInstex: photoIndex+indexChange)
            photoIndex += indexChange
            if self.photoIndex == items.count - 1 {
                listMediaItems()
            }
        }
    }

}
