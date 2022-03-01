//
//  AuthManager.swift
//  Spotify
//
//  Created by mohamedSliem on 1/29/22.


import Foundation

final class AuthManager
{
    static let shared = AuthManager()
    private var IsResfreshingToken = false
    private init(){}
    struct Constants {
        static let clienID = "ffad75aa04a54aeb8ee4923dcfa82a63"
        static let clientSecret = "f298fae2ca744c0f85f1bc0431609f8a"
        static let tokenURl = "https://accounts.spotify.com/api/token"
        static let redirectURL = "https://open.spotify.com"
        static let scopes = "user-read-private%20playlist-modify-private%20playlist-read-private%20playlist-modify-public%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    public var signInURL : URL? {
        let base = "https://accounts.spotify.com/authorize?"
        let quiers = "response_type=code&client_id=\(Constants.clienID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURL)&show_diaglog=true"
        let url = "\(base)\(quiers)"
        return URL(string: url)
    }
    
    var isSignedIn : Bool{
        return accessToken != nil
    }
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    private var refreshToken: String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    private var tokenExpirationDate : Date?{
        return UserDefaults.standard.object(forKey: "experationDate") as? Date
    }
    private var shouldRefreshToken: Bool{
        guard let experationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMin : TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMin) >= experationDate
    }
    
    
    //appends completion blocks if the refreshing process on progress
    var onRefreshBlocks = [(String)->Void]()
    
    // supplies the latest valid token to the api caller manager
    public func withValidToken(completion : @escaping (String) -> Void)
    {
        guard !IsResfreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        guard shouldRefreshToken else
        {
            if let token = accessToken{
                completion(token)
            }
            return
        }
        
        refreshTokenIfNeeded { [weak self] success in
            if success , let token = self?.accessToken{
                completion(token)
            }
        }
        
    }
    
    public func exchangeCodeForToken(
        code : String ,
        completion : @escaping((Bool) -> Void))
    {
        guard let url = URL(string: Constants.tokenURl)
        else {
            return
        }
        var compentents = URLComponents()
        compentents.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value:"https://open.spotify.com")
        ]
        let basicToken = Constants.clienID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let basic64String = data?.base64EncodedString() else {
            return
        }
        var requet = URLRequest(url: url)
        requet.httpMethod = "POST"
        requet.httpBody = compentents.query?.data(using: .utf8)
        requet.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
        requet.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: requet){data , _ , error in
            
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do
            {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.cacheToken(result: result)
                completion(true)
            }
            catch{
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func refreshTokenIfNeeded(completion : ((Bool) -> Void)?)
    {
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        
        guard let url = URL(string: Constants.tokenURl) else {
            return
        }
        
        IsResfreshingToken = true
        
        //set a quiers of the request as an array of components
        var compentents = URLComponents()
        compentents.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        let basicToken = Constants.clienID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let basic64String = data?.base64EncodedString() else {
            return
        }
        //creating a request with accessToken URl
        var requet = URLRequest(url: url)
        requet.httpMethod = "POST"
        requet.httpBody = compentents.query?.data(using: .utf8)
        requet.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
        requet.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: requet){[weak self]data , _ , error in
            self?.IsResfreshingToken = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            do
            {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                self?.onRefreshBlocks.forEach {$0(result.access_token)}
                self?.onRefreshBlocks.removeAll()
                print("Refreshed")
                completion?(true)
            }
            catch{
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
    }
    
    private func cacheToken(result : AuthResponse)
    {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        UserDefaults.standard.setValue(result.token_type, forKey: "token_type")
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)),forKey: "experationDate")
        if let refreshToken = result.refresh_token
        {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(result.scope, forKey: "scope")
    }
}
