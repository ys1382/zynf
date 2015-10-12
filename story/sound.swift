import Foundation
import AudioToolbox

let sineFrequency = 880.0
var count = 0
let sampleFrequency = 44100.0
let bpm = Int(sampleFrequency) / 4

// MARK: User data struct
struct SineWavePlayer {
    var outputUnit: AudioUnit = nil
    var startingFrameCount = 0
}

// MARK: Callback function
let SineWaveRenderProc: AURenderCallback = {(inRefCon, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, ioData) -> OSStatus in
    var player = UnsafeMutablePointer<SineWavePlayer>(inRefCon)
    let cycleLength = sampleFrequency / sineFrequency

    for frame in 0..<inNumberFrames {
        count = count + 1
        var buffers = UnsafeMutableAudioBufferListPointer(ioData)
        let index = Double(player.memory.startingFrameCount + Int(frame))

        var up = 1.0
        if count > bpm {
            up = 2.0
        }
        if count > 2 * bpm {
            count = 0
        }
        
        let value = Float32(sin(2 * M_PI * (index / cycleLength * up)))
        UnsafeMutablePointer<Float32>(buffers[0].mData)[Int(frame)] = value
        UnsafeMutablePointer<Float32>(buffers[1].mData)[Int(frame)] = value
    }

    player.memory.startingFrameCount = (player.memory.startingFrameCount + Int(inNumberFrames)) % Int(cycleLength)
    return noErr
}

// MARK: Utility function
func CheckError(error: OSStatus, operation: String) {
    guard error != noErr else {
        return
    }
    
    var result: String = ""
    var char = Int(error.bigEndian)
    
    for _ in 0..<4 {
        guard isprint(Int32(char&255)) == 1 else {
            result = "\(error)"
            break
        }
        result.append(UnicodeScalar(char&255))
        char = char/256
    }
    
    print("Error: \(operation) (\(result))")
    
    exit(1)
}

func CreateAndConnectOutputUnit(inout player: SineWavePlayer) {
    // Generate a description that matches the output device (speakers)
    var outputcd = AudioComponentDescription(componentType: kAudioUnitType_Output, componentSubType: kAudioUnitSubType_DefaultOutput, componentManufacturer: kAudioUnitManufacturer_Apple, componentFlags: 0, componentFlagsMask: 0)
    
    let comp = AudioComponentFindNext(nil, &outputcd)
    
    if comp == nil {
        print("Can't get output unit")
        exit(-1)
    }
    
    CheckError(AudioComponentInstanceNew(comp, &player.outputUnit),
        operation: "Couldn't open component for outputUnit")
    
    // Register the render callback
    var input = AURenderCallbackStruct(inputProc: SineWaveRenderProc, inputProcRefCon: &player)
    
    CheckError(AudioUnitSetProperty(player.outputUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &input, UInt32(sizeof(input.dynamicType))),
        operation: "AudioUnitSetProperty failed")
    
    // Initialize the unit
    CheckError(AudioUnitInitialize(player.outputUnit),
        operation: "Couldn't initialize output unit")
}

func play() {
    var player = SineWavePlayer()
    
    // Set up output unit and callback
    CreateAndConnectOutputUnit(&player)
    
    // Start playing
    CheckError(AudioOutputUnitStart(player.outputUnit),
        operation: "Couldn't start output unit")
    
    // Play for 5 seconds
    sleep(4)
    
    // Clean up
    AudioOutputUnitStop(player.outputUnit)
    AudioUnitUninitialize(player.outputUnit)
    AudioComponentInstanceDispose(player.outputUnit)
}
