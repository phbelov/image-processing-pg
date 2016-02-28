import Foundation

// I decided to create a 'clamping' function for easier assigning values to the pixel components
func clamp(value: Int) -> UInt8 {
    return UInt8(max(0, min(255, value)))
}
func clamp8(value: UInt8) -> UInt8 {
    return UInt8(max(0, min(255, value)))
}
