//
//  NIMPassThrough.swift
//  nim_core
//
//  Created by 李成达 on 2021/11/30.
//

import Foundation
import NIMSDK

extension NIMPassThroughHttpData: NimDataConvertProtrol {
    
    @objc static func modelPropertyBlacklist() -> [String] {
        return [#keyPath(NIMPassThroughHttpData.method)]
    }
    
    func toDic() -> [String : Any]? {
        if var jsonObject = self.yx_modelToJSONObject() as? [String : Any]  {
            jsonObject["method"] = self.method.rawValue
            return jsonObject
        }
        return nil
    }
    
    static func fromDic(_ json: [String : Any]) -> Any? {
        if let model = NIMPassThroughHttpData.yx_model(with: json) {
            if let method = json["method"] as? Int, let m = NIPassThroughHttpMethod(rawValue: method) {
                model.method = m
            }
            return model
        }
        return nil
    }
    
    
}
