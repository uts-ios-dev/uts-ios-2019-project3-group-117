//
//  UIColor+Hex.swift
//  ToDoList
//
//

import UIKit

extension UIColor {
    convenience init(hexString:String){
        
        //Deal with the values.
        var cString = hexString.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let length = (cString as NSString).length
        
        //Handle the mistakes.
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
            //return white color.
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }
        
        if cString.hasPrefix("#"){
            cString = (cString as NSString).substring(from: 1)
        }
        
        //
        var range = NSRange()
        range.location = 0
        range.length = 2
        
        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        //store the transformed value.
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        //do the transform.
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        //creat UIColor based on the color value.
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
}
