//
//  ContentView.swift
//  FlagsInv
//
//  Created by Vasyl Nadtochii on 04.07.2022.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            Spacer()

            Text("Native (almost) impl:")
                .fontWeight(.bold)
                .foregroundColor(.white)
            PhoneInputView(
                text: $viewModel.phoneNumber,
                textFieldState: $viewModel.inputState,
                placeholder: "Phone number",
                keyboardType: .phonePad,
                region: $viewModel.region,
                suggestedRegions: viewModel.suggestedRegions
            )
            .padding()

            Spacer()

            Text("PhoneNumberKit impl:")
                .fontWeight(.bold)
                .foregroundColor(.white)
            PNKInputImpl(
                text: $viewModel.phoneNumber2,
                textFieldState: $viewModel.inputState2,
                placeholder: "Phone number",
                keyboardType: .phonePad,
                region: $viewModel.region2,
                suggestedRegions: viewModel.suggestedRegions
            )
            .padding()

            Spacer()
        }
        .background(Color.cyan.opacity(0.7))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func border(
        _ color: Color,
        width: CGFloat,
        cornerRadius: CGFloat,
        insets: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    ) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width)
                .tag("border")
                .padding(insets)
        )
    }
}
