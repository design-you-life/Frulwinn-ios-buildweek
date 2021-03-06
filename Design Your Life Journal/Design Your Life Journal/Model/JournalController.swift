//  Copyright © 2019 Frulwinn. All rights reserved.

import Foundation

//let baseURL = URL(string: "https://books-2462b.firebaseio.com/")!
//let baseURL = URL(string: "https://polar-plateau-24996.herokuapp.com/activities")!
let baseURL = URL(string: "https://polar-plateau-24996.herokuapp.com")!

enum httpMethod: String {
    case put = "PUT"
    case delete = "DELETE"
    case post = "POST"
}

class JournalController {
    
    //MARK: - Properties
    private(set) var activities: [Activity] = []
    private(set) var reflections: [Reflection] = []
    
    //for activity
    func postActivity(activity: Activity, completion: @escaping (Error?) -> Void) {
        
        let authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicGFzc3dvcmQiOiIkMmEkMTQkSk8vbHB4RjZKa1MwUVhleFNwMmZHdS9Pc1lvU01URU1TZnF4YURac2VVclFyUkdiR2FiVlciLCJpYXQiOjE1NDk0MjAwODcsImV4cCI6MTU0OTc4MDA4N30.9Ke9kzZ9kCZA97ds-AQZuEm-f_N38rIODkzqA9tkGYk" //provided by Backend
        let url = baseURL.appendingPathComponent("activities")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.post.rawValue
        urlRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let activity: [String: Any] = ["name": activity.name, "fk": 1, "enjoymentRating": activity.enjoymentRating, "energyLevel": activity.energyLevel, "engagement": activity.engagement]
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: activity, options: [])
            urlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (_, _, error) in
            //print(response)
            if let error = error {
                NSLog("error trying to POST data: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }
        dataTask.resume()
    }
    
    func createActivity(name: String, engagement: Int, enjoymentRating: Int, energyLevel: Int, fk: Int, completion: @escaping (Error?) -> Void) {
        
        let activity = Activity(name: name, engagement: engagement, enjoymentRating: enjoymentRating, energyLevel: energyLevel, timestamp: nil, fk: 1, id: Int(arc4random()))
        
        postActivity(activity: activity, completion: completion)
    }
    
    func updateActivity(activity: Activity, name: String, engagement: Int, enjoymentRating: Int, energyLevel: Int, fk: Int, completion: @escaping (Error?) -> Void) {
        
        guard let index = activities.index(of: activity) else { return }
        var updatedActivity = self.activities[index]

        updatedActivity.name = name
        updatedActivity.engagement = engagement
        updatedActivity.enjoymentRating = enjoymentRating
        updatedActivity.energyLevel = energyLevel
        
        let authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicGFzc3dvcmQiOiIkMmEkMTQkSk8vbHB4RjZKa1MwUVhleFNwMmZHdS9Pc1lvU01URU1TZnF4YURac2VVclFyUkdiR2FiVlciLCJpYXQiOjE1NDk0MjAwODcsImV4cCI6MTU0OTc4MDA4N30.9Ke9kzZ9kCZA97ds-AQZuEm-f_N38rIODkzqA9tkGYk" //provided by Backend

        let url = baseURL.appendingPathComponent("activities").appendingPathComponent(String(activity.id))

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.put.rawValue
        urlRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let activity: [String: Any] = ["name": updatedActivity.name, "fk": 1, "engagement": updatedActivity.engagement, "enjoymentRating": updatedActivity.enjoymentRating, "energyLevel": updatedActivity.energyLevel]
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: activity, options: [])
            urlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (_, _, error) in
            if let error = error {
                NSLog("error trying to PUT data: \(error)")
                completion(error)
                return
            }
            self.activities[index] = updatedActivity
            completion(nil)
        }
        dataTask.resume()
    }
    
    func fetchActivities(completion: @escaping (Error?) -> Void) {
        let authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicGFzc3dvcmQiOiIkMmEkMTQkSk8vbHB4RjZKa1MwUVhleFNwMmZHdS9Pc1lvU01URU1TZnF4YURac2VVclFyUkdiR2FiVlciLCJpYXQiOjE1NDk0MjAwODcsImV4cCI6MTU0OTc4MDA4N30.9Ke9kzZ9kCZA97ds-AQZuEm-f_N38rIODkzqA9tkGYk" //provided by Backend
        
        let url = baseURL.appendingPathComponent("activities")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // print(response)
            if let error = error {
                NSLog("unable to decode activity: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else { // Make sure we have data
                completion(error)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let activities = try jsonDecoder.decode(Activities.self, from: data)
                self.activities = activities
               
            } catch {
                NSLog("could not decode activity data")
                completion(error)
                return
            }
            completion(nil)
        }
        dataTask.resume()
    }
    
    
    func deleteActivity(activity: Activity, completion: @escaping (Error?) -> Void) {
        let authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicGFzc3dvcmQiOiIkMmEkMTQkSk8vbHB4RjZKa1MwUVhleFNwMmZHdS9Pc1lvU01URU1TZnF4YURac2VVclFyUkdiR2FiVlciLCJpYXQiOjE1NDk0MjAwODcsImV4cCI6MTU0OTc4MDA4N30.9Ke9kzZ9kCZA97ds-AQZuEm-f_N38rIODkzqA9tkGYk" //provided by Backend
        
        let url = baseURL.appendingPathComponent("activities").appendingPathComponent(String(activity.id))
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.delete.rawValue
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (_, _, error) in
            //print(response)
            if let error = error {
                NSLog("error trying to delete activity data: \(error)")
                completion(error)
                return
            }
            guard let index = self.activities.index(of: activity) else { return }
            self.activities.remove(at: index)
            completion(nil)
        }
        dataTask.resume()
    }
    
    
    // for reflection
    func postReflection(reflection: Reflection, completion: @escaping (Error?) -> Void) {
        let authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicGFzc3dvcmQiOiIkMmEkMTQkSk8vbHB4RjZKa1MwUVhleFNwMmZHdS9Pc1lvU01URU1TZnF4YURac2VVclFyUkdiR2FiVlciLCJpYXQiOjE1NDk0MjAwODcsImV4cCI6MTU0OTc4MDA4N30.9Ke9kzZ9kCZA97ds-AQZuEm-f_N38rIODkzqA9tkGYk" //provided by Backend
        
        let url = baseURL.appendingPathComponent("reflections")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.post.rawValue
        urlRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let reflection: [String: Any] = ["journalEntry": reflection.journalEntry, "fk": 1, "week": reflection.week, "insights": reflection.insights, "trends": reflection.trends, "surprises": reflection.surprises]
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: reflection, options: [])
            urlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (_, _, error) in
            if let error = error {
                NSLog("error trying to PUT data: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }
        dataTask.resume()
    }
    
    func createReflection(journalEntry: String, surprises: String, insights: String, trends: String, week: String, fk: Int, id: Int, completion: @escaping (Error?) -> Void) {
        
        //let reflection = Reflection(journalEntry: journalEntry, surprises: surprises, insights: insights, trends: trends, week: week, fk: fk, id: id)
        let reflection = Reflection(journalEntry: journalEntry, timestamp: nil, surprises: surprises, insights: insights, trends: trends, week: week, fk: 1, id: Int(arc4random()))
        postReflection(reflection: reflection, completion: completion)
    }
    
    func updateReflection(reflection: Reflection, journalEntry: String, surprises: String, insights: String, trends: String, week: String, fk: Int, completion: @escaping (Error?) -> Void) {
        
        guard let index = self.reflections.index(of: reflection) else { return }
        var updatedReflection = self.reflections[index]
        updatedReflection.journalEntry = journalEntry
        updatedReflection.surprises = surprises
        updatedReflection.insights = insights
        updatedReflection.trends = trends
        updatedReflection.week = week
        
        let authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicGFzc3dvcmQiOiIkMmEkMTQkSk8vbHB4RjZKa1MwUVhleFNwMmZHdS9Pc1lvU01URU1TZnF4YURac2VVclFyUkdiR2FiVlciLCJpYXQiOjE1NDk0MjAwODcsImV4cCI6MTU0OTc4MDA4N30.9Ke9kzZ9kCZA97ds-AQZuEm-f_N38rIODkzqA9tkGYk" //provided by Backend
        
        let url = baseURL.appendingPathComponent("reflections").appendingPathComponent(String(reflection.id))
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.put.rawValue
        urlRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let reflection: [String: Any] = ["journalEntry": updatedReflection.journalEntry, "fk": 1, "week": updatedReflection.week, "insights": updatedReflection.insights, "trends": updatedReflection.trends, "surprises": updatedReflection.surprises]
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: reflection, options: [])
            urlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (_, _, error) in
            if let error = error {
                NSLog("error trying to PUT data: \(error)")
                completion(error)
                return
            }
            self.reflections[index] = updatedReflection
            completion(nil)
        }
        dataTask.resume()
    }
    
    func fetchReflections(completion: @escaping (Error?) -> Void) {
        let authToken = String(stringLiteral: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicGFzc3dvcmQiOiIkMmEkMTQkSk8vbHB4RjZKa1MwUVhleFNwMmZHdS9Pc1lvU01URU1TZnF4YURac2VVclFyUkdiR2FiVlciLCJpYXQiOjE1NDk0MjAwODcsImV4cCI6MTU0OTc4MDA4N30.9Ke9kzZ9kCZA97ds-AQZuEm-f_N38rIODkzqA9tkGYk")
        let url = baseURL.appendingPathComponent("reflections")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("error getting reflections: \(error)")
                //completion(error)
                return
            }
            
            guard let data = data else {
                completion(error)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let reflections = try jsonDecoder.decode(Reflections.self, from: data)
                self.reflections = reflections
    
            } catch {
                NSLog("could not decode reflections data")
                completion(error)
                return
            }
            completion(nil)
        }
        dataTask.resume()
    }
    
    func deleteReflection(reflection: Reflection, completion: @escaping (Error?) -> Void) {
        let authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicGFzc3dvcmQiOiIkMmEkMTQkSk8vbHB4RjZKa1MwUVhleFNwMmZHdS9Pc1lvU01URU1TZnF4YURac2VVclFyUkdiR2FiVlciLCJpYXQiOjE1NDk0MjAwODcsImV4cCI6MTU0OTc4MDA4N30.9Ke9kzZ9kCZA97ds-AQZuEm-f_N38rIODkzqA9tkGYk" //provided by Backend
        
        
        let url = baseURL.appendingPathComponent("reflections").appendingPathComponent(String(reflection.id))
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.delete.rawValue
        request.addValue(authToken, forHTTPHeaderField: "Authorization") // authToken here will be the authorization
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        /*do {
            let encoder = JSONEncoder()
            let encodedActivity = try encoder.encode(reflection)
            request.httpBody = encodedActivity
        } catch {
            NSLog("error encoding activity: \(error)")
            completion(error)
            return
        }*/
        
        let dataTask = URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("error trying to delete reflection data: \(error)")
                completion(error)
                return
            }
            guard let index = self.reflections.index(of: reflection) else { return }
            self.reflections.remove(at: index)
            completion(nil)
        }
        dataTask.resume()
    }
}
