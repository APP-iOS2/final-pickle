//
//  Mission.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/26.
//

import Foundation

protocol Mission: MappableProtocol {
    var id: String { get }
    var title: String { get }
    var status: MissionStatus { get }
    var date: Date { get }
}
