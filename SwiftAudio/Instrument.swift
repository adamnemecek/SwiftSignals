//
//  Instrument.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/9/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

protocol Voice {
    
    func play() -> Void
    
    func stop() -> Void
    
    var uid: UInt32{set get}
}

class WaveTableVoice: Signal<Float32>, Voice, EnvelopeListener
{
    var wave: WaveTable?
    let envelope = Envelope()
    var phasor          = Phasor()
    var isFree          = false
    var uid             = UInt32()
    
    override init() {
        super.init()
        envelope.addPoint(0.707, timeInSamples: 50)
        envelope.addPoint(0.5, timeInSamples: 50, hold: true)
        envelope.addPoint(0.0, timeInSamples: 22000, hold: true)
        
        envelope.listeners.append(self)
    }
    
    func setWaveTable(inout wavetable: WaveTable) {
        wave = wavetable
    }
    
    override func generateSample(timestamp: Int) {
        sample = wave![phasor[timestamp]] * envelope[timestamp]
    }
    
    func play() -> Void {
        isFree = false
        envelope.triggerFirstSegment()
    }
    
    func stop() -> Void {
        envelope.triggerLastSegment()
    }
    
    func envelopeFinished() {
        isFree = true
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
            if voice.isFree
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
            if !voice.isFree
            {
                sum += voice[timestamp]
            }
        }
        
        sample = sum
    }
}