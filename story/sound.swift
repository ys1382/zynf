import Foundation
import AudioToolbox

let sampleFrequency = 44100.0
let sineFrequency = 880.0
let step = pow(2, 1.0/12)
var count = 0
let bpm = Int(sampleFrequency) / 4
var note = -10.0
var intervals = [-5,-3,3,5]

// MARK: User data struct
struct SineWavePlayer {
    var outputUnit: AudioUnit = nil
    var startingFrameCount = 0
}

// next steps:
// 1) come up with a sequence of notes, then play them.
// 2) Each interval is most likely a 3rd or 5th, or anything else, close more likely than distant.
// 3) Each note may be split into 1, 1/2, 1/3, 1/4, in order of probability
// 4) the second of the split is off by an interval

// MARK: Callback function
let SineWaveRenderProc: AURenderCallback = {(inRefCon, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, ioData) -> OSStatus in
    var player = UnsafeMutablePointer<SineWavePlayer>(inRefCon)
    var freq = 1.0

    for frame in 0..<inNumberFrames {

        if count % bpm == 0 {
            let intervalIndex = Int(arc4random_uniform(UInt32(intervals.count)))
            let interval = Double(intervals[intervalIndex])
            print(note, interval)
            note = -10 + interval
        }
        freq = sampleFrequency * pow(step, -note)
        let cycleLength = freq / sineFrequency

        count = count + 1
        var buffers = UnsafeMutableAudioBufferListPointer(ioData)
        let index = Double(player.memory.startingFrameCount + Int(frame))

        let value = Float32(sin(2 * M_PI * (index / cycleLength)))
        UnsafeMutablePointer<Float32>(buffers[0].mData)[Int(frame)] = value
        UnsafeMutablePointer<Float32>(buffers[1].mData)[Int(frame)] = value
    }

    player.memory.startingFrameCount = (player.memory.startingFrameCount + Int(inNumberFrames))
        //% Int(freq / sineFrequency)
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
