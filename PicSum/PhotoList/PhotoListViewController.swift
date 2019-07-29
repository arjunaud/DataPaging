//
//  ViewController.swift
//  PicSum
//
//  Created by Arjuna on 09/06/19.
//  Copyright © 2019 Arjuna. All rights reserved.
//

import UIKit
import Kingfisher
import SDWebImage

class PhotoListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PhotoListViewProtocol {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var photoListViewModel:PhotoListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        ImageCache.default.memoryStorage.config.totalCostLimit = 200 * 1024 * 1024
//        ImageCache.default.memoryStorage.config.countLimit = 50
          KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024
//        KingfisherManager.shared.cache.memoryStorage.config.countLimit = 100
          KingfisherManager.shared.downloader.downloadTimeout = 60

        //SDWebImageManager.shared().imageDownloader?.downloadTimeout = 60.0
        photoListViewModel = PhotoListViewModel(view: self)
    
        if UIDevice.current.userInterfaceIdiom == .pad {
            photoListViewModel.pageSize = 50
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            photoListViewModel.pageSize = 30
        }
        photoListViewModel.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoListViewModel.numberOfPhotoItemModels()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoItemViewModel = photoListViewModel.photoItemViewModelAtIndex(index: indexPath.item)
        let photoListViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoListViewCell
        photoListViewCell.setUpWith(photoItemModel: photoItemViewModel)
        return photoListViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoListViewModel.photoItemViewModelAtIndex(index: indexPath.item).itemTapped()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemSize = CGSize(width: 0, height: 0)
        if UIDevice.current.userInterfaceIdiom == .pad {
            //photoListViewModel.pageSize = 50
            itemSize = CGSize(width: 300, height: 250)
            
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            //photoListViewModel.pageSize = 30
            itemSize = CGSize(width: 160, height: 140)
        }
        return itemSize
    }

    func reloadPhotos() {
        self.photoCollectionView.reloadData()
    }
    
    func showLoadingIndictor() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }

    func showDetails() {
        performSegue(withIdentifier: "showDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            (segue.destination as! PhotoDetailsViewController).viewModel = photoListViewModel.viewModelForDetailView
        }
    }
}

