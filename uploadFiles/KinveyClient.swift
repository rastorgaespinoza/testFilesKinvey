//
//  KinveyClient.swift
//  buohIpad
//
//  Created by Rodrigo Astorga on 17-06-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation
import CoreData

class KinveyClient: NSObject {
    
    typealias completionData = (_ result: AnyObject?, _ error: NSError?) -> Void
    typealias completionForViewController = (_ success: Bool, _ errorString: String?) -> Void
    typealias completionSuccess = (_ success: Bool, _ error: NSError?) -> Void
    
    var authToken: String? = nil
    var onlyToken: String? = nil
    var session: URLSession

    lazy var appCredentials: String = {
        let appCredentials = "\(Constants.AppKey):\(Constants.AppSecret)"
        let credEncoded = appCredentials.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let credData = credEncoded!.base64EncodedString(options: [])
        let authValue = "Basic \(credData)"
        return authValue
        
    }()
    
    lazy var userCredentials: String = {
        let appCredentials = "rastorga:rastorga"
        let credEncoded = appCredentials.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let credData = credEncoded!.base64EncodedString(options: [])
        let authValue = "Basic \(credData)"
        return authValue
        
    }()
    
    
    override init() {
        session = URLSession.shared
//        session.configuration.HTTPMaximumConnectionsPerHost = 2
        super.init()
    }
    
    /**
     *  This class variable provides an easy way to get access
     *  to a shared instance of the KinveyClient class.
     */
    class func sharedInstance() -> KinveyClient {
        struct Static {
            static let instance = KinveyClient()
        }
        return Static.instance
    }
    
    
    // MARK: - Methods
    
    /**
     Función que intenta autenticar un usuario contra Kinvey
     - author: Rodrigo Astorga.
     - parameter credentials: un diccionario de tipo [String: String] que posee el nombre del usuario y la clave del mismo.
     Para acceder a estos datos se utiliza las claves (keys) "username" y "password".
     - returns: un callback llamado completionForRequestToken que contiene el resultado obtenido desde Kinvey con el token de sesión y
     un error en caso de algún fallo.
     */
    func getRequestToken(_ credentials: [String: String], completionForRequestToken: @escaping completionData ){
        
        // 1. Path
        let path = Paths.BaseUsers + "login"
        
        // 2. Si la url no está bien formateada, retornar error.
        guard let url = URL(string: path) else {
            let userInfo:[String:String] = [NSLocalizedDescriptionKey: "Error al intentar acceder a url \(path)"]
            completionForRequestToken(nil, NSError(domain: "InvalidURL", code: 1, userInfo: userInfo) )
            return
        }
        
        // 3. función que realiza la configuración del request y el posterior request
        taskForMethod(url, HTTPMethod: HTTPMethods.POST, HTTPBody: credentials as [String : AnyObject]?, withAppCredentials: appCredentials, completionHandler: completionForRequestToken)

    }
    
