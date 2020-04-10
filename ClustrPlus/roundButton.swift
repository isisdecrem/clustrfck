//
//  roundButton.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 3/23/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import UIKit

class roundButton: UIButton {



    @IBDesignable
    class RoundButton: UIButton {

        @IBInspectable var cornerRadius: CGFloat = 0{
            didSet{
            self.layer.cornerRadius = cornerRadius
            }
        }

        @IBInspectable var borderWidth: CGFloat = 0{
            didSet{
                self.layer.borderWidth = borderWidth
            }
        }

        @IBInspectable var borderColor: UIColor = UIColor.clear{
            didSet{
                self.layer.borderColor = borderColor.cgColor
            }
        }
    }


}
