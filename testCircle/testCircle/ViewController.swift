//
//  ViewController.swift
//  testCircle
//
//  Created by Юрий Девятаев on 03.05.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var propConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var image: UIImageView!
        
    var isTap = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if circleView.layer.cornerRadius != circleView.frame.width / 2 {
            configUI()
        }
    }
    
    func config() {
        containerView.backgroundColor = .lightGray
        circleView.backgroundColor = .red
        image.backgroundColor = .black
        circleView.clipsToBounds = true
        image.contentMode = .scaleAspectFill
    }
    
    func configUI() {
        circleView.layoutIfNeeded()
        circleView.layer.cornerRadius = circleView.frame.width / 2
    }

    @IBAction func actionButton(_ sender: UIButton) {
        let screen = createScreen(someView: circleView)
        let frame = circleView.convert(circleView.bounds, to: self.view)
        screen.frame = frame
        view.addSubview(screen)
        
        isTap = !isTap
//        animateConstraint()
        animateAdding(someView: screen)
    }
    
    func createScreen(someView: UIView) -> UIImageView {
        let screen = someView.screenshot()
        let screenView = UIImageView()
        screenView.contentMode = .scaleAspectFill
        screenView.backgroundColor = .clear
        screenView.image = screen
        return screenView
    }
    
    func animateConstraint() {
        let mul = isTap ? 0.6 : 0.4
        let newConstraint = propConstraint.constraintWithMultiplier(mul)
        self.containerView.removeConstraint(self.propConstraint)
        self.containerView.addConstraint(newConstraint)
        self.propConstraint = newConstraint
        let duration: TimeInterval = 0.3
        UIView.animate(withDuration: duration) {
            self.circleView.layoutIfNeeded()
            self.image.layoutIfNeeded()
        }
        animateChangingCornerRadius(toValue: circleView.frame.size.width / 2, duration: duration)
    }
    
    private func animateChangingCornerRadius(toValue: CGFloat, duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(
            name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fromValue = circleView.layer.cornerRadius
        animation.toValue =  toValue
        animation.duration = duration
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.layer.add(animation, forKey:"cornerRadius")
    }
    
    func animateAdding(someView: UIView) {
        let path = UIBezierPath()
        
        let startPoint = someView.center
        let endPoint = CGPoint(x: 300, y: 700)
        let controlPoint = CGPoint(x: someView.frame.minX + someView.frame.width,
                                      y: someView.frame.midY - someView.frame.height)
        
        path.move(to: startPoint)
        path.addCurve(to: endPoint, controlPoint1: controlPoint, controlPoint2: controlPoint)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = 1
        someView.layer.add(animation, forKey: "position")
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn) {
            someView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        } completion: { result in
            someView.alpha = 0
        }
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!,
                                  attribute: self.firstAttribute,
                                  relatedBy: self.relation,
                                  toItem: self.secondItem,
                                  attribute: self.secondAttribute,
                                  multiplier: multiplier,
                                  constant: self.constant)
    }
}

extension UIView {
  func screenshot() -> UIImage {
    return UIGraphicsImageRenderer(size: bounds.size).image { _ in
      drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
    }
  }
}
