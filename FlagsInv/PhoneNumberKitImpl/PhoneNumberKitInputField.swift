//
//  PhoneNumberKitInputField.swift
//  FlagsInv
//
//  Created by Vasyl Nadtochii on 06.07.2022.
//

import SwiftUI
import UIKit
import PhoneNumberKit

struct PhoneNumberKitInputField: UIViewRepresentable {

    @Binding var phoneNumber: String
    private let textField = PhoneNumberTextField()

    func makeUIView(context: Context) -> PhoneNumberTextField {
        textField.withExamplePlaceholder = true
        textField.withPrefix = true
        // textField.becomeFirstResponder()
        // textField.addTarget(context.coordinator, action: #selector(Coordinator.onTextUpdate), for: .editingChanged)
        textField.maxDigits = 10
        return textField
    }

    func updateUIView(_ view: PhoneNumberTextField, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {

        var control: PhoneNumberKitInputField

        init(_ control: PhoneNumberKitInputField) {
            self.control = control
        }

        @objc func onTextUpdate(textField: UITextField) {
            self.control.phoneNumber = textField.text!
        }

    }
}
