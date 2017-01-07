

import Foundation
import UIKit

extension UIView{
    func addContrainsWithVS(format:String,views:UIView...){
        var dic:Dictionary<String,Any> = [:]
        for (index,value) in views.enumerated(){
            value.translatesAutoresizingMaskIntoConstraints = false
            dic["v\(index)"] = value
        }
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: dic))
    }
}
extension UIImageView{
    func loadImageOnline(link:String){
        let indicator:UIActivityIndicatorView = {
            let indi = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            indi.color = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            indi.translatesAutoresizingMaskIntoConstraints = false
            return indi
        }()
        self.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicator.startAnimating()
        let queue = DispatchQueue(label: "queue")
        queue.async {
            let url = URL(string: link)
            do{
                let data = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                    indicator.stopAnimating()
                    indicator.hidesWhenStopped = true
                }
            }catch{}
        }
        
    }
}
func loadJson(linkAPI:API,method : Method = .get,parameter:Dictionary<String,Any>, completion:@escaping (Any?)->()){// ham ben trong ham
    var link = linkAPI.fullLink
    if parameter != nil{
        link = link + "?" + parameter!
    }
    let url:URL = URL(string: linkAPI.fullLink)! // tu API chuyen thanh string
    var request:URLRequest = URLRequest(url: url)
    request.httpMethod = method.toString
    let session:URLSession = URLSession.shared
    session.dataTask(with: request) { (data, res, err) in
        if err == nil{
        do{
        let object = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            DispatchQueue.main.async {
                completion(object)
            }
            
        }catch{
            DispatchQueue.main.async {
                completion(nil)
            }
            
            }
        }else{
            DispatchQueue.main.async {
                completion(nil)
            }
            
        }
    }.resume()

}




