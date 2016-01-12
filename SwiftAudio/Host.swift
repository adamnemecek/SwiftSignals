//
//  Host.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/9/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

class Transport
{
    var time: UInt64    = 0
    private var samplesPerBeat: UInt64 = 0
    
    var bpm: UInt64 {
        get {
            return self.bpm
        }
        set(newBpm) {
            
            samplesPerBeat = 44100 / 4 / newBpm
        }
    }
    
    private var playing = false
    
    init() {
        bpm = 120
    }
    
    func start() -> Void {
        playing = true
    }
    
    func stop() -> Void {
        playing = false
    }
    
    func reset() -> Void {
        time = 0
    }
    
    func step() -> Void {
        if(playing) {
            time++
        }
    }
}

class Host
{
    var transport       = Transport()
    var audioSettings   = AudioDeviceSettings()
    var audioStream     = AudioStream()
    
    var midiClient      = MidiClient()
    var midiIn          : MidiInput?
    
    func startAudioStream() {
        audioStream.start()
    }
    
    //---------------------------------
    static let sharedInstance = Host()
    private init()
    {
        midiIn = MidiInput(client: midiClient, name: "Midi In 1")
        audioStream.onRender = {numChannels, numFrames, timestamp, buffer in
            
            for _ in 0..<numFrames
            {
                for _ in 0..<numChannels
                {
                    
                }
                
                self.transport.step()
            }
        }
    }
}
