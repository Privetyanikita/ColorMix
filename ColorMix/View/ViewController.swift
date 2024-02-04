//
//  ViewController.swift
//  ColorMix
//
//  Created by Admin on 04.02.2024.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    // MARK: - Properties
    private let colorView1:UIView = {
       let element = UIView()
        element.tag = 1
        element.backgroundColor = .blue
        element.layer.cornerRadius = 10
        element.layer.borderWidth = 1
        element.layer.borderColor = UIColor.black.cgColor
        return element
    }()

    private let colorView2:UIView = {
       let element = UIView()
        element.tag = 2
        element.backgroundColor = .red
        element.layer.cornerRadius = 10
        element.layer.borderWidth = 1
        element.layer.borderColor = UIColor.black.cgColor
        return element
    }()
    
    private let colorResultView:UIView = {
       let element = UIView()
        element.backgroundColor = .black
        element.layer.cornerRadius = 10
        element.layer.borderWidth = 1
        element.layer.borderColor = UIColor.black.cgColor
        return element
    }()
    
    var selectedView: UIView?
    
    private let userDefaults = UserDefaults.standard

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstrains()
        addAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadColors()
        updateColorResultView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saveColors()
    }

    //MARK: - PrivateMethods
    private func setupViews(){
        view.addSubview(colorView1)
        view.addSubview(colorView2)
        view.addSubview(colorResultView)
        
    }
    
    private func addAction(){
        colorView1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeColor)))
        colorView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeColor)))
    }
    
    private func calculateMixedColor() -> UIColor? {
        guard let color1 = colorView1.backgroundColor, let color2 = colorView2.backgroundColor else { return nil }
        
        var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
        color1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        
        var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0
        color2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        let mixedRed = (red1 + red2) / 2
        let mixedGreen = (green1 + green2) / 2
        let mixedBlue = (blue1 + blue2) / 2
        
        return UIColor(red: mixedRed, green: mixedGreen, blue: mixedBlue, alpha: 1.0)
    }
    
    private func updateColorResultView() {
        if let mixedColor = calculateMixedColor() {
            colorResultView.backgroundColor = mixedColor
        }
    }
    
    private func saveColors() {
        guard let color1 = colorView1.backgroundColor, let color2 = colorView2.backgroundColor else { return }
        
        let color1Data = try? NSKeyedArchiver.archivedData(withRootObject: color1, requiringSecureCoding: false)
        let color2Data = try? NSKeyedArchiver.archivedData(withRootObject: color2, requiringSecureCoding: false)
        
        userDefaults.set(color1Data, forKey: "color1")
        userDefaults.set(color2Data, forKey: "color2")
        print("Colors saved")
    }

    private func loadColors() {
        if let color1Data = userDefaults.data(forKey: "color1"),
           let color1 = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: color1Data) {
            colorView1.backgroundColor = color1
        }
        
        if let color2Data = userDefaults.data(forKey: "color2"),
           let color2 = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: color2Data) {
            colorView2.backgroundColor = color2
        }
        print("Colors loaded")
    }
    
    //MARK: - objc Function
    @objc private func changeColor(_ sender: UITapGestureRecognizer){
        guard let view = sender.view else { return }
        let vc = UIColorPickerViewController()
        vc.delegate = self
        if let color = view.backgroundColor {
            vc.selectedColor = color
        }
        selectedView = view
        present(vc, animated: true)
    }

}

//MARK: - UIColorPickerViewControllerDelegate
extension ViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        guard let selectedView = selectedView else { return }
        let color = viewController.selectedColor
        selectedView.backgroundColor = color
        updateColorResultView()
    }
}

//MARK: - SetupConstrains
extension ViewController{
    private func setupConstrains(){
        colorView1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        colorView2.snp.makeConstraints { make in
            make.top.equalTo(colorView1.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        colorResultView.snp.makeConstraints { make in
            make.top.equalTo(colorView2.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
}

