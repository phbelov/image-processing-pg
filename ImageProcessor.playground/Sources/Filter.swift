import Foundation
import UIKit
import Darwin

public class Filter {
    // Intensity has a default red of 0 : if the intenisty is not set then the filter is not applied
    var intensity : Int = 0
    
    // Default Initializer
    public init() {
    }
    public init(intensity : Int) {
        self.intensity = intensity
    }

    public func applyTo(image: RGBAImage) -> UIImage {
        for y in 0..<image.height {
            for x in 0..<image.width {
                let index = y * image.width + x
                image.pixels[index] = processPixel(image.pixels[index])
            }
        }
        
        return image.toUIImage()!
    }
    public func processPixel(pixel: Pixel) -> Pixel {
        return pixel
    }
}

// Brightness
public class Brightness : Filter {
    
    override public func processPixel(var pixel: Pixel) -> Pixel {
        let formula = self.intensity * 128 / 100
        pixel.red = clamp(Int(pixel.red) + formula)
        pixel.blue = clamp(Int(pixel.blue) + formula)
        pixel.green = clamp(Int(pixel.green) + formula)
        return pixel
    }
}

// Contrast
public class Contrast : Filter {
    
    override public func processPixel(var pixel: Pixel) -> Pixel {
        pixel.red = componentValue(pixel.red)
        pixel.green = componentValue(pixel.green)
        pixel.blue = componentValue(pixel.blue)
        return pixel
    }
    private func componentValue(channel : UInt8) -> UInt8 {
            var formula = 0
        
            // Depending on whether the user wants to increase or decrease contrast we apply different formulas to pixel
            if self.intensity > 0 {
                formula = (Int(channel) * 100 - 128 * self.intensity) / (100 - self.intensity)
            } else {
                formula = (Int(channel) * (100 - abs(self.intensity)) + 128 * abs(self.intensity)) / 100
            }
            return UInt8(max(0, min(255, formula)))
    }
}

// Grayscale
public class Grayscale : Filter {
    
//    override public init(intensity : Int) {
//        super.init()
//        self.intensity = 0
//    }
    
    override public func processPixel(var pixel: Pixel) -> Pixel {
        let average = (Int(pixel.red) + Int(pixel.green) + Int(pixel.blue)) / 3
        
        // Assigning Each Component of the Pixel to the Average Value (aValue)
        let aValue = clamp(average * 2 * (1 + self.intensity / 100))
        pixel.red = aValue
        pixel.green = aValue
        pixel.blue = aValue
        
        return pixel
    }
    
}

// Color Balance
public class ColorBalance : Filter {
    
    // Default Color Channel to Modify is Red
    var channel : ColorChannel = .Red
    public init (intensity : Int, channel : ColorChannel) {
        super.init()
        self.intensity = intensity
        self.channel = channel
    }
    
    override public func processPixel(var pixel: Pixel) -> Pixel {
        
        // Processing a pixel component depends on a color channel that was provided by a user
        switch(self.channel) {
        case .Red :
            pixel.red = clamp(Int(pixel.red) + self.intensity * 128 / 100)
            break
        case .Green :
            pixel.green = clamp(Int(pixel.green) + self.intensity * 128 / 100)
            break
        case .Blue :
            pixel.blue = clamp(Int(pixel.blue) + self.intensity * 128 / 100)
            break
        }
        
        return pixel
    }
}

public class GaussBlur {
    
    let sourceImage : RGBAImage
    let processedImage : RGBAImage
    var radius : Int = 3
    //var boxesSize : Int =  3
    
    public init(sourceImage : RGBAImage, radius : Int) {
        self.sourceImage = sourceImage
        self.processedImage = sourceImage
        self.radius = radius
        //self.boxesSize = 3
    }
    
    public func process() -> UIImage {
        struct Channels {
            var red = 0.0
            var green = 0.0
            var blue = 0.0
        }
        var value = Channels()
        let significantRadius = Int(ceil(Double(radius) * 2.57))
        for var i = 0; i < sourceImage.height; i++ {
            for var j = 0; j < sourceImage.width; j++ {
                value.red = 0.0
                value.green = 0.0
                value.blue = 0.0
                var weightSum = 0.0
                for var iy = i - significantRadius; iy < i + significantRadius; iy++ {
                    for var ix = j - significantRadius; ix < j + significantRadius + 1; ix++ {
                        let x = min(sourceImage.width - 1, max(0, ix))
                        let y = min(sourceImage.width - 1, max(0, iy))
                        let dsq = (ix - j)*(ix - j) + (iy - i)*(iy - i)
                        let weight = exp( Double(-dsq) / Double(2*radius*radius) ) / (M_PI * 2*Double(radius*radius))
                        value.red = Double(sourceImage.pixels[y*sourceImage.width + x].red) * weight
//                        value.green = Double(sourceImage.pixels[y*sourceImage.width + x].green) * weight
//                        value.blue = Double(sourceImage.pixels[y*sourceImage.width + x].blue) * weight
                        weightSum += weight
                    }
                    processedImage.pixels[i*sourceImage.width+j].red = UInt8(value.red/weightSum)
//                    processedImage.pixels[i*sourceImage.width+j].green = UInt8(value.green/weightSum)
//                    processedImage.pixels[i*sourceImage.width+j].blue = UInt8(value.blue/weightSum)
                }
            }
        }
        
        return processedImage.toUIImage()!
    }
    
