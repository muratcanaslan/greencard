//
//  AnimatedProgressView.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 8.03.2024.
//

import UIKit

public class CircleProgressAnimationLayer: ProgressAnimationLayer {

   override public func draw(in ctx: CGContext) {
       UIGraphicsPushContext(ctx)
       let size = ctx.convertToUserSpace(CGSize(width: ctx.width, height: ctx.height))
       let rect = CGRect(origin: CGPoint.zero, size: size)

       ProgressStyleKit.drawProgressCircleDisplay(frame: rect, resizing: .aspectFit, progress: progress, showTriangle: showTriangle)
       UIGraphicsPopContext()
   }
}

@IBDesignable public class CircleProgressView: UIView, AnimatedUIView {
   @IBInspectable public var progress: CGFloat = 0.5 { didSet { updateValue() } }
   @IBInspectable public var progressColor: UIColor = UIColor.softGrayColor { didSet { updateValue() } }
   @IBInspectable public var showTriangle: Bool = false { didSet { updateValue() } }

   var animatedLayer: Progressable = CircleProgressAnimationLayer()
   var stateKeyName = "state"

   override public func layoutSubviews() {
       setupAnimationLayer(progressColor: progressColor, showTriangle: showTriangle)
       animatedLayer.frame = self.bounds
   }

}

protocol Progressable: CALayer {
    var progress: CGFloat { get set }
    var progressColor: UIColor { get set }
    var showTriangle: Bool { get set }
}

public class ProgressAnimationLayer: CALayer, Progressable {
    @NSManaged var progress: CGFloat
    private static let keyName = "progress"
    var progressColor: UIColor = UIColor.softGrayColor
    var showTriangle: Bool = false

    override init() {
        super.init()
        progress = 0
        needsDisplayOnBoundsChange = true
    }

    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? Progressable {
            progress = layer.progress
            progressColor = layer.progressColor
            showTriangle = layer.showTriangle
        }
    }

    override public class func needsDisplay(forKey key: (String?)) -> Bool {
        guard let key = key else { return false }
        if key == keyName {
            return true
        } else {
            return super.needsDisplay(forKey: key)
        }
    }

    override public func action(forKey event: String) -> CAAction? {
        if event == ProgressAnimationLayer.keyName {
            let animation = CABasicAnimation(keyPath: event)
            animation.fromValue = self.presentation()?.value(forKey: event)
            return animation
        } else {
            return super.action(forKey: event)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}

protocol AnimatedUIView: UIView {
    var animatedLayer: Progressable { get set }
    var progress: CGFloat { get set }
    var progressColor: UIColor { get set }
    var showTriangle: Bool { get set }
    var stateKeyName: String { get set }
}

extension AnimatedUIView {

    func setupAnimationLayer(progressColor: UIColor, showTriangle: Bool = false) {
        guard self.layer.sublayers == nil || self.layer.sublayers?.contains(animatedLayer) == false else { return }
        animatedLayer.contentsScale = UIScreen.main.scale
        animatedLayer.frame = self.bounds
        animatedLayer.setValue(false, forKey: stateKeyName)
        animatedLayer.progressColor = progressColor
        animatedLayer.showTriangle = showTriangle

        self.layer.addSublayer(animatedLayer)
        animatedLayer.setNeedsDisplay()
    }

    internal func updateValue() {
        // in the storyboard preview the state is not set
        guard let layerState = ((animatedLayer.value(forKey: stateKeyName) as AnyObject).boolValue) else {
            animatedLayer.progress = progress
            animatedLayer.progressColor = self.progressColor
            animatedLayer.showTriangle = self.showTriangle
            animatedLayer.setValue(false, forKey: stateKeyName)
            return
        }

        let timing: CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timing)
        animatedLayer.progress = progress
        animatedLayer.progressColor = self.progressColor
        animatedLayer.showTriangle = self.showTriangle

        CATransaction.commit()
        animatedLayer.setValue(!layerState, forKey: stateKeyName)
    }
}

public class ProgressStyleKit : NSObject {

    //// Drawing Methods

