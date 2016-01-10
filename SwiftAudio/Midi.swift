//
//  MidiClient.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/9/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import CoreMIDI

class MidiDevice
{
    var device  = MIDIDeviceRef()
    var entity: MIDIEndpointRef?
    var source: MIDIEndpointRef?
    
    init(name: CFString)
    {
        let numDevices = MIDIGetNumberOfDevices()
        for deviceIndex in 0..<numDevices
        {
            let midiEndPoint = MIDIGetDevice(deviceIndex)
            if midiEndPoint > 0
            {
                var property : Unmanaged<CFString>?
                let err = MIDIObjectGetStringProperty(midiEndPoint, kMIDIPropertyName, &property)
                if err == noErr
                {
                    let displayName = property!.takeRetainedValue()
                    if displayName == name
                    {
                        device = midiEndPoint
                        entity = MIDIDeviceGetEntity(device, 0)
                        return
                    }
                }
            }
        }
    }
    
    func connectToInput(input: MidiInput)
    {
        source = MIDIEntityGetSource(entity!, 0)
        if(MIDIPortConnectSource(input.inputPtr.memory, source!, nil) == noErr)
        {
            print("Device succesfully connected to Input")
        }
    }
}

class MidiInput
{
    var inputPtr    = UnsafeMutablePointer<MIDIPortRef>.alloc(1)
    var input       = MIDIPortRef()
    
    var listeners   = [MidiProcessor]()
    
    init(client: MidiClient, name: CFString)
    {
        inputPtr.initialize(input)
        if (MIDIInputPortCreateWithBlock(client.midiClient, name, inputPtr, messageReceived) == noErr)
        {
            print("Midi input created succesfully")
        }
    }
    
    func messageReceived(packetList: UnsafePointer<MIDIPacketList>, source: UnsafeMutablePointer<Void>) -> Void
    {
        let packets     = packetList.memory
        let packet      = packets.packet
        
        let status = packet.data.0
        let channel = packet.data.0 & 0x0f
        var type = MidiMessageType.UNKNOWN
        var message = MidiMessage(aType: type, aPitch: 0, aVelocity: 0, aChannel: 0)
        
        switch(status >> 4)
        {
        case 0b1000:
            type = MidiMessageType.NOTEOFF
            message = MidiMessage(aType: type, aPitch: packet.data.1, aVelocity: packet.data.2, aChannel: channel)
            
        case 0b1001:
            type = MidiMessageType.NOTEON
            message = MidiMessage(aType: type, aPitch: packet.data.1, aVelocity: packet.data.2, aChannel: channel)
            
        case 0b1110:
            type = MidiMessageType.PITCHBEND
            message = MidiMessage(aType: type, aPitch: packet.data.1, aVelocity: packet.data.2, aChannel: channel)
            
        default:
            type = MidiMessageType.UNKNOWN
            message = MidiMessage(aType: type, aPitch: 0, aVelocity: 0, aChannel: 0)
        }
        
        
        for listener in listeners
        {
            listener.onMidiEvent(message)
        }
    }
    
    class func listDevices() -> [String]
    {
        var devices = [String]()
        
        let numSrcs = MIDIGetNumberOfSources()
        print("number of MIDI sources: \(numSrcs)")
        for srcIndex in 0 ..< numSrcs {
            #if arch(arm64) || arch(x86_64)
                let midiEndPoint = MIDIGetSource(srcIndex)
            #else
                let midiEndPoint = unsafeBitCast(MIDIGetSource(srcIndex), MIDIObjectRef.self)
            #endif
            var property : Unmanaged<CFString>?
            let err = MIDIObjectGetStringProperty(midiEndPoint, kMIDIPropertyDisplayName, &property)
            if err == noErr {
                let displayName = property!.takeRetainedValue() as String
                devices.append(displayName)
                print("\(srcIndex): \(displayName)")
            } else {
                print("\(srcIndex): error \(err)")
            }
        }
        
        let numdest = MIDIGetNumberOfDestinations()
        print("number of MIDI Destinations: \(numSrcs)")
        for destIndex in 0 ..< numdest {
            #if arch(arm64) || arch(x86_64)
                let midiEndPoint = MIDIGetDestination(destIndex)
            #else
                let midiEndPoint = unsafeBitCast(MIDIGetDestination(destIndex), MIDIObjectRef.self)
            #endif
            var property : Unmanaged<CFString>?
            let err = MIDIObjectGetStringProperty(midiEndPoint, kMIDIPropertyDisplayName, &property)
            if err == noErr {
                let displayName = property!.takeRetainedValue() as String
                devices.append(displayName)
                print("\(destIndex): \(displayName)")
            } else {
                print("\(destIndex): error \(err)")
            }
        }
        
        return devices
    }
}

class MidiClient
{
    var midiClient = MIDIClientRef()
    
    init()
    {
        if(MIDIClientCreateWithBlock("MyMIDIClient", &midiClient, MyMIDINotifyBlock) == noErr)
        {
            print("Midi client created succesfully")
        }
    }
    
    func MyMIDINotifyBlock(midiNotification: UnsafePointer<MIDINotification>) {
        print("State of the midi system changed")
    }
}

enum MidiMessageType
{
    case NOTEON
    case NOTEOFF
    case PITCHBEND
    case UNKNOWN
}

class MidiMessage
{
    var type:       MidiMessageType
    var pitch:      UInt8
    var velocity:   UInt8
    var channel:    UInt8
    
    init(aType: MidiMessageType, aPitch: UInt8, aVelocity: UInt8, aChannel: UInt8)
    {
        type        = aType
        pitch       = aPitch
        velocity    = aVelocity
        channel     = aChannel
    }
    
    func isNoteOn() -> Bool{
        return type == .NOTEON
    }
    
    func isNoteOff() -> Bool{
        return type == .NOTEOFF
    }
    
    func isPitchBend() -> Bool{
        return type == .PITCHBEND
    }
    
    func midiToFrequency() -> Float32{
        return powf(2.0, (Float(pitch) - 69.0)/12.0) * 440.0
    }
}

protocol MidiProcessor
{
    func onMidiEvent(event: MidiMessage)
}