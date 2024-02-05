//
//  GeometrySheet.swift
//  Photo
//
//  Created by Dano on 02.10.23.
//

import SwiftUI


struct GeometrySheet: View {
    @Binding var Width:String
    @Binding var Height:String
    @Binding var isGeometryPresented: Bool
    @State var linked = false
    @State var i = 0
    @State var coefWidth = 0.0 as Float
    @State var coefHeight = 0.0 as Float
    
    
    init(
         isGeometryPresented: Binding<Bool> = .constant(true),
         Width: Binding<String> = .constant("0"),
         Height: Binding<String> = .constant("0"))
    {
        _isGeometryPresented = isGeometryPresented
        _Width = Width
        _Height = Height
    }
    
    
    var body: some View {
        VStack  {
            HStack {
                Text("Dimension: ").font(.caption2)
                Spacer()
            }
            .onAppear {
                
                
                coefWidth = Float(Width)!/Float(Height)!
                coefHeight = Float(Height)!/Float(Width)!
                
            }
            
            ZStack {
                Rectangle()
                    .foregroundColor(Color("nuanced"))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                HStack (spacing: 25) {
                    
                    VStack {
                        Text("Largeur: ")
                        TextField("500", text: $Width)
                    }
                    Button(action: {
                        linked.toggle()
                    }, label: {
                        Image(systemName: "link")
                            .foregroundColor((linked) ? .blue : .white)
                    })
                    .buttonStyle(PlainButtonStyle())
                    VStack {
                        Text("Hauteur: ")
                        TextField("500", text: $Height)
                    }
                }
                .padding(10)
            }
            
            HStack {
                Spacer()
                Button("Annuler") {
                    isGeometryPresented = false
                }
                Button("Ok") {
                    isGeometryPresented = false
                }
            }
        }
        .padding(15)
        .onChange(of: Width) { w in
            if linked {
                Height = String(Float(Width)!*Float(coefHeight))
            }
        }
        /*
        .onChange(of: Height) { h in
            if linked {
                Width = String(Int(Height)!*coefHeight)
            }
        }*/
    }
}
