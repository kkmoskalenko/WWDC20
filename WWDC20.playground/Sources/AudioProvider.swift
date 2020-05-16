import AVFoundation

public class AudioProvider {
    private static var player: AVAudioPlayer?
    
    public static func playSound(_ sound: SoundType) {
        guard let name = sound.filename else { return }
        guard let url = Bundle.main.url(
            forResource: name,
            withExtension: "mp3",
            subdirectory: "Sounds"
            ) else { fatalError(
                "Failed to locate \(name).mp3 in bundle."
                ) }
        
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
}

extension AudioProvider {
    public enum SoundType {
        case pop(Int =
            .random(in: 1...7))
        
        case triplePop(Int =
            .random(in: 1...7))
        
        var name: String {
            switch self {
            case .pop: return "pop"
            case .triplePop: return "triplepop"
            }
        }
        
        var value: Int {
            switch self {
            case .pop(let x): return x
            case .triplePop(let x): return x
            }
        }
        
        var filename: String? {
            var value = self.value
            
            if value > 7 { value = 7 }
            guard value > 0 else { return nil }
            
            return "\(name)\(value)"
        }
    }
}
