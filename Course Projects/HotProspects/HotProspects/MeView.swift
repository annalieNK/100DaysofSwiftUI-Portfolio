//
//  MeView.swift
//  HotProspects
//
//  Created by Annalie Kruseman on 1/17/23.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    @State private var name = "Anonymous"
    @State private var emailAddress = "you@yoursite.com"
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    // filter is of tye data and needs to be converted to a CG Image later on
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                
                TextField("Email address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
                
                // generate QR Code
                Image(uiImage: qrCode)
                    .resizable()
                // do not smoothing algorithm for this QR code to sharpen the pixels
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .contextMenu {
                        Button {
                            // save the image
                            // let image = generateQRCode(from: "\(name)\n\(emailAddress)")
                            // let imageSaver = ImageSaver()
                            // imageSaver.writeToPhotoAlbum(image: image)
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: qrCode)
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                        }
                    }
            }
            .navigationTitle("Your code")
            .onAppear(perform: updateCode)
            .onChange(of: name) { _ in updateCode() }
            .onChange(of: emailAddress) { _ in updateCode() }
        }
    }
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
    
    // working with Core Image filters requires us to provide some input data, then convert the output CIImage into a CGImage, then that CGImage into a UIImage
    func generateQRCode(from string: String) -> UIImage {
        // convert string to Data
        filter.message = Data(string.utf8)
        
        // convert output CIimage into a CGImage
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                // convert CVImage into a UIImage and store in our declared cache before returning
                qrCode = UIImage(cgImage: cgimg)
                return qrCode
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
