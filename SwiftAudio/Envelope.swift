//
//  Envelope.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/10/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

class EnvelopePoint
{
    var target              = Float32()
    var rampTime: UInt64    = 0
    var time                = 0
    var hold                = false
    
    init(targetValue: Float32, timeInSamples: UInt64, hold: Bool = false)
    {
        target = targetValue
        rampTime = timeInSamples
    }
}

protocol EnvelopeListener
{
    func envelopeFinished()
}

class Envelope: Signal<Float32>
{
    var segments        = [EnvelopePoint]()
    var currentSegment  = 0
    var phinc           = Float32()
    var currentValue    = Float32()
    var currentTime     = 0
    var listeners       = [EnvelopeListener]()
    
    override func generateSample(timestamp: Int) {
        sample = currentValue
        
        if UInt64(currentTime) == segments[currentSegment].rampTime && currentSegment < segments.count - 1 {
            if(!segments[currentSegment].hold) {
                triggerNextSegment()
                return
            }
        }
        
        if UInt64(currentTime) == segments[currentSegment].rampTime  && currentSegment == segments.count - 1 {
            for listener in listeners {
                listener.envelopeFinished()
            }
        }
        
        currentTime++
        currentValue += phinc
    }
    
    func addPoint(targetValue: Float32, timeInSamples: UInt64, hold: Bool = false) {
        segments.append(EnvelopePoint(targetValue: targetValue, timeInSamples: timeInSamples, hold: hold))
    }
    
    func triggerFirstSegment() {
        currentSegment = 0
        currentTime = 0
        phinc = segments[0].target / Float32(segments[0].rampTime)
    }
    
    func triggerLastSegment() {
        currentSegment = segments.count - 1
        phinc = -currentValue / Float32(segments[currentSegment].rampTime)
        currentTime = 0
    }
    
    func triggerNextSegment() {
        if(currentSegment + 1 < segments.count - 1) {
            phinc = (segments[currentSegment].target - currentValue) / Float32(segments[currentSegment].rampTime)
            currentTime = 0
            currentSegment++
        }
    }
}