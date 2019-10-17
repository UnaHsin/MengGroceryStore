//
//  UIViewTool.swift
//  Wonlive
//
//  Created by Una Lee on 2019/5/3.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit

extension UIView {
    
    var mhTool: MHTool { return MHTool(with: self) }
    
    struct MHTool {
        
        private weak
        var baseView: UIView!
        
        private init () {}
        init(with uiUiew: UIView) {
            
            baseView = uiUiew
        }
        
        func set(inSuper sView: UIView) {
            
            guard baseView.superview == nil else {
                assertionFailure("need use mhTool.removeFromSuperview")
                return
            }
            baseView.translatesAutoresizingMaskIntoConstraints = false
            sView.addSubview(baseView)
        }
        func removeFromSuperview() {
            
            baseView.translatesAutoresizingMaskIntoConstraints = true
            baseView.removeFromSuperview()
        }
        @discardableResult
        func equalCenterX(
            whit view: UIView,
            multiplier: CGFloat = 1) -> NSLayoutConstraint {
            
            let constraint: NSLayoutConstraint
            constraint = NSLayoutConstraint(
                item: baseView as Any,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: view,
                attribute: .centerX,
                multiplier: multiplier,
                constant: 0
            )
            constraint.isActive = true
            return constraint
        }
        func equalSize(
            with view: UIView,
            widthMultiplier: CGFloat = 1,
            heightMultiplier: CGFloat = 1) {
            
            equalWidthAndCenterX(
                whit: view,
                widthMultiplier: widthMultiplier
            )
            equalHeightAndCenterY(
                whit: view,
                heightMultiplier: heightMultiplier
            )
        }
        func equalWidthAndCenterX(
            whit view: UIView,
            widthMultiplier: CGFloat = 1) {
            
            baseView.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: widthMultiplier
                ).isActive = true
            baseView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
                ).isActive = true
        }
        func equalHeightAndCenterY(whit view: UIView, heightMultiplier: CGFloat = 1) {
            baseView.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: heightMultiplier
                ).isActive = true
            baseView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
                ).isActive = true
        }
        @discardableResult
        func equalCenterY(
            whit view: UIView,
            multiplier: CGFloat = 1) -> NSLayoutConstraint {
            
            let constraint: NSLayoutConstraint
            constraint = NSLayoutConstraint(
                item: baseView as Any,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: view,
                attribute: .centerY,
                multiplier: multiplier,
                constant: 0
            )
            constraint.isActive = true
            return constraint
        }
        @discardableResult
        func equalHeight(
            whit view: UIView,
            multiplier: CGFloat = 1) -> NSLayoutConstraint {
            
            let constraint: NSLayoutConstraint
            constraint = baseView.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: multiplier
            )
            constraint.isActive = true
            return constraint
        }
        @discardableResult
        func equalWidth(
            whit view: UIView,
            multiplier: CGFloat = 1) -> NSLayoutConstraint {
            
            let constraint: NSLayoutConstraint
            constraint = baseView.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: multiplier
            )
            constraint.isActive = true
            return constraint
        }
        
        @discardableResult
        func under(
            _ view: UIView,
            padding: CGFloat = 0) -> NSLayoutConstraint {
            
            let constraint: NSLayoutConstraint
            
            constraint = baseView.topAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: padding
            )
            constraint.isActive = true
            return constraint
        }
        @discardableResult
        func isTrailing(
            _ view: UIView,
            padding: CGFloat = 0) -> NSLayoutConstraint {
            
            let constraint: NSLayoutConstraint
            constraint = baseView.leadingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: padding
            )
            constraint.isActive = true
            return constraint
        }
        
        @discardableResult
        func isLeadding(
            _ view: UIView,
            padding: CGFloat = 0) -> NSLayoutConstraint {
            
            let constraint: NSLayoutConstraint
            constraint = baseView.trailingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: -padding
            )
            constraint.isActive = true
            return constraint
        }
        @discardableResult
        func isAbove(
            _ view: UIView,
            padding: CGFloat = 0) -> NSLayoutConstraint {
            
            let constraint: NSLayoutConstraint
            constraint = baseView.bottomAnchor.constraint(
                equalTo: view.topAnchor,
                constant: -padding
            )
            constraint.isActive = true
            return constraint
        }
        @discardableResult
        func equalBotton(
            _ view: UIView,
            padding: CGFloat = 0) -> NSLayoutConstraint {
            
            let constraint: NSLayoutConstraint = baseView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -padding
            )
            constraint.isActive = true
            return constraint
        }
        @discardableResult
        func equalTrailng(
            _ view: UIView,
            padding: CGFloat = 0) -> NSLayoutConstraint {
            
            let constraintr: NSLayoutConstraint
            constraintr = baseView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -padding
            )
            constraintr.isActive = true
            return constraintr
        }
        @discardableResult
        func equalLeading(
            _ view: UIView,
            padding: CGFloat = 0) -> NSLayoutConstraint {
            
            let constraintr: NSLayoutConstraint = baseView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: padding
            )
            constraintr.isActive = true
            return constraintr
        }
        @discardableResult
        func equalTop(
            _ view: UIView,
            padding: CGFloat = 0) -> NSLayoutConstraint {
            
            let constraint: NSLayoutConstraint
            constraint = baseView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: padding
            )
            constraint.isActive = true
            return constraint
        }
        func equalLayoutGuide(
            with vc: UIViewController,
            topPadding: CGFloat = 0,
            bottonPadding: CGFloat = 0) {
            
            equalTopLayoutGuide(
                vc,
                padding: topPadding
            )
            equalBottonLayoutGuide(
                vc,
                padding: bottonPadding
            )
        }
        @discardableResult
        func equalTopLayoutGuide(
            _ vc: UIViewController,
            padding: CGFloat = 0) -> NSLayoutConstraint   {
            
            let constraintr: NSLayoutConstraint
            
            if #available(iOS 11.0, *) {
                constraintr = baseView.topAnchor.constraint(
                    equalTo: vc.view.safeAreaLayoutGuide.topAnchor,
                    constant: padding
                )
            } else {
                constraintr = baseView.topAnchor.constraint(
                    equalTo: vc.topLayoutGuide.bottomAnchor,
                    constant: padding
                )
            }
            constraintr.isActive = true
            return constraintr
        }
        @discardableResult
        func equalBottonLayoutGuide(
            _ vc: UIViewController,
            padding: CGFloat = 0) -> NSLayoutConstraint  {
            
            let constraintr: NSLayoutConstraint
            if #available(iOS 11.0, *) {
                constraintr = baseView.bottomAnchor.constraint(
                    equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor,
                    constant: -padding
                )
            } else {
                constraintr = baseView.bottomAnchor.constraint(
                    equalTo: vc.bottomLayoutGuide.topAnchor,
                    constant: -padding
                )
            }
            constraintr.isActive = true
            return constraintr
        }
        @discardableResult
        func heightPt(_ pt: CGFloat) -> NSLayoutConstraint {
            
            let constraintr: NSLayoutConstraint
            constraintr = baseView.heightAnchor.constraint(
                equalToConstant: pt
            )
            constraintr.isActive = true
            return constraintr
        }
        @discardableResult
        func widthPt(_ pt: CGFloat) -> NSLayoutConstraint {
            
            let constraint: NSLayoutConstraint
            constraint = baseView.widthAnchor.constraint(equalToConstant: pt)
            constraint.isActive = true
            return constraint
        }
        @discardableResult
        func isRectangle(aspectRatio: CGFloat, constant: CGFloat = 0) -> NSLayoutConstraint {
            
            let constraint: NSLayoutConstraint = NSLayoutConstraint(
                item: baseView as Any,
                attribute: .height,
                relatedBy: .equal,
                toItem: baseView as Any,
                attribute: .width,
                multiplier: aspectRatio,
                constant: constant
            )
            constraint.isActive = true
            return constraint
        }
        func isSquare() {
            
            isRectangle(aspectRatio: 1)
        }
        
        enum MHGradinStyle {
            case horizontal,
            vertal,
            LTRB,
            RTLB
        }
        func setBackgroundGradient(
            with colors: [UIColor],
            style: MHGradinStyle) {
            
            let Start: CGPoint
            let end: CGPoint
            switch style {
            case .horizontal:
                Start = CGPoint(x: 0, y: 1)
                end = CGPoint(x: 1, y: 1)
            case .vertal:
                Start = CGPoint(x: 0, y: 0)
                end = CGPoint(x: 0, y: 1)
            case .LTRB:
                Start = CGPoint(x: 0, y: 0)
                end = CGPoint(x: 1, y: 1)
            case .RTLB:
                Start = CGPoint(x: 1, y: 1)
                end = CGPoint(x: 0, y: 0)
            }
            setBackgroundGradient(with: colors, startpoint: Start, endpoint: end)
        }
        
        func setBackgroundGradient(
            with colors: [UIColor],
            startpoint: CGPoint,
            endpoint: CGPoint) {
            
            removeBackgroundGradient()
            baseView.backgroundColor = .clear
            let gradientLayer: MHCAGradientLayer = MHCAGradientLayer()
            var cgColors: [CGColor] = []
            for uiColor in colors {
                cgColors.append(uiColor.cgColor)
            }
            gradientLayer.colors = cgColors
            baseView.layoutIfNeeded()
            gradientLayer.frame = baseView.bounds
            gradientLayer.startPoint = startpoint
            gradientLayer.endPoint = endpoint
            gradientLayer.cornerRadius = baseView.layer.cornerRadius
            baseView.layer.insertSublayer(gradientLayer, at: 0)
        }
        func removeBackgroundGradient() {
            
            guard let subLayers = baseView.layer.sublayers else { return }
            
            for layer in subLayers {
                guard layer.isKind(of: MHCAGradientLayer.self) else { continue }
                layer.removeFromSuperlayer()
            }
        }
        
        class MHCAGradientLayer: CAGradientLayer {}
        
        static
            func getNowVc() -> UIViewController? {
            
            guard let rVc = UIApplication.shared.keyWindow?.rootViewController else {
                return nil
            }
            var vc: UIViewController = rVc
            while vc.presentingViewController != nil {
                
                guard let pVc = vc.presentingViewController else {
                    continue
                }
                vc = pVc
            }
            return getNowVc(with: vc)
        }
        private static
            func getNowVc(with vc: UIViewController?) -> UIViewController? {
            
            let vc: UIViewController? = vc
            if let vc = vc as? UINavigationController {
                return getNowVc(with: vc.children.last)
            }
            if let vc = vc as? UITabBarController {
                return getNowVc(with: vc.selectedViewController)
            }
            return vc
        }
        func getNowVc() -> UIViewController? {
            
            guard let rVc = UIApplication.shared.keyWindow?.rootViewController else {
                return nil
            }
            var vc: UIViewController = rVc
            while vc.presentingViewController != nil {
                
                guard let pVc = vc.presentingViewController else {
                    continue
                }
                vc = pVc
            }
            return getNowVc(with: vc)
        }
        private
        func getNowVc(with vc: UIViewController?) -> UIViewController? {
            
            let vc: UIViewController? = vc
            if let vc = vc as? UINavigationController {
                return getNowVc(with: vc.children.last)
            }
            if let vc = vc as? UITabBarController {
                return getNowVc(with: vc.selectedViewController)
            }
            return vc
        }
    }
}
