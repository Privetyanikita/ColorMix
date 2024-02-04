//
//  ModelView.swift
//  ColorMix
//
//  Created by Admin on 04.02.2024.
//

import UIKit

class ColorViewModel {
    var colorData = ColorData(color1: .blue, color2: .red)
    var mixedColor: UIColor {
        get {
            var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
            colorData.color1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
            
            var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0
            colorData.color2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
            
            let mixedRed = (red1 + red2) / 2
            let mixedGreen = (green1 + green2) / 2
            let mixedBlue = (blue1 + blue2) / 2
            
            return UIColor(red: mixedRed, green: mixedGreen, blue: mixedBlue, alpha: 1.0)
        }
    }
    
    func saveColors() {
        UserDefaults.standard.set(colorData.color1, forKey: "color1")
        UserDefaults.standard.set(colorData.color2, forKey: "color2")
        print("Colors saved")
    }
    
    func loadColors() {
        if let color1 = UserDefaults.standard.colorForKey("color1") {
            colorData.color1 = color1
        }
        
        if let color2 = UserDefaults.standard.colorForKey("color2") {
            colorData.color2 = color2
        }
        print("Colors loaded")
    }
}

extension UserDefaults {
    func colorForKey(_ key: String) -> UIColor? {
        guard let colorData = data(forKey: key) else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
    }
    
    func set(_ color: UIColor, forKey key: String) {
        let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        set(colorData, forKey: key)
    }
}

