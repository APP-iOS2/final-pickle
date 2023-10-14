//
//  Font.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

extension Font {
    static let pizzaTitle = Font.system(size: 28, weight: .regular)
    static let pizzaTitleBold = chab //Font.system(size: 28, weight: .bold)
    static let pizzaTitle2 = Font.system(size: 22, weight: .regular)
    static let pizzaTitle2Bold = Font.system(size: 22, weight: .bold)
    static let pizzaHeadline = nanumEb //Font.system(size: 17, weight: .semibold)
    static let pizzaHeadlineBold = Font.system(size: 17, weight: .bold)
    static let pizzaBody = nanumBd //Font.system(size: 17, weight: .regular)
    static let pizzaFootnote = Font.system(size: 13, weight: .regular)
    static let pizzaFootnoteBold = Font.system(size: 13, weight: .bold)
    static let pizzaCaption = Font.system(size: 11, weight: .regular)

    static let chab = Font.custom("LOTTERIACHAB", size: 28)
    static let nanumBd = Font.custom("NanumSquareNeo-cBd", size: 17, relativeTo: .body)
    static let nanumEb = Font.custom("NanumSquareNeo-dEb", size: 17, relativeTo: .title3)
    static let nanumHv = Font.custom("NanumSquareNeo-eHv", size: 17, relativeTo: .title3)
    static let nanumLt = Font.custom("NanumSquareNeo-aLt", size: 17, relativeTo: .title3)
    static let nanumRg = Font.custom("NanumSquareNeo-bRg", size: 17, relativeTo: .title3)
}
