//
//  Extensions.swift
//  Converter
//
//  Created by Наташа Яковчук on 12.12.2023.
//

import Foundation
import SwiftUI


extension View {
    
    func valueView() -> some View {
        self
            .frame(width: 150, height: 40, alignment: .leading)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 27)
                .stroke(lineWidth: 1)
                .frame(width: 180, height: 50)
                .foregroundColor(.black.opacity(0.5))
                .shadow(radius: 2))
    }
    
    func currencyView() -> some View {
        self
            .foregroundColor(.mint)
            .padding()
            .background(Circle()
                .foregroundColor(.white)
            .shadow(radius: 3))
    }
    
    
}
