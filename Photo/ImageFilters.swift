//
//  ImageFilters.swift
//  Photo
//
//  Created by Dano on 20.12.2023.
//

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI


func filterLuminosity(intensity: Float, name: URL) -> CIImage{
    let ciimage = CIImage(contentsOf: name)
    let filter = CIFilter(name: "CISepiaTone")
    
    filter?.setValue(ciimage, forKey: kCIInputImageKey)
    filter?.setValue(intensity, forKey: kCIInputIntensityKey)
    
    return (filter?.outputImage)!
}

func filterColoration(intensity: Float, name: URL) -> CIImage {
    let ciimage = CIImage(contentsOf: name)
    let filter = CIFilter.gaussianBlur()
    filter.inputImage = ciimage
    filter.radius = intensity*25
    
    let output = filter.outputImage
    
    return (output)!
}

func filter(intensity: Float, name: URL) -> CIImage {
    let Ciimage = CIImage(contentsOf: name)
    let filter = CIFilter.sharpenLuminance()
    filter.inputImage = Ciimage
    filter.sharpness = intensity*25
    filter.radius = intensity*25
    
    let output = filter.outputImage
    return output!
}
