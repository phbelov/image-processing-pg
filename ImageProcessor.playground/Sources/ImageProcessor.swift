import Foundation
import UIKit

// Image Processor class which can process an Image with infinite amount of filters :)
public class ImageProcessor {
    
    var image : RGBAImage?
    
    public init () {
        
    }
    public init (image : RGBAImage) {
        self.image = image
    }
    
    public func process(filters : Filter...) -> UIImage {
        for filter in filters {
            self.image!.applyFilter(filter)
        }
        return self.image!.toUIImage()!
    }
    public func process(image: RGBAImage, filters : Filter...) -> UIImage {
        self.image = image
        for filter in filters {
            self.image!.applyFilter(filter)
        }
        return self.image!.toUIImage()!
    }
}