    /**
     Realiza todo el proceso necesario para realizar un request al servidor.
     - Author: Rodrigo Astorga.
     - Parameters:
         - method: Un `NSURL` que contiene la url del objeto que se desea obtener o guardar (ej: NSURL(string: "https://baas.kinvey.com")  )
         - HTTPMethod: un `String` que contiene el método HTTP que se va a ejecutar: "GET", "POST", "PUT" o "DELETE" (se sugiere utilizar el `struct` HTTPMethods. A modo de ejemplo: HTTPMethods.GET ). Por defecto es "GET".
         - HTTPBody: un Diccionario `[String: AnyObject]` con información que se desea enviar al servidor. Esto forma parte del body. Es opcional y por defecto es `nil`.
         - withAppCredentials: un `String` con las credenciales encriptadas de la app que se incorporan en la cabecera del task request. Es opcional y por defecto es `nil`.
     - returns: un callback llamado completionHandler compuesto por el resultado obtenido luego de haber realizado el request y un error en caso de que exista.
     */
    func taskForMethod(_ method: URL, HTTPMethod: String = HTTPMethods.GET, HTTPBody: [String: AnyObject]? = nil,  withAppCredentials: String? = nil, completionHandler: @escaping completionData ) {
        
        // 1. Configuración del request
        var request = URLRequest(url: method)
        request.httpMethod = HTTPMethod
        request.timeoutInterval = ParameterKeys.TimeOut
        
        // 1.1 Si se provee credenciales de app, entonces configuramos el task
        // con las credenciales de la app; en caso contrario, con el authToken que se obtuvo luego del login.
        if let appCred = withAppCredentials {
            request.setValue(appCred, forHTTPHeaderField: ParameterKeys.Authorization)
        }else{
            request.setValue(userCredentials, forHTTPHeaderField: ParameterKeys.Authorization)
//            request.setValue(authToken!, forHTTPHeaderField: ParameterKeys.Authorization)
        }
        
        // Si es un método POST o PUT, configurar el cuerpo del mensaje
        switch HTTPMethod {
        case HTTPMethods.POST, HTTPMethods.PUT:
            
            guard let body = HTTPBody , JSONSerialization.isValidJSONObject(body) else {
                let userInfo:[String:String] = [NSLocalizedDescriptionKey: "Error al intentar serializar el mensaje a enviar"]
                completionHandler(nil, NSError(domain: "InvalidSerializationBody", code: 2, userInfo: userInfo) )
                return
            }
            
            request.addValue("3", forHTTPHeaderField: "X-Kinvey-API-Version")
            request.addValue(ParameterKeys.AppJSon, forHTTPHeaderField: ParameterKeys.ContentTypeJSon)
            request.addValue("image/png", forHTTPHeaderField: "X-Kinvey-Content-Type")
            let bodyData: Data!
            do {
                bodyData = try JSONSerialization.data(withJSONObject: body, options: [])
            }catch {
                let userInfo:[String:String]  = [NSLocalizedDescriptionKey: "Error al intentar serializar el mensaje a enviar"]
                completionHandler(nil, NSError(domain: "InvalidSerializationBody", code: 2, userInfo: userInfo))
                return
            }
            
            request.httpBody = bodyData
            
        default:
            break
        }

        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async{
                CommonHelpers.validateData(domain: "taskForMethod", data: data, response: response, error: error as NSError?, completionForValidation: completionHandler)
                return
            }
        }) 
        
        task.resume()
//
        

        //
    }
    
    ///Helper para creación de URL
    func kinveyURL(_ urlStringBase: String, parameters: [String: AnyObject]? = nil) -> URL? {
        
        guard var components = URLComponents(string: urlStringBase) 
            else {
            return nil
        }
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem: URLQueryItem!
                
                if let value = value as? String {
                    
                    if value == "null"{
                        
                    }
                    queryItem = URLQueryItem(name: key, value: (value ) )
                }else{
                    queryItem = URLQueryItem(name: key, value: String(describing: value) )
                }
                
                components.queryItems!.append(queryItem)
            }
        }
        
        let urlString = components.string ?? ""
        
        let newUrlString = urlString.replacingOccurrences(of: "%22null%22", with: "null")
        return URL(string: newUrlString) ?? nil
//        return (components.URL ?? nil)

    }
    
    /// Utilizado para creación de query en URL en formato JSON
    ///- parameter parameters: diccionario con las querys que se desean enviar
    ///- returns: un String con formato JSON. EJ: {"key":"value", "key2":"value2",...}
    func createQuery(_ parameters: [String:AnyObject]) -> String {
        if parameters.isEmpty {
            return ""
        }else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                var stringValue = ""
                //asegurarse de que es un valor "String"
                if let valueInt = value as? Int {
                    stringValue = "\"\(key)\":\(valueInt)"
                }else if let valueString = value as? String {
                    let firstCh = valueString[valueString.startIndex]
                    if firstCh == "{" || firstCh == "[" {
                        stringValue = "\"\(key)\":\(value)"
                    }else{
                        stringValue = "\"\(key)\":\"\(value)\""
                    }
                }else {
                    stringValue = "\"\(key)\":\"\(value)\""
                }
                
                
                
                //append it
                keyValuePairs.append(stringValue)
            }
            // escaped Characters:
            // { = %7B, } = %7D, " = %22, "3D" = "=", "%5B" = "[", "%5D" = "]", "%5C" = "\", "%20 = " ", "%0A" = "salto de línea"
            return "{\(keyValuePairs.joined(separator: ","))}"
        }
        
    }
    
    func containedIn<T>(_ objects: [T]) -> String{

        guard !objects.isEmpty else {
            return ""
        }

        var valuesContain = [String]()
        
        for value in objects {
            var stringValue = ""
            //asegurarse de que es un valor "String"
            if value is Int {
                stringValue = "\(value)"
            }else{
                stringValue = "\"\(value)\""
            }

            //append it
            valuesContain.append(stringValue)
        }

        return "{\"$in\":[\(valuesContain.joined(separator: ","))]}"
        // escaped Characters:
        // { = %7B, } = %7D, " = %22
//        return "\"$in\":{[\(valuesContain.joinWithSeparator(","))]}"
        
    }

}
