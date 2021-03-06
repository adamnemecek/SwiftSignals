//
//  AudioStream.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/7/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox

var samples: [Float32]?
var samplePtr: UnsafeMutablePointer<Float32>?

var renderBuffer: AudioBuffer<Float32>?

var numChannels = 0

func callback(data: UnsafeMutablePointer<Void>,
    flags: UnsafeMutablePointer<AudioUnitRenderActionFlags>,
    timeStamp: UnsafePointer<AudioTimeStamp>,
    bus: UInt32, numFrames: UInt32, buffers: UnsafeMutablePointer<AudioBufferList>) -> OSStatus
{
    if samples == nil
    {
        renderBuffer = AudioBuffer<Float32>(numChannels: numChannels, size: Int(numFrames))
    }
    
    let audio: AudioStream = fromVoid(data)
    audio.onRender(numChannels: numChannels, numFrames: Int(numFrames), timestamp: UInt64(timeStamp.memory.mSampleTime), renderBuffer!)
    
    memcpy(buffers.memory.mBuffers.mData, renderBuffer![0], sizeof(Float32) * Int(renderBuffer!.size * renderBuffer!.numChannels))
    
    return 0
}

class AudioDevice
{
    var id: AudioDeviceID?
    var name: String?
    var manufacturer: String?
    var channelName: String?
    
    init(deviceId: AudioDeviceID)
    {
        id = deviceId
    }
    
    class func listDevices() -> [AudioDevice]
    {
        var audioDevices = [AudioDevice]()
        
        let sizePtr = toPointer(UInt32(sizeof(AudioObjectID)))
        let propertyAdressPointer = toPointer(AudioObjectPropertyAddress())
        propertyAdressPointer.memory.mScope = kAudioObjectPropertyScopeGlobal
        propertyAdressPointer.memory.mSelector = kAudioHardwarePropertyDevices
        propertyAdressPointer.memory.mElement = kAudioObjectPropertyElementMaster
        
        AudioObjectGetPropertyDataSize(UInt32(kAudioObjectSystemObject), propertyAdressPointer, 0, nil, sizePtr)
        
        let numDevices = sizePtr.memory / UInt32(sizeof(AudioObjectID))
        let deviceIds = UnsafeMutablePointer<AudioObjectID>.alloc(Int(numDevices))
        AudioObjectGetPropertyData(UInt32(kAudioObjectSystemObject), propertyAdressPointer, 0, nil, sizePtr, deviceIds)
        
        var deviceAddress   = AudioObjectPropertyAddress()
        let deviceName      = UnsafeMutablePointer<CChar>.alloc(64)
        let manufacturer    = UnsafeMutablePointer<CChar>.alloc(64)
        let channelName     = UnsafeMutablePointer<CChar>.alloc(64)
        
        for device in 0..<numDevices
        {
            deviceAddress.mSelector = UInt32(kAudioDevicePropertyDeviceName)
            deviceAddress.mScope    = UInt32(kAudioObjectPropertyScopeGlobal)
            deviceAddress.mElement  = UInt32(kAudioObjectPropertyElementMaster)
            let deviceAdressPointer = toPointer(AudioObjectPropertyAddress())
            deviceAdressPointer.initialize(deviceAddress)
            
            AudioObjectGetPropertyData(deviceIds[Int(device)], deviceAdressPointer, 0, nil, sizePtr, deviceName)
            
            deviceAddress.mSelector = UInt32(kAudioDevicePropertyDeviceManufacturer)
            deviceAddress.mScope    = UInt32(kAudioObjectPropertyScopeGlobal)
            deviceAddress.mElement  = UInt32(kAudioObjectPropertyElementMaster)
            deviceAdressPointer.initialize(deviceAddress)
            
            AudioObjectGetPropertyData(deviceIds[Int(device)], deviceAdressPointer, 0, nil, sizePtr, manufacturer)
            
            let audioDevice = AudioDevice(deviceId: deviceIds[Int(device)])
            audioDevice.name            = String.fromCString(deviceName)
            audioDevice.manufacturer    = String.fromCString(manufacturer)
            audioDevice.channelName     = String.fromCString(channelName)
            audioDevices.append(audioDevice)
        }
        
        return audioDevices
    }
}

class AudioDeviceSettings
{
    var audioInputDevice: AudioDevice?
    var audioOutputDevice: AudioDevice?
}

class AudioSettings
{
    var sampleRate: Float32 = 44100.0
}

class AudioStream: NSObject
{
    var graph           = UnsafeMutablePointer<AUGraph>.alloc(1)
    var outputUnit: AudioUnit
    var outputNode: AUNode
    var cdPtr           = UnsafeMutablePointer<AudioComponentDescription>.alloc(1)
    let renderFunction  = callback
    var string = ""
    var cb: AURenderCallbackStruct?
    var streamDescription: AudioStreamBasicDescription?
    var sampleRate: Float64?
    
    var onRender: (numChannels: Int, numFrames: Int, timestamp: UInt64, AudioBuffer<Float32>) -> Void = {_,_,_,_ in }
    
    override init()
    {
        
        outputNode = AUNode()
        outputUnit = AudioUnit()
        super.init()
        
        let cd = AudioComponentDescription(componentType: OSType(kAudioUnitType_Output),
            componentSubType: OSType(kAudioUnitSubType_HALOutput),
            componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
            componentFlags: 0, componentFlagsMask: 0)
        
        cdPtr.initialize(cd)
        
        NewAUGraph(graph)
        AUGraphAddNode(graph.memory, cdPtr, &outputNode)
        
        cb = AURenderCallbackStruct(inputProc: callback, inputProcRefCon: toVoid(self))

        AUGraphSetNodeInputCallback(graph.memory, outputNode, 0, &cb!)
        AUGraphSetNodeInputCallback(graph.memory, outputNode, 1, &cb!)
        AUGraphOpen(graph.memory)
        AUGraphNodeInfo(graph.memory, outputNode, cdPtr, &outputUnit)
        
        let desc = UnsafeMutablePointer<AudioStreamBasicDescription>.alloc(1)
        
        let size: UInt32 = UInt32(sizeof(AudioStreamBasicDescription))
        let sizePtr = UnsafeMutablePointer<UInt32>.alloc(1)
        sizePtr.initialize(UInt32(size))
        
        AudioUnitGetProperty(outputUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &desc.memory, sizePtr)
        
        streamDescription = desc.memory
        numChannels = Int(streamDescription!.mChannelsPerFrame)
        sampleRate = streamDescription?.mSampleRate

        AUGraphInitialize(graph.memory)
    }
    
    func start(_: Void) -> OSStatus
    {
        return AUGraphStart(graph.memory)
    }
    
    func stop(_:Void) -> OSStatus
    {
        return AUGraphStop(graph.memory)
    }
    
    func destroy(_: Void) -> OSStatus
    {
        AUGraphUninitialize(graph.memory);
        cdPtr.destroy()
        graph.destroy()
        return 0
    }
}