    public func myProcess() -> UIImage {
        struct Channels {
            var red : UInt8 = 0
            var green : UInt8 = 0
            var blue : UInt8 = 0
        }
        var values = Channels()
        for var x in 0..<sourceImage.width {
            for var y in 0..<sourceImage.height {
                values.red = 0
                values.green = 0
                values.blue = 0
                var sum : UInt8 = 0
                for var neighbourX = x-1; neighbourX <= x+1; neighbourX++ {
                    for var neighbourY = y-1; neighbourY <= y+1; neighbourY++ {
                        values.red += sourceImage.pixels[neighbourX + neighbourY*sourceImage.width].red
                        values.green += sourceImage.pixels[neighbourX + neighbourY*sourceImage.width].green
                        values.green += sourceImage.pixels[neighbourX + neighbourY*sourceImage.width].blue
                        sum++
                    }
                }
                processedImage.pixels[x + y*sourceImage.width].red = clamp8(values.red/sum)
                processedImage.pixels[x + y*sourceImage.width].green = clamp8(values.green/sum)
                processedImage.pixels[x + y*sourceImage.width].blue = clamp8(values.blue/sum)
            }
        }
        
        return processedImage.toUIImage()!
    }
    
//
//    public func process() -> RGBAImage {
//        var boxes = boxesForGauss(radius, n: 3)
//        
//        boxBlurHorizontal()
//        boxBlurTotal()
//        
//        return processedImage
//    }
//    
//    private func boxesForGauss(sigma : Int, n : Int) -> [Int] {
//        let wIdeal = sqrt(Double((12 * sigma * sigma / n) + 1))
//        var wl = Int(wIdeal)
//    
//        if wl%2 == 0 {
//            wl--
//        }
//    
//        let wu = wl + 2
//    
//        let mIdeal = (12 * sigma * sigma - n * wl * wl - 4 * n * wl - 3 * n) / (-4 * wl - 4)
//        let m = Int(mIdeal)
//    
//        var sizes : [Int] = []
//        for var i = 0; i < n; i++ {
//            sizes.append(i < m ? wl : wu)
//        }
//    
//        return sizes
//    }
//
//
//    private func boxBlurHorizontal() {
//        let iarr = 1 / (2*radius + 1)
//        for var index = 0; index < sourceImage.height; index++ {
//            var ti = index * sourceImage.width
//            var li = ti
//            var ri = ti + Int(radius)
//            
//            var fv = sourceImage.pixels[ti].red
//            var lv = sourceImage.pixels[ti + sourceImage.width - 1].red
//            var val = UInt8((radius + 1)) * fv
//            
//            for var j = 0; j < radius; j++ {
//                val += sourceImage.pixels[ti + j].red
//            }
//            for var j = 0; j <= radius; j++ {
//                val += sourceImage.pixels[ri++].red - fv
//                processedImage.pixels[ti++].red = UInt8(Int(val) * iarr)
//            }
//            for var j = radius+1; j < sourceImage.width - radius; j++ {
//                val += sourceImage.pixels[ri++].red - sourceImage.pixels[li++].red
//                processedImage.pixels[ti++].red = UInt8(Int(val) * iarr)
//            }
//            for var j = sourceImage.width-radius; j < sourceImage.width; j++ {
//                val += lv - sourceImage.pixels[li++].red
//                processedImage.pixels[ti++].red = UInt8(Int(val) * iarr)
//            }
//        }
//    }
//    
//    func boxBlurTotal() {
//        let iarr = 1 / (2*radius + 1)
//        for var index = 0; index < sourceImage.width; index++ {
//            var ti = index
//            var li = ti
//            var ri = ti + radius*sourceImage.width
//            
//            let fv = sourceImage.pixels[ti].red
//            let lv = sourceImage.pixels[ti+sourceImage.width*(sourceImage.height)-1].red
//            var val = UInt8(radius + 1) * (fv)
//            
//            for var j = 0; j < radius; j++ {
//                val += sourceImage.pixels[ti + j*sourceImage.width].red
//            }
//            for var j = 0; j <= radius; j++ {
//                val += sourceImage.pixels[ri].red - fv
//                processedImage.pixels[ti].red = val * UInt8(iarr)
//                ri += sourceImage.width
//                ti += sourceImage.width
//            }
//            for var j = radius+1; j < sourceImage.height-radius; j++ {
//                val += sourceImage.pixels[ri].red - sourceImage.pixels[li].red
//                processedImage.pixels[ti].red = val * UInt8(iarr)
//                li += sourceImage.width
//                ri += sourceImage.width
//                ti += sourceImage.width
//            }
//            for var j = sourceImage.height - radius; j < sourceImage.height; j++ {
//                val += lv - sourceImage.pixels[li].red
//                processedImage.pixels[ti].red = val * UInt8(iarr)
//                li += sourceImage.width
//                ti += sourceImage.width
//            }
//        }
//    }
    
}


// Instances for default Filter configurations
public let contrast2x = Contrast(intensity: 50)
public let contrast05x = Contrast(intensity: -50)
public let brightness2x = Brightness(intensity: 50)
public let greenify = ColorBalance(intensity: 50, channel: .Green)
public let redify = ColorBalance(intensity: 50, channel: .Red)
public let bluify = ColorBalance(intensity: 50, channel: .Blue)