    @objc dynamic public class func drawProgressBarDisplay(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 136, height: 16), resizing: ResizingBehavior = .aspectFit, progress: CGFloat = 0.723, showTriangle: Bool = true, progressColorRed: CGFloat = 0, progressColorGreen: CGFloat = 0.475, progressColorBlue: CGFloat = 1) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 136, height: 16), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 136, y: resizedFrame.height / 16)





        //// Variable Declarations
        let progressWidth: CGFloat = 136 * progress
        let progressWidthOffset: CGFloat = progressWidth - 3.5
        let progressVisible = progress > 0
        let progressBarColor = UIColor(red: progressColorRed, green: progressColorGreen, blue: progressColorBlue, alpha: 1)

        //// Rectangle 2 Drawing
        context.saveGState()
        context.setAlpha(0.2)
        context.beginTransparencyLayer(auxiliaryInfo: nil)

        let rectangle2Path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 136, height: 9), cornerRadius: 3)
        context.saveGState()
        progressBarColor.setFill()
        rectangle2Path.fill()
        context.restoreGState()


        context.endTransparencyLayer()
        context.restoreGState()


        //// Group
        context.saveGState()
        context.beginTransparencyLayer(auxiliaryInfo: nil)

        //// Clip Rectangle 3
        let rectangle3Path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 136, height: 9), cornerRadius: 3)
        rectangle3Path.addClip()


        if (progressVisible) {
            //// Rectangle Drawing
            let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: progressWidth, height: 9), cornerRadius: 3)
            progressBarColor.setFill()
            rectanglePath.fill()
        }


        context.endTransparencyLayer()
        context.restoreGState()
        
        context.saveGState()

        context.restoreGState()


        if (showTriangle) {
            //// Polygon Drawing
            context.saveGState()
            context.translateBy(x: progressWidthOffset, y: 9.5)

            let polygonPath = UIBezierPath()
            polygonPath.move(to: CGPoint(x: 3.5, y: 0))
            polygonPath.addLine(to: CGPoint(x: 6.53, y: 5.25))
            polygonPath.addLine(to: CGPoint(x: 0.47, y: 5.25))
            polygonPath.close()
            progressBarColor.setFill()
            polygonPath.fill()

            context.restoreGState()
        }
        
        context.restoreGState()

    }

    @objc dynamic public class func drawProgressCircleDisplay(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 140, height: 140), resizing: ResizingBehavior = .aspectFit, progress: CGFloat = 0.723, showTriangle: Bool = true, progressColorRed: CGFloat = 0, progressColorGreen: CGFloat = 0.475, progressColorBlue: CGFloat = 1) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 140, height: 140), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 140, y: resizedFrame.height / 140)

        //// Variable Declarations
        let progressEndAngle: CGFloat = progress == 1 ? 0.001 : 360 * (1 - progress)
        let progressBarColor = UIColor(red: progressColorRed, green: progressColorGreen, blue: progressColorBlue, alpha: 1)

        context.saveGState()
        context.restoreGState()


        //// progressRingBackground Drawing
        context.saveGState()
        context.translateBy(x: 70, y: 70)
        context.rotate(by: -90 * CGFloat.pi/180)

        context.saveGState()
        context.setAlpha(0.2)
        context.beginTransparencyLayer(auxiliaryInfo: nil)

        let progressRingBackgroundPath = UIBezierPath(ovalIn: CGRect(x: -60, y: -60, width: 120, height: 120))
        context.saveGState()

        progressBarColor.setStroke()
        progressRingBackgroundPath.lineWidth = 12.0
        progressRingBackgroundPath.stroke()
        context.restoreGState()

        context.endTransparencyLayer()
        context.restoreGState()

        context.restoreGState()


        //// Oval Drawing
        context.saveGState()
        context.translateBy(x: 70, y: 70)
        context.rotate(by: -90 * CGFloat.pi/180)

        let ovalRect = CGRect(x: -60, y: -60, width: 120, height: 120)
        let ovalPath = UIBezierPath()
        ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.midY), radius: ovalRect.width / 2, startAngle: 0 * CGFloat.pi/180, endAngle: -progressEndAngle * CGFloat.pi/180, clockwise: true)

        context.saveGState()

        progressBarColor.setStroke()
        ovalPath.lineWidth = 12.0
        ovalPath.lineCapStyle = .round
        ovalPath.stroke()
        context.restoreGState()

        context.restoreGState()


        if (showTriangle) {
            //// Polygon Drawing
            context.saveGState()
            context.translateBy(x: 70, y: 70)
            context.rotate(by: -progressEndAngle * CGFloat.pi/180)

            let polygonPath = UIBezierPath()
            polygonPath.move(to: CGPoint(x: 0, y: -54))
            polygonPath.addLine(to: CGPoint(x: 5.63, y: -43.5))
            polygonPath.addLine(to: CGPoint(x: -5.63, y: -43.5))
            polygonPath.close()
            progressBarColor.setFill()
            polygonPath.fill()

            context.restoreGState()
        }
        
        context.restoreGState()

    }



    @objc(ProgressStyleKitResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
