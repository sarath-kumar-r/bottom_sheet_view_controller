//
//  UIView.swift
//  Bottom Sheet View Controller
//
//  Created by Sarath Kumar Rajendran on 27/02/20.
//  Copyright © 2020 Sarath Christiano. All rights reserved.
//

import UIKit

extension UIView {
    
    enum Side: Int, CaseIterable {
        case left
        case right
        case bottom
        case top
    }
    
    @discardableResult
    func addBlurBackgroundEffect(style: UIBlurEffect.Style = .light) -> UIVisualEffectView {
        
        self.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
        return blurEffectView
    }
    
    @discardableResult
    func addVibrancyBackgroundEffect(style: UIBlurEffect.Style = .light, toView: UIView) -> UIVisualEffectView {
        
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        vibrancyEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vibrancyEffectView.contentView.addSubview(toView)
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        return vibrancyEffectView
    }
    
    @discardableResult
    func pinToSuperview(sides: [Side] = Side.allCases, padding: CGFloat = 0, multiplier: CGFloat = 1) -> UIView {
        
        guard let superView = superview else {
            return self
        }
        
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints.toggle()
        }
        
        var constraints = [NSLayoutConstraint]()
        for side in sides.sorted() {
            let attribute = side.nsAttribute
            let isNegativeValueSide = [.right, .bottom].contains(side)
            let paddingToSet: CGFloat = isNegativeValueSide ? -(padding) : padding
            constraints.append(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: superView, attribute: attribute, multiplier: multiplier, constant: paddingToSet))
        }
        NSLayoutConstraint.activate(constraints)
        return self
    }
    
    @discardableResult
    func pinVertically(padding: CGFloat = 0, multiplier: CGFloat = 1) -> UIView {
        return pinToSuperview(sides: [.top, .bottom], padding: padding, multiplier: multiplier)
    }
    
    @discardableResult
    func pinHorizontally(padding: CGFloat = 0, multiplier: CGFloat = 1) -> UIView {
        return pinToSuperview(sides: [.left, .right], padding: padding, multiplier: multiplier)
    }
    
    @discardableResult
    func pinTop(padding: CGFloat = 0, multiplier: CGFloat = 1) -> UIView {
        return pinToSuperview(sides: [ .top], padding: padding, multiplier: multiplier)
    }
    
    @discardableResult
    func pinBottom(padding: CGFloat = 0, multiplier: CGFloat = 1) -> UIView {
        return pinToSuperview(sides: [ .bottom], padding: padding, multiplier: multiplier)
    }
    
    @discardableResult
    func pinLeft(padding: CGFloat = 0, multiplier: CGFloat = 1) -> UIView {
        return pinToSuperview(sides: [ .left], padding: padding, multiplier: multiplier)
    }
    
    @discardableResult
    func pinRight(padding: CGFloat = 0, multiplier: CGFloat = 1) -> UIView {
        return pinToSuperview(sides: [ .right], padding: padding, multiplier: multiplier)
    }

    
    @discardableResult
    func join(side: UIView.Side, view: UIView, toSide: Side, constant: CGFloat = 0) -> UIView {
        
        NSLayoutConstraint(item: self, attribute: side.nsAttribute, relatedBy: .equal, toItem: view, attribute: toSide.nsAttribute, multiplier: 1, constant: constant).activate()
        return self
    }
    
    @discardableResult
    func height(_ height: CGFloat) -> UIView {
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(height)]", options: [], metrics: ["height": height], views: ["view": self]))
        return self
    }
    
    @discardableResult
    func width(_ width: CGFloat) -> UIView {
         NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(width)]", options: [], metrics: ["width": width], views: ["view": self]))
        return self
    }
    
    @discardableResult
    func height(multiplier: CGFloat = 1, to view: UIView? = nil) -> UIView {
        
        guard let toView = view ?? superview else {
            return self
        }
        NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: toView, attribute: .height, multiplier: multiplier, constant: 0).activate()
        return self
    }
    
    @discardableResult
    func width(multiplier: CGFloat = 1, to view: UIView? = nil) -> UIView {
        
        guard let toView = view ?? superview else {
            return self
        }
        NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: toView, attribute: .width, multiplier: multiplier, constant: 0).activate()
        return self
    }
    
    @discardableResult
    func equaltHeight(to view: UIView) -> UIView {
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==toView)]", options: [], metrics: nil, views: ["view": self, "toView": view]))
        return self
    }
    
    @discardableResult
    func equalWidth(to view: UIView) -> UIView {
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(==toView)]", options: [], metrics: nil, views: ["view": self, "toView": view]))
        return self
    }
    
    @discardableResult
    func alignCenterX(to view: UIView? = nil , constant: CGFloat = 0, multiplier: CGFloat = 1) -> UIView {
        guard let toView = view ?? superview else {
            return self
        }
        NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: toView, attribute: .centerX, multiplier: multiplier, constant: constant).activate()
        return self
    }
    
    @discardableResult
    func alignCenterY(to view: UIView? = nil , constant: CGFloat = 0, multiplier: CGFloat = 1) -> UIView {
        guard let toView = view ?? superview else {
            return self
        }
        NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: toView, attribute: .centerY, multiplier: multiplier, constant: constant).activate()
        return self
    }
    
    @discardableResult
    func equalHeightToWidth() -> UIView {
        NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).activate()
        return self
    }
    
    @discardableResult
    func equalWidthToHeight() -> UIView {
        NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0).activate()
        return self
    }
    
}


extension UIView.Side: Comparable {
    
    static func < (lhs: UIView.Side, rhs: UIView.Side) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var nsAttribute: NSLayoutConstraint.Attribute {
        switch self {
        case .right: return .right
        case .left: return .left
        case .bottom: return .bottom
        case .top: return .top
        }
    }
   
    var opposite: UIView.Side {
        switch self {
        case .right: return .left
        case .left: return .right
        case .bottom: return .top
        case .top: return .bottom
        }
    }
}


extension NSLayoutConstraint {
    
    func activate() {
        NSLayoutConstraint.activate([self])
    }
}

