//
//  CameraView.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 06/12/2023.
//

import SwiftUI

struct CameraView: View {
    
    @State private var expenseViewModel = ExpenseViewModel()
    
    var body: some View {
        VStack() {
            CameraButtonView {
                
            }
            .padding(.top, 20)
            Spacer()
        }
        .sheet(isPresented: $expenseViewModel.showPicker) {
            
        }
    }
}

#Preview {
    CameraView()
}
