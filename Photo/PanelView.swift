//
//  PanelView.swift
//  Photo
//
//  Created by Dano on 02.10.23.
//

import SwiftUI


struct EditPanelOption {
    var Coloration: Double
    var Saturation: Double
    var Contraste: Double
    var Luminosite: Double
    var autofilter: Double
    
    init(Coloration: Double = 0.0, Saturation: Double = 0.0, Contraste: Double = 0.0, Luminosite: Double = 0.0, autofilter: Double = 0.0) {
        self.Coloration = Coloration
        self.Saturation = Saturation
        self.Contraste = Contraste
        self.Luminosite = Luminosite
        self.autofilter = autofilter
    }
}

func EPO (a: Double, b: Double, c: Double, d: Double, e: Double) -> EditPanelOption{
    return EditPanelOption(Coloration: a, Saturation: b, Contraste: c, Luminosite: d, autofilter: e)
}


struct EditPanelView: View {
    @Binding var sliderValue: Double
    @Binding var OptionValue: EditPanelOption
    @Binding var imageFilter: NSImage
    @Binding var imageName: URL?
    
    @State var autoFilterName = ""
    @State var filterNames = [
            "CIBoxBlur", "CIDiscBlur", "CIGaussianBlur", "CIMaskedVariableBlur",
            "CIMedianFilter", "CIMotionBlur", "CINoiseReduction", "CIZoomBlur"
        ]
    @State private var selectedFilter = "CIBoxBlur"
    
    init(sliderValue: Binding<Double> = .constant(0.0),
         OptionValue: Binding<EditPanelOption> = .constant(EPO(a: 0.0, b: 0.0, c: 0.0, d: 0.0, e: 0.0)),
         imageFilter: Binding<NSImage> = .constant(NSImage()),
         imageName: Binding<URL?> = .constant(URL(string: "")!)
    )
    {
        
        _sliderValue = sliderValue
        _OptionValue = OptionValue
        _imageFilter = imageFilter
        _imageName = imageName
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            VStack (alignment: .leading, spacing: 0) {
                Text("Coloration :")
                    .foregroundColor(.white)
                    .padding(.leading, 15)
                    
                HStack {
                    Slider(value: $OptionValue.Coloration, in: 0.0...100.0)
                        .padding(.leading, 15)
                        .accentColor(Color.blue) // Change the slider's thumb color
                        .frame(width: 130)
                        .onChange(of: OptionValue.Coloration) { val in
                            
                            let img_out = filterLuminosity(intensity: Float(OptionValue.Coloration)/100, name: imageName!)
                            let rep = NSCIImageRep(ciImage: img_out)
                            let nsImage = NSImage(size: rep.size)
                            nsImage.addRepresentation(rep)
                            
                            imageFilter = nsImage
                            
                            // saveImageToFile(image: nsImage, title: "myfile.png")
                        }
                    
                    Text(String(round(OptionValue.Coloration)))
                        .foregroundColor(.white)
                }
                
                Spacer().frame(height: 15)
            }
            
            Text("Saturation :")
                .foregroundColor(.white)
                .padding(.leading, 15)
                
            HStack {
                Slider(value: $OptionValue.Saturation, in: 0.0...100.0)
                    .padding(.leading, 15)
                    .accentColor(Color.blue) // Change the slider's thumb color
                    .frame(width: 130)
                    .onChange(of: OptionValue.Saturation) { val in
                        let img_out = filterColoration(intensity: Float(OptionValue.Saturation)/100, name: imageName!)
                        let rep = NSCIImageRep(ciImage: img_out)
                        let nsImage = NSImage(size: rep.size)
                        nsImage.addRepresentation(rep)
                        
                        imageFilter = nsImage
                        
                        // saveImageToFile(image: nsImage, title: "myfile.png")
                    }
                Text(String(round(OptionValue.Saturation)))
                    .foregroundColor(.white)
            }
            
            Spacer().frame(height: 15)
            
            Text("Contraste :")
                .foregroundColor(.white)
                .padding(.leading, 15)
                
            HStack {
                Slider(value: $OptionValue.Contraste, in: 0.0...100.0)
                    .padding(.leading, 15)
                    .accentColor(Color.blue) // Change the slider's thumb color
                    .frame(width: 130)
                    .onChange(of: OptionValue.Contraste) { val in
                        let img_out = filter(intensity: Float(OptionValue.Contraste)/100, name: imageName!)
                        let rep = NSCIImageRep(ciImage: img_out)
                        let nsImage = NSImage(size: rep.size)
                        nsImage.addRepresentation(rep)
                        
                        imageFilter = nsImage
                        
                        // saveImageToFile(image: nsImage, title: "myfile.png")
                    }
                Text(String(round(OptionValue.Contraste)))
                    .foregroundColor(.white)
                    
            }
            
            
            Spacer().frame(height: 15)
            
            Text("Luminosité :")
                .foregroundColor(.white)
                .padding(.leading, 15)
                
            HStack {
                Slider(value: $OptionValue.Luminosite, in: 0.0...100.0)
                    .padding(.leading, 15)
                    .accentColor(Color.blue) // Change the slider's thumb color
                    .frame(width: 130)
                Text(String(round(OptionValue.Luminosite)))
                    .foregroundColor(.white)
            }
            Picker("Auto Filter", selection: $selectedFilter) {
                            ForEach(filterNames, id: \.self) { filterName in
                                Text(filterName)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
            Slider(value: $OptionValue.autofilter, in: 0.0...100.0)
                .padding(.leading, 15)
                .accentColor(Color.blue) // Change the slider's thumb color
                .frame(width: 130)
            HStack {
                Spacer()
                Button("Apply Filter") {
                    
                        print(selectedFilter)
                        
                        // Replace [name of the filter] with the selected filter
                    let img_out = autoFilter(intensity: Float(OptionValue.autofilter), name: imageName!, filter: selectedFilter)
                        let rep = NSCIImageRep(ciImage: img_out)
                        let nsImage = NSImage(size: rep.size)
                        nsImage.addRepresentation(rep)
                        
                        imageFilter = nsImage
                    
                }.padding(.trailing, 15)
            }
            
            Button(action: {
                
            }, label: {
               
                Text("Camera Raw")
                    .padding(10)
            })
            .buttonStyle(CustomButtonStyle())
            .padding(.leading, 80)
            .padding(.top, 10)
            
        }
        .frame(width: 200, alignment: .topLeading)
        .frame(maxHeight: .infinity)
        .background(.blue)
    }
}
