//
//  main.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/7/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

let stream = AudioStream()
AudioStream.getDevices()
let x = WaveTableSynth()

var n = 0

let client  = MidiClient()
let midiIn   = MidiInput(client: client, name: "Input 1")
midiIn.listeners.append(x)

MidiInput.listDevices()

let device  = MidiDevice(name: "MPK mini")
device.connectToInput(midiIn)

stream.onRender = {numChannels, numFrames, timestamp, buffer in
    
    for frame in 0..<numFrames
    {
        for channel in 0..<numChannels
        {
            buffer[channel][frame] = x[n]
        }
        n++
    }
}

stream.start()

while(true){
    sleep(1)

}

stream.stop()
stream.destroy()

