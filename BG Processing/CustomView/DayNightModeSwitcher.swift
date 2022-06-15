//
//  DayNightModeSwitcher.swift
//  DayNightModeSwitcher
//
//  Created by Admin on 19.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

protocol DayNightModeSwitcherDelegate: AnyObject {
    func switcher(_ switcher: DayNightModeSwitcher, didChangeValueTo value: TypeOfSwitcher)
}

enum TypeOfSwitcher {
    case day
    case night
}

class DayNightModeSwitcher:UIView {
    weak var delegate:DayNightModeSwitcherDelegate!
    
    var switcher: UIView = UIView()
    
    private let dayColor: UIColor = UIColor(red: 105/255, green: 208/255, blue: 255/255, alpha: 1)
    private let nightColor: UIColor = UIColor(red: 21/255, green: 27/255, blue: 76/255, alpha: 1)
    private let nightShadowColor: UIColor = UIColor(red: 164/255, green: 170/255, blue: 179/255, alpha: 1)
    private let dayShadowColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    private var view:UIView = UIView()
    private let dayImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "sun"))
    private let nightImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "moon"))
    private let firstCloudImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "cloud"))
    private let secondCloudImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "cloud"))
    private let starsImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "stars"))
    private let fallingStarImageView:UIImageView = UIImageView(image: #imageLiteral(resourceName: "falling_star"))
    private var switcherImagesView: UIView = UIView()
    private var switcherShadowView: UIView = UIView()
    
    private var isTouchMoved:Bool = false
    
    private var spacingBetweenSwitcherAndBackground:CGFloat = 10
    
    public var fallingStarDelay:TimeInterval = 1
    
    public var fallingStarDuration:TimeInterval = 1.5
    
    public var isDay:Bool = false {
        didSet {
            if(isDay == true) {
                setDay(false, animated: false)
            }
            else {
                setNight(false, animated: false)
            }
        }
    }
    
    
    
    private var typeOfSwitcher: TypeOfSwitcher = TypeOfSwitcher.night
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        self.backgroundColor = .clear
        setupView()
        
        spacingBetweenSwitcherAndBackground = self.view.frame.height/17
        
        setupSwitcher()
        setupImageViews()
        
        
        typeOfSwitcher = .night
        
        makeFallingStarAnimation()
    }
    
    private func setupView() {
        var viewFrame:CGRect
        if(self.frame.width > 2*self.frame.height) {
            viewFrame = CGRect(x: self.frame.width/2 - self.frame.height, y: 0, width: 2*self.frame.height, height: self.frame.height)
        }
        else if(self.frame.width < 2*self.frame.height) {
            viewFrame = CGRect(x: 0, y: self.frame.height/2-self.frame.width/4, width: self.frame.width, height: self.frame.width/2)
        }
        else {
            viewFrame = self.bounds
        }
        view = UIView(frame: viewFrame)
        self.addSubview(view)
        self.view.layer.cornerRadius = self.view.frame.height/2
        self.view.backgroundColor = nightColor
        self.view.clipsToBounds = true
        
    }
    
    private func setupSwitcher() {
        let switcherShadowFrame = CGRect(x: spacingBetweenSwitcherAndBackground, y: spacingBetweenSwitcherAndBackground, width: self.view.frame.height - 2*spacingBetweenSwitcherAndBackground, height: self.view.frame.height - 2*spacingBetweenSwitcherAndBackground)
        let switcherFrame = CGRect(x: 0, y: 0, width: self.view.frame.height - 2*spacingBetweenSwitcherAndBackground, height: self.view.frame.height - 2*spacingBetweenSwitcherAndBackground)
        
        switcher = UIView(frame: switcherFrame)
        switcher.layer.cornerRadius = switcherFrame.height/2
        switcher.backgroundColor = .white
        switcher.clipsToBounds = true
        
        switcherShadowView = UIView(frame: switcherShadowFrame)
        switcherShadowView.layer.cornerRadius = switcherFrame.height/2
        switcherShadowView.backgroundColor = .clear
        
        switcherShadowView.layer.masksToBounds = false
        switcherShadowView.layer.shadowColor = nightShadowColor.cgColor
        switcherShadowView.layer.shadowOpacity = 1
        switcherShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        switcherShadowView.layer.shadowRadius = 25
        switcherShadowView.addSubview(switcher)
        self.view.addSubview(switcherShadowView)
    }
    
    private func setupImageViews() {
        let size = self.switcher.frame.height
 
        dayImageView.frame = CGRect(x: size/2, y: size, width: size, height: size)
        dayImageView.contentMode = .scaleToFill
        dayImageView.layer.cornerRadius = size/2
        dayImageView.alpha = 0
        
        nightImageView.frame = CGRect(x: size, y: size/2, width: size, height: size)
        nightImageView.contentMode = .scaleToFill
        nightImageView.layer.cornerRadius = size/2
        nightImageView.alpha = 1
        
        
        switcherImagesView = UIView(frame: CGRect(x: -size/2, y: -size, width: 2*size, height: 2*size))
        switcherImagesView.layer.cornerRadius = size
        switcherImagesView.backgroundColor = .white
        
        
        switcherImagesView.addSubview(nightImageView)
        switcherImagesView.addSubview(dayImageView)
        switcher.addSubview(switcherImagesView)
        self.switcherImagesView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.switcherImagesView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        self.nightImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        let starsSize = self.view.frame.height * 0.7
        let starsImageViewFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2 - starsSize/2, width: starsSize, height: starsSize)
        starsImageView.frame = starsImageViewFrame
        self.view.addSubview(starsImageView)
        
        let firstCloudSize = 0.35 * self.view.frame.height
        firstCloudImageView.frame = CGRect(x: self.view.frame.width, y: 0.1 * self.view.frame.height, width: firstCloudSize, height: firstCloudSize)
        firstCloudImageView.contentMode = .scaleAspectFit
        firstCloudImageView.alpha = 0
        
        secondCloudImageView.frame = CGRect(x: self.view.frame.width, y: 0.4 * self.view.frame.height, width: 1.8 * firstCloudSize, height: 1.8 * firstCloudSize)
        secondCloudImageView.contentMode = .scaleAspectFit
        secondCloudImageView.alpha = 0
        
        self.view.addSubview(firstCloudImageView)
        self.view.addSubview(secondCloudImageView)
        
        fallingStarImageView.frame = CGRect(x: self.view.frame.width, y: -2, width: 1, height: 1)
        self.view.addSubview(fallingStarImageView)
        
        
        
    }
    
    public func set(to type:TypeOfSwitcher, animated:Bool) {
        if(type == .day) {
            setDay(true, animated: animated)
        }
        if(type == .night) {
            setNight(true, animated: animated)
        }
    }
    
    private func startAnimation() {
        isTouchMoved = false
        if(typeOfSwitcher == .night) {
            typeOfSwitcher = .day
        }
        else if(typeOfSwitcher == .day) {
            typeOfSwitcher = .night
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.switcherShadowView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (success:Bool) in
            UIView.animate(withDuration: 0.1, animations: {
                self.switcherShadowView.transform = CGAffineTransform.identity
            })
        }
        
    }
    
    private func makeFallingStarAnimation() {
        if(typeOfSwitcher == .night) {
            self.fallingStarImageView.transform = CGAffineTransform.identity
            
            let randomK = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
            let lowerBorder = self.view.frame.width * 0.75
            let higherBorder = self.view.frame.width
            
            let randomX = lowerBorder + (higherBorder - lowerBorder) * randomK
            
            fallingStarImageView.frame = CGRect(x: randomX, y: -2, width: 1, height: 1)
            
            UIView.animate(withDuration: fallingStarDuration, delay: fallingStarDelay, animations: {
                self.fallingStarImageView.transform = CGAffineTransform(scaleX: 4.1, y: 4.1)
                self.fallingStarImageView.center = CGPoint(x: randomX - self.view.frame.height , y: self.view.frame.height + 2*self.spacingBetweenSwitcherAndBackground)
            }){  (success:Bool) in
                    self.makeFallingStarAnimation()
                }
            }
        
        else {
            fallingStarImageView.removeFromSuperview()
        }
    }
    
    private func setNight(_ animatedMoon: Bool, animated: Bool)
    {
        typeOfSwitcher = .night
        self.switcherShadowView.transform = CGAffineTransform.identity
        if(animatedMoon) {
            self.switcherImagesView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            fallingStarImageView.frame = CGRect(x: self.view.frame.width, y: -2, width: 1, height: 1)
            self.view.addSubview(fallingStarImageView)
            makeFallingStarAnimation()
        }
        else{
            self.switcherImagesView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.switcherImagesView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        }
        if(animated){
            UIView.animate(withDuration: 1.7, delay: 0, usingSpringWithDamping: 12, initialSpringVelocity: 10, options: [.allowUserInteraction], animations: {
                self.starsImageView.center.x = self.view.frame.width/2 + self.starsImageView.frame.width/2
                self.starsImageView.alpha = 1
                
                self.firstCloudImageView.alpha = 0
                self.firstCloudImageView.center.x = self.view.frame.width
                self.secondCloudImageView.alpha = 0
                self.secondCloudImageView.center.x = self.view.frame.width
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                
                self.switcherShadowView.frame = CGRect(x: self.spacingBetweenSwitcherAndBackground, y: self.spacingBetweenSwitcherAndBackground, width: self.view.frame.height - 2*self.spacingBetweenSwitcherAndBackground, height: self.view.frame.height - 2*self.spacingBetweenSwitcherAndBackground)
                self.switcherShadowView.layer.shadowColor = self.nightShadowColor.cgColor
                
                if(animatedMoon) {
                    self.switcherImagesView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                }
                
                self.nightImageView.alpha = 1
                self.dayImageView.alpha = 0
                self.view.backgroundColor = self.nightColor
            })
        }
        else {
            self.starsImageView.center.x = self.view.frame.width/2 + self.starsImageView.frame.width/2
            self.starsImageView.alpha = 1
            
            self.firstCloudImageView.alpha = 0
            self.firstCloudImageView.center.x = self.view.frame.width
            self.secondCloudImageView.alpha = 0
            self.secondCloudImageView.center.x = self.view.frame.width
            
            self.switcherShadowView.frame = CGRect(x: self.spacingBetweenSwitcherAndBackground, y: self.spacingBetweenSwitcherAndBackground, width: self.view.frame.height - 2*self.spacingBetweenSwitcherAndBackground, height: self.view.frame.height - 2*self.spacingBetweenSwitcherAndBackground)
            self.switcherShadowView.layer.shadowColor = self.nightShadowColor.cgColor
            
            if(animatedMoon) {
                self.switcherImagesView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            }
            
            self.nightImageView.alpha = 1
            self.dayImageView.alpha = 0
            self.view.backgroundColor = self.nightColor
        }
        
        
    }
    
    private func setDay(_ animatedSun: Bool, animated: Bool) {
        self.switcherShadowView.transform = CGAffineTransform.identity
        typeOfSwitcher = .day
        if(animated) {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.allowUserInteraction], animations: {
                self.starsImageView.center.x = self.starsImageView.frame.width/2
                self.starsImageView.alpha = 0
                
                self.firstCloudImageView.alpha = 1
                self.firstCloudImageView.center.x = 0.375 * self.view.frame.height
                
            }, completion: nil)
            
            UIView.animate(withDuration: 1.7, delay: 0, usingSpringWithDamping: 12, initialSpringVelocity: 10, options: [.allowUserInteraction], animations: {
                self.secondCloudImageView.alpha = 1
                self.secondCloudImageView.center.x = 0.715 * self.view.frame.height
            }, completion: nil)
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.allowUserInteraction], animations: {
                self.starsImageView.center.x = self.starsImageView.frame.width/2
                self.starsImageView.alpha = 0
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                self.switcherShadowView.frame = CGRect(x: self.view.frame.width + self.spacingBetweenSwitcherAndBackground - self.view.frame.height, y: self.spacingBetweenSwitcherAndBackground, width: self.view.frame.height - 2*self.spacingBetweenSwitcherAndBackground, height: self.view.frame.height - 2*self.spacingBetweenSwitcherAndBackground)
                self.switcherShadowView.layer.shadowColor = self.dayShadowColor.cgColor
                
                if(animatedSun) {
                    self.switcherImagesView.transform = CGAffineTransform.identity
                }
                
                
                
                self.nightImageView.alpha = 0
                self.dayImageView.alpha = 1
                self.view.backgroundColor = self.dayColor
            })
        }
        else {
            self.starsImageView.center.x = self.starsImageView.frame.width/2
            self.starsImageView.alpha = 0
            self.firstCloudImageView.alpha = 1
            self.firstCloudImageView.center.x = 0.375 * self.view.frame.height
            self.secondCloudImageView.alpha = 1
            self.secondCloudImageView.center.x = 0.715 * self.view.frame.height
            self.starsImageView.center.x = self.starsImageView.frame.width/2
            self.starsImageView.alpha = 0
            self.switcherShadowView.frame = CGRect(x: self.view.frame.width + self.spacingBetweenSwitcherAndBackground - self.view.frame.height, y: self.spacingBetweenSwitcherAndBackground, width: self.view.frame.height - 2*self.spacingBetweenSwitcherAndBackground, height: self.view.frame.height - 2*self.spacingBetweenSwitcherAndBackground)
            self.switcherShadowView.layer.shadowColor = self.dayShadowColor.cgColor
            self.nightImageView.alpha = 0
            self.dayImageView.alpha = 1
            self.view.backgroundColor = self.dayColor
        }
    }
    
    private func endAnimation() {
        self.switcherShadowView.transform = CGAffineTransform.identity
        if(typeOfSwitcher == .night) {
            if(!isTouchMoved) {
                setNight(true, animated: true)
            }
            delegate.switcher(self, didChangeValueTo: .night)
        }
        if(typeOfSwitcher == .day) {
            if(!isTouchMoved) {
                setDay(true, animated: true)
            }
            delegate.switcher(self, didChangeValueTo: .day)
        }
    }
    
    private func setProbablyAnimation(with touch: UITouch) {
        isTouchMoved = true
        let location = touch.location(in: self.superview)
        if(location.x < self.frame.maxX  && location.x > self.frame.minX  && location.y < self.frame.maxY && location.y > self.frame.minY)
        {
            if(location.x > self.frame.midX) {
                typeOfSwitcher = .day
                setDay(false, animated: true)

            }
            else{
                typeOfSwitcher = .night
                setNight(false, animated: true)
            }
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        endAnimation()
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            setProbablyAnimation(with: touch)
//        }
    }
}
