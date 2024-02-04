//
//  ViewController.swift
//  ColorMix
//
//  Created by Admin on 04.02.2024.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstrains()
        addAction()
    }

    private func setupViews(){
        view.addSubview(colorView1)
        view.addSubview(colorView2)
        view.addSubview(colorResultView)
        
    }
    
    private func addAction(){
        colorView1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeColor)))
        colorView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeColor)))
    }
    
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

extension ViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        guard let selectedView = selectedView else { return }
        let color = viewController.selectedColor
        selectedView.backgroundColor = color
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        guard let selectedView = selectedView else { return }
        let color = viewController.selectedColor
        selectedView.backgroundColor = color
    }
}

