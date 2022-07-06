//
//  PhoneNumberInputView.swift
//  FlagsInv
//
//  Created by Vasyl Nadtochii on 05.07.2022.
//

import SwiftUI
import FlagKit

struct UserRegion: Hashable {
    var regionCode: String
    let localized: String
    let phoneMask: String
}

struct PhoneInputView: View {

    @FocusState var focusedField: FocusedField?

    @Binding var text: String
    @Binding var textFieldState: InputState
    @Binding var region: UserRegion

    let placeholder: LocalizedStringKey
    let keyboardType: UIKeyboardType
    let capitalized: Bool
    let suggestedRegions: [UserRegion]

    init(
        text: Binding<String>,
        textFieldState: Binding<InputState>,
        placeholder: LocalizedStringKey,
        keyboardType: UIKeyboardType = .default,
        capitalized: Bool = true,
        region: Binding<UserRegion>,
        suggestedRegions: [UserRegion]
    ) {
        self._text = text
        self._textFieldState = textFieldState
        self._region = region
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.capitalized = capitalized
        self.suggestedRegions = suggestedRegions
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(placeholder)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(textFieldState.placeholderColor)
                HStack {
                    regionSelector
                    textField
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 65)
            .border(
                textFieldState.borderColor,
                width: 1,
                cornerRadius: 8
            )
            .background(Color.white.cornerRadius(8))
            .onTapGesture {
                self.focusedField = .textField
                textFieldState = .filled
            }
            if case .error = textFieldState {
                errorLabel
            }
        }
    }

    var textField: some View {
        TextField(String(), text: $text, onEditingChanged: { isChanged in
            self.textFieldState = isChanged ? .filled : .opaque
        })
        .submitLabel(.done)
        .foregroundColor(.black)
        .accentColor(.green)
        .keyboardType(keyboardType)
    }

    var regionSelector: some View {
        Menu {
            Picker(String(), selection: $region) {
                ForEach(suggestedRegions, id: \.self) { region in
                    Text("\(region.localized) \(flag(country: region.regionCode))")
                        .tag(region as UserRegion?)
                }
            }
        } label: {
            HStack {
                Group {
                    if let flag = Flag(countryCode: region.regionCode) {
                        Image(uiImage: flag.originalImage)
                            .resizable()
                    } else {
                        Image(systemName: "questionmark.square.fill")
                            .resizable()
                    }
                }
                .scaledToFit()
                .frame(height: 12)

                Image(systemName: "chevron.down")
                    .font(.caption)
            }
            .accentColor(.primary)
        }
    }

    var errorLabel: some View {
        HStack {
            Text(textFieldState.errorDescription)
                .kerning(-0.41)
                .foregroundColor(.red)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 0))
            Spacer()
        }
    }
}

private extension PhoneInputView {

    func flag(country: String) -> String {
        let base : UInt32 = 127397
        var flag = String()
        for v in country.unicodeScalars {
            if let unicodeScalar = UnicodeScalar(base + v.value) {
                flag.unicodeScalars.append(unicodeScalar)
            }
        }
        return flag
    }
}

extension PhoneInputView {
    enum FocusedField {
        case textField
    }

    enum ErrorLabel {
        case invalidFormat
        case requiredField
    }

    enum InputState: Equatable {
        case opaque
        case filled
        case error(_ description: ErrorLabel = .invalidFormat)

        var borderColor: Color {
            switch self {
            case .opaque:
                return Color.black.opacity(0.2)
            case .filled:
                return Color.black
            case .error:
                return Color.red
            }
        }

        var placeholderColor: Color {
            switch self {
            case .opaque:
                return Color.black.opacity(0.5)
            case .filled:
                return Color.black.opacity(0.6)
            case .error:
                return Color.black.opacity(0.6)
            }
        }

        var errorDescription: String {
            switch self {
            case .error(let label):
                switch label {
                case .invalidFormat:
                    return "text_input_view_invalid_format"
                case .requiredField:
                    return "text_input_view_required_field"
                }
            default:
                return String()
            }
        }
    }
}
