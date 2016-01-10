//
//  Instrument.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/9/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

class Voice<T: Arithmetic>: Signal<T>{
    
    func play() -> Void{
        
    }
    
    func stop() -> Void{
        
    }
    
    var uid: UInt32 = 0
}

class WaveTableVoice: Voice<Float32>
{
    var wave: WaveTable?
    
    var phasor          = Phasor()
    var shouldPlay      = false
    
    override init() {
        
    }
    
    func setWaveTable(inout wavetable: WaveTable) {
        wave = wavetable
    }
    
    override func generateSample(timestamp: Int) {
        if shouldPlay {
        sample = wave![phasor[timestamp]]
        } else {
            sample = 0.0
        }
    }
    
    override func play() -> Void {
        shouldPlay = true
    }
    
    override func stop() -> Void {
        shouldPlay = false
    }
}

class WaveTableSynth: Signal<Float32>, MidiProcessor
{
    var voices = [WaveTableVoice]()
    var wave    = WaveTable(size: 2048)
    
    override init() {
        wave.createSpectrum([1.0, 0.5, 0.33, 0.25])
    }
    
    func getFreeVoice() -> WaveTableVoice?
    {
        for voice in voices
        {
            if !voice.shouldPlay
            {
                return voice
            }
        }
        
        return nil
    }
    
    func onMidiEvent(event: MidiMessage) {
        if event.isNoteOn()
        {
            var voice = getFreeVoice()
            if voice != nil {
                voice!.phasor.frequency = DC(value: event.midiToFrequency())
                voice!.uid = UInt32(event.pitch)
                voice!.play()
            } else {
                voice = WaveTableVoice()
                voice!.setWaveTable(&wave)
                voice!.phasor.frequency = DC(value: event.midiToFrequency())
                voice!.uid = UInt32(event.pitch)
                voice!.play()
                voices.append(voice!)
            }
        }
        
        if event.isNoteOff()
        {
            for voice in voices
            {
                if voice.uid == UInt32(event.pitch)
                {
                    voice.stop()
                }
            }
        }
    }
    
    override func generateSample(timestamp: Int) {
        var sum: Float32 = 0.0
        for voice in voices
        {
            sum += voice[timestamp]
        }
        sample = sum
    }
}