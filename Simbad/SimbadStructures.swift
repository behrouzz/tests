//
//  SimbadStructures.swift
//  Simbad
//
//  Created by Behrouz Safari on 02/10/2023.
//

import Foundation


let BASE_SIMBAD = "https://simbad.u-strasbg.fr/simbad/sim-tap/sync?request=doQuery&lang=adql&format=json&query="


struct MetaObject: Codable {
    let name: String
    let description: String?
    let datatype: String
    let arraysize: String?
    let unit: String?
    let ucd: String
}

enum Datum: Codable {
    case double(Double)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Datum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Datum"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}


struct Response: Codable {
    var metadata: [MetaObject]
    var data: [[Datum]]
}

func createUrlSrting(sql: String) -> String {
    let rawUrl = BASE_SIMBAD + sql.replacingOccurrences(of: "  ", with: " ").replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: " ", with: "%20")
    //let url = URL(string: rawUrl)!
    return rawUrl
}

func createURL(sql: String) -> URL {
    let rawUrl = createUrlSrting(sql: sql)
    let url = URL(string: rawUrl)!
    return url
}

func download(sql: String) -> String {
    let url = createURL(sql: sql)
    do {
        let raw_contents = try String(contentsOf: url)
        let contents = raw_contents.replacingOccurrences(of: "null", with: "67000.1982")
        return contents
    } catch {
        return "Connect error!"
    }
}

//let contents = download(sql: sql)

func decodeResults(contents: String) -> ([String], [[String: String]]) {
    var columns = [String]()
    var dc = [String: String]()
    var simbadData = [[String: String]]()
    
    let json = contents.data(using: .utf8)
    let res = try? JSONDecoder().decode(Response.self, from: json!)
    
    for i in res!.metadata {
        columns.append(i.name)
    }
    
    for row in res!.data {
        for i in 0..<row.count {
            switch row[i] {
            case .string(let str): dc[columns[i]] = str
            case .double(let dbl) where dbl != 67000.1982: dc[columns[i]] = String(dbl)
            default: dc[columns[i]] = "N/A"
            }
        }
        simbadData.append(dc)
        dc = [:]
    }
    
    return (columns, simbadData)
}
