//
//  NewsData.swift
//  GlobalLogic
//
//  Created by Gerardo Villarroel on 22-06-22.
//

import UIKit
import os.log

class NewsData {
    
    //MARK: Properties
    var image: String
    var title: String
    var description: String
    
    //MARK: Inicialization
    init?(image: String, title: String, description: String) {
        guard !image.isEmpty && !title.isEmpty && !description.isEmpty else { return nil }
        
        self.image = image
        self.title = title
        self.description = description
    }
}
