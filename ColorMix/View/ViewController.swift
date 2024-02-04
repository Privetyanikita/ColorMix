//
//  ViewController.swift
//  ColorMix
//
//  Created by Admin on 04.02.2024.
//

import UIKit
import SnapKit

final class ColorViewController: UIViewController {
    //MARK: - Properties
    let viewModel = ColorViewModel()
    
    private let colorView1: UIView = {
        let view = UIView()
        view.tag = 1
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let colorView2: UIView = {
        let view = UIView()
        view.tag = 2
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let colorResultView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private var selectedView: UIView?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        addAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadColors()
        colorView1.backgroundColor = viewModel.colorData.color1
        colorView2.backgroundColor = viewModel.colorData.color2
        updateColorResultView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.saveColors()
    }
    
    //MARK: - Private methods
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(colorView1)
        view.addSubview(colorView2)
        view.addSubview(colorResultView)
    }
    
    private func addAction() {
        colorView1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeColor)))
        colorView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeColor)))
    }
    
    private func updateColorResultView() {
        colorResultView.backgroundColor = viewModel.mixedColor
    }
    
    @objc private func changeColor(_ sender: UITapGestureRecognizer) {
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

extension ColorViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        guard let selectedView = selectedView else { return }
        let color = viewController.selectedColor
        selectedView.backgroundColor = color
        if selectedView.tag == 1 {
            viewModel.colorData.color1 = color
        } else if selectedView.tag == 2 {
            viewModel.colorData.color2 = color
        }
        updateColorResultView()
    }
}

extension ColorViewController {
    private func setupConstraints() {
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

