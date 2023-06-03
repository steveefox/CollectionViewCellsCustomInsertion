//
//  UIColor+Extensions.swift
//  CollectionViewCellsCustomInsertion
//
//  Created by Nikita on 03/06/2023.
//

import UIKit

extension UIColor {
	convenience init(hex: String, alpha: Double = 1.0, safelyColor: UIColor? = nil) {
		var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines as CharacterSet).uppercased()
		if (cString.hasPrefix("#")) {
			cString = String(cString.dropFirst())
		}
		
		var rgbValue:UInt32 = 0
		Scanner(string: cString).scanHexInt32(&rgbValue)
		if (cString.count == 6) {
			self.init(red:CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
					  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
					  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
					  alpha: CGFloat(alpha))
		} else if (cString.count == 8) {
			self.init(red:CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
					  green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
					  blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
					  alpha: CGFloat(rgbValue & 0x000000FF) / 255.0)
		} else {
			if let safelyColor = safelyColor {
				self.init(cgColor: safelyColor.cgColor)
			} else {
				self.init(white: 0.5, alpha: 0.5)
			}
		}
	}

	var hexString: String {
		guard let components = self.cgColor.components else { return "" }
		
		let red = Float(components[0])
		let green = Float(components[1])
		let blue = Float(components[2])
		return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
	}
	
	static var random: UIColor {
		return UIColor(red: .random(in: 0...1),
					   green: .random(in: 0...1),
					   blue: .random(in: 0...1),
					   alpha: 1.0)
	}
}
