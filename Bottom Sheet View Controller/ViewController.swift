//
//  ViewController.swift
//  Bottom Sheet View Controller
//
//  Created by Sarath Kumar Rajendran on 26/02/20.
//  Copyright © 2020 Sarath Christiano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate let button: UIButton = {
        let button = UIButton()
        button.setTitle("Present", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        
        self.view.backgroundColor = .lightGray
        self.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        self.view.addSubview(self.button)
        
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[button(120)]", options: [], metrics: nil, views: ["button": self.button])
        constraints.append(.init(item: self.button, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[button(75)]", options: [], metrics: nil, views: ["button": self.button])
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc fileprivate func didTapButton(_ sender: UIButton) {
        self.presentBottomSheet(UIBottomSheetController(), animated: true)
    }
}
