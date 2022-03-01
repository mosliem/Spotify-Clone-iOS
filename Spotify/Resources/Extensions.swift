//
//  Extensions.swift
//  Spotify
//
//  Created by mohamedSliem on 2/4/22.
//

import UIKit

extension UIView
{
    var height : CGFloat {
        return frame.size.height
    }
    var width : CGFloat  {
        return frame.size.width
    }
    var left : CGFloat {
        return frame.origin.x
    }
    var right : CGFloat {
        return left + width
    }
    var top : CGFloat {
        return frame.origin.y
    }
    var bottom : CGFloat{
        return top + height
    }
    
    func presentAlert(title : String
                      , message : String
                      , style : String
                      , actionAlert : String
                      , compeltion: ((UIAlertAction?)-> Void)?) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if style == "cancel"
        {
            alert.addAction(UIAlertAction(title: actionAlert, style:.cancel , handler: compeltion))
        }
        else if style == "destructive"
        {
            alert.addAction(UIAlertAction(title: actionAlert, style:.destructive , handler: compeltion))
        }
        else
        {
            alert.addAction(UIAlertAction(title: actionAlert, style:.default , handler: compeltion))
        }
        return alert
    }
}

extension UIImageView {
    func applyshadow(shadowRadius : CGFloat , shadowOpacity :Float , shadowColor : UIColor){
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowPath = UIBezierPath(rect:self.bounds).cgPath
        self.clipsToBounds = false
        self.layer.masksToBounds = false
    }
}
