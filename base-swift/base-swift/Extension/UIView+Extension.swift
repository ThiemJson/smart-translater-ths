//
//  UIView+Extension.swift
//  BaseSwift
//
//  Created by Macbook Pro 2017 on 8/4/20.
//  Copyright © 2023 BaseProject. All rights reserved.
//

import UIKit
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}

extension UIView {
    func makeContraintToFullWithSuperView() {
        guard let parrentView = self.superview else {
            return
        }
        let dict = ["view": self]
        self.translatesAutoresizingMaskIntoConstraints = false
        let option = NSLayoutConstraint.FormatOptions(rawValue: 0)
        parrentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                  options: option,
                                                                  metrics: nil, views: dict))
        parrentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                  options: option,
                                                                  metrics: nil, views: dict))
    }
    
    func addShadow(cornerRadius: CGFloat = 8, shadowColor: UIColor = UIColor.gray,
                   shadowRadius: CGFloat = 5, shadowOpacity: Float = 0.2,
                   shadowOffset: CGSize = .zero) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.masksToBounds = false
    }
}

extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        self.layer.add(animation, forKey: nil)
    }
    func addDashedLineBorder(color: UIColor, borderWidth: CGFloat = 1) {
        if let subLayers = self.layer.sublayers {
            for sub in subLayers.filter({ $0.name == "DashedLayer" }) {
                sub.removeFromSuperlayer()
                break
            }
        }
        let dashedLayer = CAShapeLayer()
        dashedLayer.name = "DashedLayer"
        dashedLayer.strokeColor = color.cgColor
        dashedLayer.lineDashPattern = [4, 4]
        dashedLayer.frame = self.bounds
        dashedLayer.fillColor = nil
        dashedLayer.path = UIBezierPath(rect: self.bounds).cgPath
        dashedLayer.lineWidth = borderWidth
        self.layer.addSublayer(dashedLayer)
    }
    func addGradientLayer(colors: [CGColor], isHorizontal: Bool = true) {
        if let subLayers = self.layer.sublayers {
            for sub in subLayers.filter({ $0.name == "gradientLayer" }) {
                sub.frame = self.bounds
                return
            }
        }
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientLayer"
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = self.layer.cornerRadius
        if isHorizontal {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        }
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc func layoutGradientLayer() {
        if let subLayers = self.layer.sublayers {
            for sub in subLayers.filter({ $0.name == "gradientLayer" }) {
                sub.frame = self.bounds
                return
            }
        }
    }
}

extension UIView {
   func roundCorners(corners: CACornerMask, radius: CGFloat) {
       layer.cornerRadius = radius
       layer.maskedCorners = corners
    }
}

extension  UIButton {
  func flash() {
    let flash = CABasicAnimation(keyPath: "opacity")
    flash.duration = 0.1
    flash.fromValue = 1
    flash.toValue = 0.1
    flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    flash.autoreverses = true
    flash.repeatCount = 1
    layer.add(flash, forKey: nil)
  }
}

extension UIView {
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        for subview in subviews {
            if let responder = subview.findFirstResponder() {
                return responder
            }
        }
        return nil
    }
}


extension UIView {
    
    func takeScreenshot() -> UIImage {
        
        //begin
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // draw view in that context.
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // get iamge
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            return image!
        }
        
        return UIImage()
        
    }
    
    @discardableResult
    func dropShadow() -> UIView {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 1)
//        layer.shadowRadius = 5
        
        return self
    }
    
    func addShadowToView(shadowRadius: CGFloat = 2, alphaComponent: CGFloat = 0.6) {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: alphaComponent).cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 2)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1
    }
    
    func setShadowRadiusView(_ radius: CGFloat? = 14) {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false
        self.layer.cornerRadius =  radius ?? 14
    }
    
    func removeSetShadowRadiusView() {
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 0
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func removeShadow(){
        self.layer.shadowColor = UIColor.white.cgColor
        
    }
    
    func setShadowBotView() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: -5)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 30
    }
    
    func setShadowBottom() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0 , height:2)
    }
    
    func setBorderView() {
        self.backgroundColor = .clear
        self.layer.borderWidth = 1
        self.layer.borderColor = Constant.Color.gray_text_opa.cgColor
        self.layer.cornerRadius = self.frame.height/2
    }
    
    func restoreMaskedCorners() {
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}


extension UIView {

func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
    self.alpha = 0.0

    UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
        self.isHidden = false
        self.alpha = 1.0
    }, completion: completion)
}

func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
    self.alpha = 1.0

    UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
        self.alpha = 0.0
    }) { (completed) in
        self.isHidden = true
        completion(true)
    }
}
}

extension UIView {
    public var viewWidth: CGFloat {
        return self.frame.size.width
    }

    public var viewHeight: CGFloat {
        return self.frame.size.height
    }
}

extension UIView {
    /// Remove allSubView in view
    func removeAllSubViews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }

}

extension UIView {
    func drawDashedLine(start: CGPoint, end: CGPoint, color: UIColor = .lightGray, width: CGFloat = 1, pattern: [NSNumber] = [2, 2]) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = pattern
        
        let path = CGMutablePath()
        path.addLines(between: [start, end])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }
}

import Foundation
import UIKit
import Combine
import RxCocoa
import RxSwift
class BaseNibView: UIView {
    
    @IBOutlet var contentView: UIView!
    var disposables = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor.clear
        Bundle.main.loadNibNamed(self.className, owner: self, options: nil)
        addSubview(contentView)
        contentView.makeContraintToFullWithSuperView()
    }
    
    func removeView() {
        self.isHidden = true
        self.removeFromSuperview()
    }
}
