//
//  PhotoDetailsViewController.swift
//  PicSum
//
//  Created by Arjuna on 10/06/19.
//  Copyright © 2019 Arjuna. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController,UIScrollViewDelegate,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    var viewModel:PhotoItemViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: viewModel.downloadUrlFor(width: nil, height: nil))
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(with:url)
        // Do any additional setup after loading the view.
        let infoButton = UIButton(type: .infoDark)
        infoButton.addTarget(self, action: #selector(infoTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc  func infoTapped()  {
        performSegue(withIdentifier: "infoSegue", sender: self)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoSegue" {
            segue.destination.popoverPresentationController?.sourceView = self.navigationItem.rightBarButtonItem?.customView
            segue.destination.popoverPresentationController?.sourceRect = (self.navigationItem.rightBarButtonItem?.customView?.bounds)!
            segue.destination.popoverPresentationController?.delegate = self
            (segue.destination as! ImageInfoViewController).viewModel = viewModel
        }
    }
}
