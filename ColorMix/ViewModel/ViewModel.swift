//
//  ModelView.swift
//  ColorMix
//
//  Created by Admin on 04.02.2024.
//

import UIKit

class ColorViewModel {
    var colorData = ColorData(color1: .blue, color2: .red, nameColor1: "Blue", nameColor2: "Red")
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
    
    func colorName(from color: UIColor) -> String {
        if let colorName = color.closestStandardColorName() {
            return colorName
        } else {
            return "Custom Color"
        }
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

extension UIColor {
    func closestStandardColorName() -> String? {
        let standardColors: [String: UIColor] = [
            "Black": .black,
            "Dark Gray": .darkGray,
            "Light Gray": .lightGray,
            "White": .white,
            "Gray": .gray,
            "Red": .red,
            "Green": .green,
            "Blue": .blue,
            "Cyan": .cyan,
            "Yellow": .yellow,
            "Magenta": .magenta,
            "Orange": .orange,
            "Purple": .purple,
            "Brown": .brown,
            "Clear": .clear
        ]
        
        var closestColorName: String?
        var minDistance: CGFloat = .greatestFiniteMagnitude
        
        for (name, standardColor) in standardColors {
            let distance = self.distance(to: standardColor)
            if distance < minDistance {
                minDistance = distance
                closestColorName = name
            }
        }
        
        return closestColorName
    }
    
    func distance(to color: UIColor) -> CGFloat {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let distance = sqrt(pow(r1 - r2, 2) + pow(g1 - g2, 2) + pow(b1 - b2, 2))
        return distance
    }
}
