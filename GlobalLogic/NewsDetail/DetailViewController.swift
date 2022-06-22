//
//  DetailViewController.swift
//  GlobalLogic
//
//  Created by Gerardo Villarroel on 22-06-22.
//

import UIKit

class DetailViewController: UIViewController {

    //Controles
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    
    //Variables
    var mImage: String?
    var mTitle: String?
    var mDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsImage.downloaded(from: URL(string: mImage!)!)
        newsTitle.text = mTitle!
        newsDescription.text = mDescription!
    }

}
