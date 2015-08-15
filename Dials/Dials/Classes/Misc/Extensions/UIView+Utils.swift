//
//  UIView+Utils.swift
//  Dials
//
//  Created by Beny Boariu on 10/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}