//
//  LegislatorDetailView.swift
//  Congress
//
//  Created by Jeremy Carbaugh on 7/22/14.
//  Copyright (c) 2014 Sunlight Foundation. All rights reserved.
//

import UIKit

@IBDesignable class LegislatorDetailView: UIView {
    
    @IBOutlet weak var avatar: UIImageView!
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        avatar.image = UIImage(named: "Barb")
        self.backgroundColor = UIColor.redColor()
    }

}
