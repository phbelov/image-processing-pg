import Foundation

// Extension of RGBAImage class in order to make RGBA image instances apply filters by itself
extension RGBAImage {
    
    public func applyFilter(filter : Filter) -> RGBAImage {
        for y in 0..<self.height {
            for x in 0..<self.width {
                let index = y * self.width + x
                self.pixels[index] = filter.processPixel(self.pixels[index])
            }
        }
    
        return self
    }
    
}