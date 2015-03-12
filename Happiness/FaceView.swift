//
//  FaceView.swift
//  Happiness
//
//  Created by Allen Lai on 12/03/2015.
//  Copyright (c) 2015 Allen. All rights reserved.
//

import UIKit

class FaceView: UIView {
  
  var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
  var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
  var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
  
  var faceCenter: CGPoint {
    return convertPoint(center, fromView: superview)
  }
  
  var faceRadius: CGFloat {
    return min(bounds.size.width, bounds.size.height) / 2 * scale
  }
  
  private struct Scaling {
    static let FaceRadiusToEyeRadiusRadio: CGFloat = 10
    static let FaceRadiusToEyeOffsetRadio: CGFloat = 3
    static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
    static let FaceRadiusToMouthWidthRadio: CGFloat = 1
    static let FaceRadiusToMouthHeightRadio: CGFloat = 3
    static let FaceRadiusToMouthOffsetRadio: CGFloat = 3
  }
  
  private enum Eye { case Left, Right }

  private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
    let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRadio
    let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRadio
    let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
    
    var eyeCenter = faceCenter
    eyeCenter.y -= eyeVerticalOffset
    switch whichEye {
    case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
    case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
    }
    
    let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
    path.lineWidth = lineWidth
    return path
  }
  
  private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath {
    let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRadio
    let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRadio
    let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRadio
    
    let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
    
    let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
    let end = CGPoint(x: start.x + mouthWidth, y: start.y)
    let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
    let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
    
    let path = UIBezierPath()
    path.moveToPoint(start)
    path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
    path.lineWidth = lineWidth
    return path
  }
  
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
    let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
    facePath.lineWidth = 3
    color.set()
    facePath.stroke()
    
    bezierPathForEye(.Left).stroke()
    bezierPathForEye(.Right).stroke()
    
    let smiliness = 0.75
    let smilePath = bezierPathForSmile(smiliness)
    smilePath.stroke()
  }

}