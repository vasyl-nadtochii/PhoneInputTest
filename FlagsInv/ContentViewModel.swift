//
//  ContentViewModel.swift
//  FlagsInv
//
//  Created by Vasyl Nadtochii on 04.07.2022.
//

import Foundation

class ContentViewModel: ObservableObject {

    @Published var phoneNumber: String = String()
    @Published var phoneNumber2: String = String()
    @Published var region: UserRegion {
        didSet {
            phoneNumber = region.phoneMask
        }
    }
    @Published var region2: UserRegion {
        didSet {
            phoneNumber2 = region2.phoneMask
        }
    }
    @Published var inputState = PhoneInputView.InputState.opaque
    @Published var inputState2 = PNKInputImpl.InputState.opaque

    var suggestedRegions = [UserRegion]()

    init() {
        do {
            if let file = Bundle.main.url(forResource: "PhoneMasks", withExtension: "json") {
                let json = try JSONSerialization
                    .jsonObject(with: Data(contentsOf: file), options: [])
                if let dict = json as? [String: String] {
                    for code in Array(dict.keys) {
                        suggestedRegions.append(
                            .init(
                                regionCode: code,
                                localized: Locale.current.localizedString(forRegionCode: code) ?? code,
                                phoneMask: dict[code] ?? String()
                            )
                        )
                    }
                    suggestedRegions.sort(by: { $0.localized > $1.localized })
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }

        region = suggestedRegions.first {
            $0.regionCode == Locale.current.regionCode?.uppercased()
        } ?? .init(regionCode: "Undefined", localized: "Undefined", phoneMask: String())

        region2 = suggestedRegions.first {
            $0.regionCode == Locale.current.regionCode?.uppercased()
        } ?? .init(regionCode: "Undefined", localized: "Undefined", phoneMask: String())

        phoneNumber = region.phoneMask
    }
}

// NSLocale.isoCountryCodes -- !!! country codes
