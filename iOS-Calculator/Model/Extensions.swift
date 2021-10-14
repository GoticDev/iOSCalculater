//
//  Extensions.swift
//  iOS-Calculator
//
//  Created by Victor De la Torre Anicama on 14/10/21.
//

import UIKit

extension UIButton {
    func round() {
        layer.cornerRadius = bounds.height / 2
//        frame = CGRect(x: 160, y: 100, width: 50, height: 50)
//        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        clipsToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        layer.cornerCurve = .continuous
    }
    
    func shine() {
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 0.5
            }) { (completion) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.alpha = 1
                })
            }
        }
    
}
