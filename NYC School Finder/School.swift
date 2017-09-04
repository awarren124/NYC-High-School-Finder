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

    let keys = [
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
        "city",
        
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
        
        //other sports (not displayed in main tableview)
        "psal_sports_girls",
        "psal_sports_coed",
        "school_sports"
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
        
        
        for key in keys {
            if let val = json[key] {
                print("here6 \(key)")
                values[key] = val
            }else{
                print("here5")
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



    static func schools(withNameMatching query: String, completion: @escaping ([School]) -> Void) {
        print("withNameMatching starting")
        let formattedQuery = query.replacingOccurrences(of: " ", with: "%")
        //let urlComponents: URLComponents = URLComponents(string: "https://data.cityofnewyork.us/resource/9pyc-nsiu.json?$q=\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)")!;
        let urlComponents: URLComponents = URLComponents(string: "https://data.cityofnewyork.us/resource/4isn-xf7m.json?$where=lower(school_name)%20like%20lower(%27%25\(formattedQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)%25%27)")!;
        var schools: [School] = []
        print(urlComponents.url!)

        json(fromURL: urlComponents, completion: { (json) in
            for result in json {
                if let school = School(json: result) {
                    print(school)
                    schools.append(school)
                }else{
                    print("here7")
                }
            }
            print("withNameMatching completion")
            completion(schools)
        })

    }
    
    static func retrieveSchoolWithCount(limit: Int, offset: Int, completion: @escaping ([School]) -> Void){
        print("retrieveSchoolWithCount starting")
        //let urlComponents: URLComponents = URLComponents(string: "https://data.cityofnewyork.us/resource/9pyc-nsiu.json?$limit=\(limit)&$offset=\(offset)")!;
        let urlComponents: URLComponents = URLComponents(string: "https://data.cityofnewyork.us/resource/4isn-xf7m.json?$limit=\(limit)&$offset=\(offset)")!;
        var schools = [School]()
            json(fromURL: urlComponents, completion: { (json) in
            for result in json {
                if let school = School(json: result) {
                    schools.append(school)
                }
            }
            print("retrieveSchoolWithCount completion")
            completion(schools)
        })
    }
    
    static func json(fromURL urlComponents: URLComponents, completion: @escaping ([[String: Any]]) -> Void) {
        print("json method starting")
        let session: URLSession = URLSession(configuration: .default) // shared session for interacting with the web service
        var json = [[String: Any]]()
        session.dataTask(with: urlComponents.url!, completionHandler: { (data,response, error) -> Void in
            if let data = data,
                let temp = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                json = temp!
            }
            print("json method completion")
            completion(json)
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
    
    static func coordinates(fromSchoolCode code: String, completion: @escaping ([String: Double]) -> Void){
        print(code)
        let urlComponents: URLComponents = URLComponents(string: "https://data.cityofnewyork.us/resource/9pyc-nsiu.json?ats_system_code=\(code)&$select=longitude,%20latitude")!;
        json(fromURL: urlComponents, completion: { (json) in
            //for result in json {
            guard let lat = json[0]["latitude"] as? String,
                let lon = json[0]["longitude"] as? String
                else{
                    print("here8")
                    return
            }
            let coordinates = ["latitude": Double(lat), "longitude": Double(lon)]
            completion(coordinates as! [String : Double])
        //}
        })
    }

}
