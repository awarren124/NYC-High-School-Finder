//
//  School.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 8/27/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import Foundation

struct School {
    
    var values = [String: Any?]()
    static var keyMap: [String:String] = [:]
    static let keys = [
        //general
        "school_name",//("School Name", "school_name"),
        "dbn",//("School Code", "dbn"),
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
        "boro",
        "location",
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
    /*
    let name: String
    let schoolCode: String
    let managedByName: String
    let grades: String
    //let openedYear: String
    let borough: String
    let address: String
    let zipCode: String
    let principalName: String
    //let superintendent: String
    let latitude: String
    let longitude: String*/
}

extension School {
    init?(json: [String: Any]) {
        
        
        for key in School.keys {
            if let val = json[key] {
                //print("here6 \(key)")
                values[key] = val
            }else{
                //print("here5")
                values[key] = "N/A"
            }
        }
        
        
        /*guard let name = json["location_name"] as? String,
            let schoolCode = json["ats_system_code"] as? String,
            let managedByName = json["managed_by_name"] as? String,
            let grades = json["location_type_description"] as? String,
            //let openedYear = json["open_date"] as! String,
            let borough = json["city"] as? String,
            let address = json["primary_address"] as? String,
            let zipCode = json["zip"] as? String,
            let principalName = json["principal_name"] as? String,
            let latitude = json["latitude"] as? String,
            let longitude = json["longitude"] as? String
            //let superintendent = json["superintendent"] as! String
        else{
            //print("here4")
            return nil
        }
        self.name = name
        self.schoolCode = schoolCode
        self.managedByName = managedByName
        self.grades = grades
        //self.openedYear = openedYear.substring(to: openedYear.index(openedYear.startIndex, offsetBy: 4))
        self.borough = borough
        self.address = address
        self.zipCode = zipCode
        self.principalName = principalName
        self.latitude = latitude
        self.longitude = longitude
        //self.superintendent = superintendent*/
    }



    static func schools(withMatching query: String, filterOptions: [String], completion: @escaping ([School], Bool, Int) -> Void) {
        print("withNameMatching starting")
        let formattedQuery = query.replacingOccurrences(of: " ", with: "%")
        let urlRoot = "https://data.cityofnewyork.us/resource/4isn-xf7m.json"
        //let urlPath = "?$where=lower(\(filterOptions[0])) like lower('%25\(formattedQuery)%25')&$order=\(filterOptions[1]) \(filterOptions[2])"
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
                        //print(school)
                        schools.append(school)
                    }else{
                        print("here7")
                    }
                }
            }
            print("withNameMatching completion")
            completion(schools, error, statusCode)
        })

    }
    
    static func retrieveSchoolWithCount(limit: Int, offset: Int, completion: @escaping ([School], Bool, Int) -> Void){
        print("retrieveSchoolWithCount starting")
        //let urlComponents: URLComponents = URLComponents(string: "https://data.cityofnewyork.us/resource/9pyc-nsiu.json?$limit=\(limit)&$offset=\(offset)")!;
        let urlComponents: URLComponents = URLComponents(string: "https://data.cityofnewyork.us/resource/4isn-xf7m.json?$limit=\(limit)&$offset=\(offset)")!;
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
    }
    
    static func json(fromURL urlComponents: URLComponents, completion: @escaping ([[String: Any]], Bool, Int) -> Void) {
        print("json method starting")
        let session: URLSession = URLSession(configuration: .default) // shared session for interacting with the web service
        var json = [[String: Any]]()
        session.dataTask(with: urlComponents.url!, completionHandler: { (data,response, error) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
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
        }).resume()
    }
    
    func generalInfoAsArray() -> [String]{
        return [
            /*self.name,
            self.schoolCode,
            self.managedByName,
            self.grades,
            self.principalName*/
        ]
    }
    
    func locationInfoAsArray() -> [String]{
        return [
            /*self.borough,
            self.address,
            self.zipCode*/
        ]
    }
    
    func asArray() -> [String] {
        return generalInfoAsArray() + locationInfoAsArray()
    }
    
    static func coordinates(fromSchoolCode code: String, completion: @escaping ([String: Double], Bool, Int) -> Void){
        //print(code)
        let urlComponents: URLComponents = URLComponents(string: "https://data.cityofnewyork.us/resource/9pyc-nsiu.json?ats_system_code=\(code)&$select=longitude,%20latitude")!;
        json(fromURL: urlComponents, completion: { (json, error, statusCode) in
            //for result in json {
            var coordinates: [String: Double] = [:]
            if(!error){
                guard let lat = json[0]["latitude"] as? String,
                    let lon = json[0]["longitude"] as? String
                    else{
                        print("here8")
                        return
                }
            coordinates = ["latitude": Double(lat)!, "longitude": Double(lon)!]
            }
            completion(coordinates, error, statusCode)
        //}
        })
    }
    
    static func initializeMapDictionary(){
        School.keyMap = Dictionary(keys: readableTerms, values: keys)

    }
    
}
