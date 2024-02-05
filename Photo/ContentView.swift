//
//  ContentView.swift
//  Photo
//
//  Created by Dano on 26.09.23.
//


// todo: ajouter fonction de scan de photo -> pdf

import SwiftUI

func saveImageToFile(image: NSImage, title: String) {
    
    guard let imageData = image.tiffRepresentation,
          let bitmapImageRep = NSBitmapImageRep(data: imageData) else {
        return
    }
    
    let properties: [NSBitmapImageRep.PropertyKey: Any] = [:]
    
    if let pngData = bitmapImageRep.representation(using: .png, properties: properties) {
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["png"]
        savePanel.nameFieldStringValue = title
        
        if savePanel.runModal() == .OK,
           let saveURL = savePanel.url {
            do {
                try pngData.write(to: saveURL)
            } catch {
                print("Error saving image: \(error)")
            }
        }
    }
}

func resizeImage(image: NSImage?, width: CGFloat, height: CGFloat) -> NSImage? {
        guard let image = image else {
            return nil
        }

        let newSize = NSSize(width: width, height: height)
        let newImage = NSImage(size: newSize)

        newImage.lockFocus()
        defer {
            newImage.unlockFocus()
        }

        image.draw(in: NSRect(origin: .zero, size: newSize), from: NSRect(origin: .zero, size: image.size), operation: .sourceOver, fraction: 1.0)

        return newImage
    }

extension NSImage {
    func fromCIImage (_ ciImage: CIImage) -> NSImage {
        
        let rep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        
        return nsImage
    }
}

struct ContentView: View {
    @Binding var img: URL?
    @State var isGeometryPresented = false
    @State private var windowTitle = "Your Default Title"
    
    @State private var widthValue = "100"
    @State private var heightValue = "100"
    
    @State private var NSImageFilter = NSImage()
    
    @Binding var resized_width: Int

    init(
        img: Binding<URL?> = .constant(URL(string: "file:///Users/dano/Pictures/lac et coucher de soleil.jpg")),
        resized_width: Binding<Int> = .constant(0))
    {
        _img = img
        _resized_width = resized_width
    }
    
    @State private var folderURL: URL?
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var delegate = AppDelegate()
    
    @GestureState private var dragOffset = CGSize.zero
    @State var width = CGFloat(0)
    @State var height = CGFloat(0)
    @State private var scale: CGFloat = 1.0
    
    @State var presentAlert = false
    
    @State private var imagePosition = CGSize(width: -50, height: 0)
    @State var isEditMode = false
    
    @State var slidingValue = 0.0
    @State var PanelValue = EditPanelOption()
    
    @State var updateSize = 0
    
    var body: some View {
        HStack {

            
            /* Display image*/
            let imagePath = img!.path
            let pth = String(imagePath).replacingOccurrences(of: "%20", with: "/ ")
            
            if var image = NSImage(contentsOfFile: pth) {
                                
                Image(nsImage: (NSImageFilter.size.width == 0) ? image : NSImageFilter)
                    .resizable()
                    .scaledToFit()
                    .offset((isEditMode) ? withAnimation(.easeInOut) { imagePosition} : CGSize(width: 0, height: 0))
                    .scaleEffect((isEditMode) ? 0.8 : 1.0)
                /*
                    .gesture(
                        
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation
                            }
                            .onChanged { value in
                                    
                                imagePosition = CGSize(width: value.translation.width, height: value.translation.height)
                            }

                    )
                */
                
                .onAppear {
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        
                        let imagePath = img!.path
                        let pth = String(imagePath).replacingOccurrences(of: "%20", with: "/ ")
                        let image = NSImage(contentsOfFile: pth)
                        
                        widthValue = image!.size.width.description
                        heightValue = image!.size.height.description
                        
                        if let image = NSImage(contentsOfFile: pth) {
                            if (image.size.width > 1000){
                                NSApplication.shared.mainWindow?.setContentSize(NSSize(width: 1000, height: image.size.height/(image.size.width/1000)))
                            }
                            else if (image.size.height > 700) {
                                NSApplication.shared.mainWindow?.setContentSize(NSSize(width: 1000, height: image.size.height/(image.size.width/1000)))
                            }
                            else {
                                NSApplication.shared.mainWindow?.setContentSize(NSSize(width: image.size.width, height: image.size.height))
                            }
                        }
                    }}
                
                    
                    
            }
            else {
                Text(img!.absoluteString.dropFirst(7))
                Text("Image not found")
            }
            // Image(nsImage: NSImageFilter)
            
            /* end image displaying */
            
            Spacer()
            
            if isEditMode {
                
                EditPanelView(sliderValue: $slidingValue, OptionValue: $PanelValue, imageFilter: $NSImageFilter, imageName: $img)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Change the delay time as needed
                                    updateWindowTitle()
            }
        }
        .toolbar {
            ToolbarItem (placement: .confirmationAction) {
                Button(action: {
                    isGeometryPresented = true
                }) {
                    Image(systemName: "viewfinder")
                }
                .sheet(isPresented: $isGeometryPresented, content: {
                    GeometrySheet(isGeometryPresented: $isGeometryPresented, Width: $widthValue, Height: $heightValue)
                })
            }
            
            ToolbarItem (placement: .confirmationAction) {
                Button(action: {
                    isEditMode.toggle()
                }, label: {Image(systemName: "slider.horizontal.3")})
                
            }
            
            
            
            ToolbarItem (placement: .confirmationAction) {
                Button("save") {
                    if let imagePath = img?.path {
                        var image = NSImage()
                        if (NSImageFilter.size.width == 0) {
                            image = NSImage(contentsOfFile: imagePath)!
                        }
                        else {
                            image = NSImageFilter
                        }
                        
                        let wdt = CGFloat(Double(widthValue)!)/2
                        let hgt = CGFloat(Double(heightValue)!)/2
                        let resizedImage = resizeImage(image: image, width: wdt, height: hgt)
                        saveImageToFile(image: resizedImage!, title: windowTitle)
                        print(widthValue)
                        exit(0)
                    }
                }
            }
        }
        
        
    }
    private func updateWindowTitle() {
            if let img = img {
                windowTitle = "\(img.lastPathComponent)"
            } else {
                windowTitle = "Photo"
            }
            NSApplication.shared.mainWindow?.title = windowTitle
        }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationDidUpdate(_ notification: Notification) {
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// .sheet
