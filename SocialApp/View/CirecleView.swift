//
//  CirecleView.swift
//  SocialApp
//
//  Created by Hady Hammad on 8/16/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit

class CirecleView: UIImageView{
    override func layoutSubviews() {
        //super.layoutSubviews()
        layer.cornerRadius = self.frame.width/2
    }
}
