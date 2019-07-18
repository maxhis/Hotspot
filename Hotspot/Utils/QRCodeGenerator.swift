//
//  QRCodeGenerator.swift
//  Hotspot
//
//  Created by 马爱星 on 2019/7/16.
//  Copyright © 2019 oio.dev. All rights reserved.
//

import UIKit

class QRCodeGenerator {
    /// white foreground and transparent background
    static func generateTransparentQRCode(content: String) -> UIImage? {
        // Get data from the string
        let data = content.data(using: String.Encoding.utf8)
        
        // Get a QR CIFilter
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        // Input the data
        qrFilter.setValue(data, forKey: "inputMessage")
        
        // Get the output image
        guard let qrImage = qrFilter.outputImage else { return nil}
        
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        // Invert the colors
        guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return nil}
        colorInvertFilter.setValue(scaledQrImage, forKey: "inputImage")
        guard let outputInvertedImage = colorInvertFilter.outputImage else { return nil}
        
        // Replace the black with transparency
        guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return nil}
        maskToAlphaFilter.setValue(outputInvertedImage, forKey: "inputImage")
        guard let outputCIImage = maskToAlphaFilter.outputImage else { return nil}
        
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil}
        let processedImage = UIImage(cgImage: cgImage)
        
        return processedImage
    }
    
    /// black foreground and white background
    static func generateOpaqueQRCode(content: String) -> UIImage? {
        // Get data from the string
        let data = content.data(using: String.Encoding.utf8)
        
        // Get a QR CIFilter
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil}
        
        // Input the data
        qrFilter.setValue(data, forKey: "inputMessage")
        
        // Get the output image
        guard let qrImage = qrFilter.outputImage else { return nil}
        
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return nil}
        let processedImage = UIImage(cgImage: cgImage)
        return processedImage
    }

}
