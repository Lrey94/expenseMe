//
//  CameraButtonView.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 14/12/2023.
//

import SwiftUI

struct CameraButtonView: View {
    
    var clicked: (() -> Void)
    
    var body: some View {
        VStack {
            Button {
                clicked()
            } label: {
                Image(systemName: "camera.fill")
                    .resizable()
                    .frame(width: 40, height: 32)
                    .foregroundStyle(.black)
                    .shadow(radius: 2)
            }
            Text("Take Picture")
                .fontWeight(.bold)
                .shadow(radius: 1)
        }
    }
}

#Preview {
    CameraButtonView() {
        
    }
}
