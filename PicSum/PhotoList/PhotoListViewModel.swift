//
//  PhotoListViewModel.swift
//  PicSum
//
//  Created by Arjuna on 09/06/19.
//  Copyright © 2019 Arjuna. All rights reserved.
//

import Foundation

class PhotoItemViewModel {
    let photo:Photo
    
    init(photo:Photo) {
        self.photo = photo
    }
    var id:String {
        return photo.id
    }
    
    var author:String {
        return photo.author
    }
    
    var width:Int {
        return photo.width
    }
    
    var height:Int {
        return photo.height
    }
    
    func downloadUrlFor(width:Int?,height:Int?) -> String {
        guard let width = width, let height = height else {
            return photo.downloadUrl
        }
        return "https://picsum.photos/id/\(id)/\(width)/\(height)"
    }
    
    var itemTapped:(()->())!
}

protocol PhotoListViewProtocol:class {
    func reloadPhotos()
    func showLoadingIndictor()
    func hideLoadingIndicator()
    func showDetails()
}

class PhotoListViewModel {
    weak var view:PhotoListViewProtocol?
    
    var photoListDataProvider = PhotoServiceProvider()
    var pageSize = 30
    
    private var hasMorePhotos = false
    private var photoItemViewModels:[PhotoItemViewModel] = []
    private var requestInProgress = false
    private(set) var viewModelForDetailView:PhotoItemViewModel!
    
    init(view:PhotoListViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        self.view?.showLoadingIndictor()
        self.fetchPhotos(1, pageSize)
    }
    
    func numberOfPhotoItemModels() -> Int {
        return photoItemViewModels.count
    }
    
    func photoItemViewModelAtIndex(index:Int) -> PhotoItemViewModel {
        fetchNextPagePhotosIfNeeded(index)
        return self.photoItemViewModels[index]
    }
    
    private func fetchNextPagePhotosIfNeeded(_ currentRequestedIndex:Int) {
        guard self.hasMorePhotos else {
            return
        }
        
        if currentRequestedIndex == (self.photoItemViewModels.count - 1) {
            self.view?.showLoadingIndictor()
        }
        
        if (requestInProgress) {
            return
        }
        
        let lastFetchedPage = (self.photoItemViewModels.count / pageSize)
        let currentIndexPage = (currentRequestedIndex / pageSize) + 1
        
        if currentIndexPage >= lastFetchedPage {
            fetchPhotos(lastFetchedPage+1, pageSize)
        }
    }
    
    private func fetchPhotos(_ page:Int, _ limit:Int) {
        requestInProgress = true
        photoListDataProvider.fetchPhotoList(page, limit: pageSize) { [weak self] (photos, hasMorePhotos, error) -> (Void)  in
            
            if let strongSelf = self {
                strongSelf.requestInProgress = false
                if let photos = photos {
                    strongSelf.hasMorePhotos = hasMorePhotos ?? false
                    let photoItemViewModels = photos.map({ (photo) -> PhotoItemViewModel in
                        let photoItemViewModel = PhotoItemViewModel(photo: photo)
                        photoItemViewModel.itemTapped = { [weak self] in
                            self?.showPhotoDetailsFor(photoItemViewModel: photoItemViewModel)
                        }
                        return photoItemViewModel
                    })
                    strongSelf.photoItemViewModels.append(contentsOf: photoItemViewModels)
                    DispatchQueue.main.async {
                       strongSelf.view?.reloadPhotos()
                       strongSelf.view?.hideLoadingIndicator()
                    }
                }
            }
        }
    }
    
    private func showPhotoDetailsFor(photoItemViewModel:PhotoItemViewModel) {
        viewModelForDetailView = photoItemViewModel
        self.view?.showDetails()
    }
}

