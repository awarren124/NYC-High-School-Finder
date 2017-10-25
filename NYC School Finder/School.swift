//
//  School.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 8/27/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import Foundation

struct School {
    static var session = URLSession()
    var values = [String: Any?]()
    static var keyMap: [String:String] = [:]
    static let keys = [
        //general
        "school_name",
        "dbn",
        "website",
        "interest1",
        "overview_paragraph",
        "finalgrades",
        "total_students",
        "start_time",
        "end_time",
        "attendance_rate",
        "graduation_rate",
        "geoeligibility",
        "addtl_info1",
        
        //courses
        "academicopportunities1",
        "ell_programs",
        "language_classes",
        "psal_sports_boys",
        "extracurricular_activities",
        
        //location
        "city",
        "primary_address_line_1",
        "zip",
        "neighborhood",
        
        //transit
        "subway",
        "bus",
        
        //contact
        "school_email",
        "phone_number",
        "fax_number",
        
        //filters
        "ASC",
        "DESC",
        
        //other sports (not displayed in main tableview)
        "psal_sports_girls",
        "psal_sports_coed",
        "school_sports"
        
    ]
    
    static let readableTerms = [
        "School Name",
        "School Code",
        "Website",
        "Interests",
        "Overview",
        "Grades",
        "Total Students",
        "Start Time",
        "End Time",
        "Attendance Rate",
        "Graduation Rate",
        "Geoeligibility",
        "Additional Info",
        "Academic Opportunities",
        "ELL Programs",
        "Language Classes",
        "Sports",
        "Extracurriculars",
        "Borough",
        "Address",
        "Zip Code",
        "Neighborhood",
        "Subway",
        "Bus",
        "School Email",
        "Phone Number",
        "Fax Number",
        "Ascending",
        "Descending"
    ]
}

extension School {
    init?(json: [String: Any]) {
        
        var programs = [Program]()
        for key in School.keys {
            if let val = json[key] {
                
                values[key] = val
                if key == "attendance_rate" || key == "graduation_rate" {
                    values[key] = School.formatPercent(value: val)
                }
            }else{
                values[key] = "N/A"
            }
        }
        for key in json.keys {
            if Program.programKeys.contains(String(key.dropLast())){
                let prgKey = String(key.dropLast())
                let num = Int(String(key.last!))!
                if programs.count < num {
                    var program = Program()
                    program.values[prgKey] = (json[key] as! String)
                    programs.append(program)
                }else{
                    programs[num - 1].values[prgKey] = (json[key] as! String)
                }
            }
        }
        values["programs"] = programs
        
    }
    
    static func formatPercent(value: Any?) -> String {
        if let val = value as? String {
            if let double = Double(val){
                return  "\(Int(double * 100))%"
            }else{
                return val
                
            }
            
        }
        return "N/A"
    }
    
    static func schools(withMatching query: String, filterOptions: [String], completion: @escaping ([School], Bool, Int) -> Void) {
        print("withNameMatching starting")
        let formattedQuery = query.replacingOccurrences(of: " ", with: "%")
        //let urlRoot = "https://data.cityofnewyork.us/resource/4isn-xf7m.json"
        let urlRoot = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
        let urlPath = "?$where=lower(\(filterOptions[0]))%20like%20lower(%27%25\(formattedQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)%25%27)&$order=\(filterOptions[1])%20\(filterOptions[2])"
        let url = urlRoot + urlPath
        //print(url)
        let urlComponents: URLComponents = URLComponents(string: url)!;
        var schools: [School] = []
        print(urlComponents.url!)
        json(fromURL: urlComponents, completion: { (json, error, statusCode) in
            if(!error){
                for result in json {
                    if let school = School(json: result) {
                        schools.append(school)
                    }else{
                        
                    }
                }
            }
            print("withNameMatching completion")
            completion(schools, error, statusCode)
        })
        
    }
    
    /*static func retrieveSchoolWithCount(limit: Int, offset: Int, completion: @escaping ([School], Bool, Int) -> Void){
     print("retrieveSchoolWithCount starting")
     //let urlComponents: URLComponents = URLComponents(string: "https://data.cityofnewyork.us/resource/9pyc-nsiu.json?$limit=\(limit)&$offset=\(offset)")!;
     //let urlComponents: URLComponents = URLComponents(string: "https://data.cityofnewyork.us/resource/4isn-xf7m.json?$limit=\(limit)&$offset=\(offset)")!;
     
     let urlComponents: URLComponents = URLComponents(string: "https://data.cityofnewyork.us/resource/97mf-9njv.json?$limit=\(limit)&$offset=\(offset)")!;
     
     var schools = [School]()
     json(fromURL: urlComponents, completion: { (json, error, statusCode) in
     if(!error){
     for result in json {
     if let school = School(json: result) {
     schools.append(school)
     }
     }
     }
     print("retrieveSchoolWithCount completion")
     completion(schools, error, statusCode)
     })
     }*/
    
    static func retrieveSchoolFromCode(code: String, completion: @escaping (School?, Bool) -> Void){
        let url = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
        let query = "?dbn=\(code.uppercased())"
        let urlComponents = URLComponents(string: (url + query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
        print(urlComponents)
        var school: School?
        json(fromURL: urlComponents!, completion: { (json, error, statusCode) in
            if(!error){
                for result in json {
                    if let s = School(json: result) {
                        school = s
                    }
                }
            }
            print("retrieveSchoolWithCount completion")
            completion(school, error)
        })
    }
    
    static func json(fromURL urlComponents: URLComponents, completion: @escaping ([[String: Any]], Bool, Int) -> Void) {
        print("json method starting")
        var request = URLRequest(url: urlComponents.url!)
        session  = URLSession(configuration: .default) // shared session for interacting with the web service
        
        var json = [[String: Any]]()
        request.setValue(AuthInfo.API_KEY, forHTTPHeaderField: "X-App-Token")
        session.dataTask(with: request, completionHandler: { (data,response, error) -> Void in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                let errorBool = !(statusCode/100 == 2)
                print("code: \(statusCode)")
                if !errorBool {
                    if let data = data,
                        let temp = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        json = temp!
                    }
                    
                }
                print("json method completion")
                completion(json, errorBool, statusCode)
            }else{
                if (error! as NSError).code == NSURLErrorCancelled {
                    completion([[:]], true, 888)
                }else{
                    completion([[:]], true, 999)
                }
            }
        }).resume()
    }
    
    
    static func initializeMapDictionary(){
        School.keyMap = Dictionary(keys: readableTerms, values: keys)
        
    }
    
}
