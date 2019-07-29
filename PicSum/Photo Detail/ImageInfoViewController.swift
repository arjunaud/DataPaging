//
//  ImageInfoViewController.swift
//  PicSum
//
//  Created by Arjuna on 10/06/19.
//  Copyright © 2019 Arjuna. All rights reserved.
//

import UIKit

class ImageInfoViewController: UIViewController {
    @IBOutlet weak var imageIdLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    var viewModel:PhotoItemViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageIdLabel.text = viewModel.id
        authorLabel.text = viewModel.author
        widthLabel.text = "\(viewModel.width)"
        heightLabel.text = "\(viewModel.height)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
