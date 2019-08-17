//
//  CirecleView.swift
//  SocialApp
//
//  Created by Hady Hammad on 8/16/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit

class CirecleView: UIImageView{
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width/2
    }
}
