
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit

@objcMembers
open class NECustomUtils: NSObject {
  /// 合并转发自定义消息 type: 101
  public static let customMultiForwardType = 101

  /// 富文本（标题+内容）消息自定义消息 type: 102
  public static let customRichTextType = 102

  /// JSON 字符串转字典
  /// - Parameter jsonString: JSON 字符串
  /// - Returns: 字典
  public class func getDictionaryFromJSONString(_ jsonString: String) -> [String: Any]? {
    if let jsonData = jsonString.data(using: .utf8),
       let dict = try? JSONSerialization.jsonObject(
         with: jsonData,
         options: .mutableContainers
       ) as? [String: Any] {
      return dict
    }
    return nil
  }

  /// 返回自定义消息 attachment
  public static func attachmentOfCustomMessage(_ attachment: V2NIMMessageAttachment?) -> [String: Any]? {
    if let raw = attachment?.raw,
       let attachment = getDictionaryFromJSONString(raw) {
      return attachment
    }
    return nil
  }

  /// 返回自定义消息 type
  public static func typeOfCustomMessage(_ attachment: V2NIMMessageAttachment?) -> Int? {
    if let custom = attachmentOfCustomMessage(attachment) {
      return custom["type"] as? Int
    }
    return nil
  }

  /// 返回自定义消息 data
  public static func dataOfCustomMessage(_ attachment: V2NIMMessageAttachment?) -> [String: Any]? {
    if let custom = attachmentOfCustomMessage(attachment) {
      return custom["data"] as? [String: Any]
    }
    return nil
  }

  /// 返回自定义消息 cell 高度
  public static func heightOfCustomMessage(_ attachment: V2NIMMessageAttachment?) -> CGFloat? {
    if let custom = attachmentOfCustomMessage(attachment) {
      return custom["customHeight"] as? CGFloat
    }
    return nil
  }

  /// 返回换行消息标题 title
  public static func titleOfRichText(_ attachment: V2NIMMessageAttachment?) -> String? {
    if let attach = NECustomUtils.attachmentOfCustomMessage(attachment) {
      if let customType = attach["type"] as? Int,
         customType == customRichTextType,
         let data = attach["data"] as? [String: Any] {
        if let title = data["title"] as? String {
          return title
        }
      }
    }

    return nil
  }

  /// 返回换行消息内容 body
  public static func bodyOfRichText(_ attachment: V2NIMMessageAttachment?) -> String? {
    if let attach = NECustomUtils.attachmentOfCustomMessage(attachment) {
      if let customType = attach["type"] as? Int,
         customType == customRichTextType,
         let data = attach["data"] as? [String: Any] {
        if let body = data["body"] as? String {
          return body
        }
      }
    }

    return nil
  }

  /// 返回换行消息外显文案（有标题返回标题 title，没有标题返回内容 body）
  public static func contentOfRichText(_ attachment: V2NIMMessageAttachment?) -> String? {
    if let title = NECustomUtils.titleOfRichText(attachment) {
      return title
    }

    if let body = NECustomUtils.bodyOfRichText(attachment) {
      return body
    }

    return nil
  }

  /// 返回自定义消息的外显文案
  static func contentOfCustomMessage(_ attachment: V2NIMMessageAttachment?) -> String {
    if let customType = NECustomUtils.typeOfCustomMessage(attachment) {
      if customType == customMultiForwardType {
        return "[聊天记录]"
      }
      if customType == customRichTextType,
         let content = contentOfRichText(attachment) {
        return content
      }

      return "[自定义消息]"
    }
    return "[未知消息体]"
  }
}
