//
//  ResponseModel.swift
//  lab1
//
//  Created by witold on 23.11.2025.
//

struct AQResponse: Codable {
    let status: String
    let data: AQCoreData?
}

struct AQCoreData: Codable {
    let aqi: Int?
    let iaqi: IAQI?
}

struct IAQI: Codable {
    let pm25: AQValue?
    let o3: AQValue?
}

struct AQValue: Codable {
    let v: Double?
}
