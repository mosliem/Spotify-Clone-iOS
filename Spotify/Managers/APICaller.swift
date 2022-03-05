//
//  ApiCaller.swift
//  Spotify
//
//  Created by mohamedSliem on 1/29/22.
//

import Foundation

class APICaller {
    
    static let shared = APICaller()
    private init(){}
    
    //MARK:- Structs
    struct Constants {
        static let baseAPIUrl = "https://api.spotify.com/v1"
    }
    
    //MARK:- Enums
    enum HTTPMethod : String{
        case GET
        case POST
    }
    
    enum APIError : Error
    {
        case failedToGetData
    }
    
    
    //MARK:- Public Functions
    public func getCurrentUserPorfile(completion: @escaping (Result<UserProfile , Error>) -> Void)
    {
        
        createRequest(url: URL(string:Constants.baseAPIUrl+"/me") , HttpType: .GET) {[weak self] (request) in
            self?.createTask(type: UserProfile.self, request:request , taskCompletion: { (result, error) in
                guard let result = result , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                completion(.success(result))
            })
        }
        
        
    }
    
    public func getNewAlbumRealeses(completion : @escaping (Result <NewRealesesResponse , Error>) -> Void) {
        
        createRequest(url: URL(string:Constants.baseAPIUrl+"/browse/new-releases?limit=36&offset=37"),
                      HttpType: .GET) { (request) in
            
            self.createTask(type: NewRealesesResponse.self, request: request) { (result, error) in
                guard let result = result , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                completion(.success(result))
            }
        }
    }
    
    
    // get the featured playlist shown on browse tab
    public func getFeaturesPlaylist(completion : @escaping (Result< FeaturedPlaylistResponse , Error>)->Void ) {
        let url = URL(string: Constants.baseAPIUrl+"/browse/featured-playlists?limit=20")
        createRequest(url: url, HttpType: .GET) { [weak self] (request) in
            
            self?.createTask(type: FeaturedPlaylistResponse.self, request:request , taskCompletion: { (result, error) in
                guard let result = result , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }

                completion(.success(result))
            })
            
        }
    }
    
    
    private func getAvailableGenreSeeds(completion: @escaping(String) -> Void){
        let url = URL(string: Constants.baseAPIUrl+"/recommendations/available-genre-seeds")
        createRequest(url: url, HttpType: .GET) { [weak self] (request) in
            
            self?.createTask(type: AvailableGenreSeeds.self, request: request, taskCompletion: { (result, error) in
                guard let result = result , error == nil else {
                    return
                }
                var seed = Set<String>()
                while seed.count < 5
                {
                    if let randSeed = result.genres.randomElement(){
                        seed.insert(randSeed)
                    }
                }
                
                let seedString = seed.joined(separator: ",")
                completion(seedString)
            })
        }
    }
    
    
    public func getRecommendations(completion: @escaping (Result<RecommendationResponse , Error>) -> Void){
        getAvailableGenreSeeds {[weak self] seeds in
            
            let url = URL(string: Constants.baseAPIUrl+"/recommendations?seed_genres=\(seeds)&limit=25")
            self?.createRequest(url: url, HttpType: .GET) { [weak self](request) in
                self?.createTask(type: RecommendationResponse.self, request: request, taskCompletion: { (result, error) in
                    guard let result = result , error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    completion(.success(result))
                })
            }
        }
    }
    
//MARK:- Get Details
    public func getAlbumDetails(id : String , completion: @escaping(Result<AlbumDetailsResponse,Error>) -> Void) {
        
        createRequest(url: URL(string:Constants.baseAPIUrl+"/albums/\(id)"), HttpType: .GET) { [weak self] (request) in
            self?.createTask(type: AlbumDetailsResponse.self, request: request) {(result, error) in
                guard let result = result , error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                completion(.success(result))
            }
        }
        
    }
    
    public func getPlaylistDetails(id : String , completion: @escaping(Result<PlaylistDetailsResponse,Error>) -> Void) {
        createRequest(url: URL(string:Constants.baseAPIUrl+"/playlists/\(id)"), HttpType: .GET) { [weak self] (request) in
            self?.createTask(type: PlaylistDetailsResponse.self, request: request) {(result, error) in
                guard let result = result , error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                completion(.success(result))
            }
        }
    }
 //MARK:- Get Categories
    
    public func getCategories(completion: @escaping(Result<CategoryResponse, Error>)-> Void){
        createRequest(url:URL(string: Constants.baseAPIUrl + "/browse/categories?limit=50&country=EG"), HttpType: .GET) { [weak self](request) in
            self?.createTask(type: CategoryResponse.self, request: request) {(result, error) in
                guard let result = result , error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                completion(.success(result))
            }
        }
        
    }
    
    public func getCategoryDetails() {
        
    }
    
    // MARK:- PRIVATE
    
    // Generic Function for creating a request
    private func createRequest(url: URL?,
                               HttpType: HTTPMethod,
                               completion : @escaping(URLRequest) -> Void){
        AuthManager.shared.withValidToken { (token) in
            guard let apiUrl = url else{
                return
            }
            var request = URLRequest(url: apiUrl)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = HttpType.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
        
    }
    
    // Generic Function for creating task and decoding data with any generic type
    private func createTask <T : Codable> (type : T.Type ,
                                           request: URLRequest ,
                                           taskCompletion : @escaping(T? , Error?) -> Void)
    {
        let task = URLSession.shared.dataTask(with: request) {(data, _, error) in
            
            guard let data = data , error == nil else {
                taskCompletion(nil,error)
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                taskCompletion(result,error)
            }
            catch{
                print(error)
                taskCompletion(nil, error)
            }
            
        }
        task.resume()
    }
}
