// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// 将 JSObject 转为 Dart Map<String, dynamic>
/// 递归处理嵌套对象和数组，确保所有层级均为 Map<String, dynamic>
Map<String, dynamic> jsObjectToMap(JSObject jsObj) {
  final dartObj = jsObj.dartify();
  if (dartObj is Map) {
    return _deepConvertMap(dartObj);
  }
  return <String, dynamic>{};
}

/// 递归将 Map<dynamic, dynamic> 转换为 Map<String, dynamic>
/// dartify() 只做浅层类型转换，嵌套 Map/List 保持 Map<dynamic,dynamic>
/// 必须递归处理，否则 fromJson() 在访问嵌套字段时会因类型不匹配而失败
Map<String, dynamic> _deepConvertMap(Map map) {
  final result = <String, dynamic>{};
  for (final entry in map.entries) {
    final key = entry.key.toString();
    result[key] = _deepConvertValue(entry.value);
  }
  return result;
}

/// 递归转换任意值：Map → Map<String,dynamic>，List → List<dynamic>（元素递归）
dynamic _deepConvertValue(dynamic value) {
  if (value is Map) {
    return _deepConvertMap(value);
  } else if (value is List) {
    return value.map(_deepConvertValue).toList();
  }
  return value;
}

/// 将 JSArray 转为 Dart List<Map<String, dynamic>>
List<Map<String, dynamic>> jsArrayToMapList(JSArray jsArr) {
  final dartList = jsArr.toDart;
  return dartList.map((item) {
    if (item is JSObject) {
      return jsObjectToMap(item);
    }
    return <String, dynamic>{};
  }).toList();
}

/// 将 JSArray 转为 Dart List<dynamic>
List<dynamic> jsArrayToList(JSArray jsArr) {
  final dartList = jsArr.toDart;
  return dartList.map((item) {
    if (item == null) return null;
    if (item.isA<JSString>()) return (item as JSString).toDart;
    if (item.isA<JSNumber>()) return (item as JSNumber).toDartDouble;
    if (item.isA<JSBoolean>()) return (item as JSBoolean).toDart;
    if (item.isA<JSArray>()) return jsArrayToList(item as JSArray);
    if (item.isA<JSObject>()) return jsObjectToMap(item as JSObject);
    return item.dartify();
  }).toList();
}

/// 递归移除 Map 中所有值为 null 的条目
/// 这对于 JS interop 非常重要：JS SDK 的默认参数机制依赖属性不存在（undefined），
/// 而不是属性存在但值为 null。传入 null 会覆盖 SDK 内部默认值导致异常。
Map<String, dynamic> _removeNullValues(Map<String, dynamic> map) {
  final result = <String, dynamic>{};
  for (final entry in map.entries) {
    if (entry.value == null) continue;
    if (entry.value is Map<String, dynamic>) {
      final cleaned = _removeNullValues(entry.value as Map<String, dynamic>);
      if (cleaned.isNotEmpty) {
        result[entry.key] = cleaned;
      }
    } else if (entry.value is Map) {
      final cleaned =
          _removeNullValues(Map<String, dynamic>.from(entry.value as Map));
      if (cleaned.isNotEmpty) {
        result[entry.key] = cleaned;
      }
    } else {
      result[entry.key] = entry.value;
    }
  }
  return result;
}

/// 将 Dart Map 转为 JSObject
/// 自动移除 null 值以避免覆盖 JS SDK 的内部默认值
JSObject dartMapToJsObject(Map<String, dynamic> map) {
  final cleaned = _removeNullValues(map);
  return cleaned.jsify() as JSObject;
}

/// 安全地从 JSObject 中获取字符串属性
String? getJSStringProperty(JSObject obj, String key) {
  final value = obj.getProperty(key.toJS);
  if (value == null || value.isUndefinedOrNull) return null;
  if (value.isA<JSString>()) return (value as JSString).toDart;
  return value.toString();
}

/// 安全地从 JSObject 中获取数字属性
num? getJSNumberProperty(JSObject obj, String key) {
  final value = obj.getProperty(key.toJS);
  if (value == null || value.isUndefinedOrNull) return null;
  if (value.isA<JSNumber>()) return (value as JSNumber).toDartDouble;
  return null;
}

/// 安全地从 JSObject 中获取 int 属性
int? getJSIntProperty(JSObject obj, String key) {
  final value = getJSNumberProperty(obj, key);
  return value?.toInt();
}

/// 安全地从 JSObject 中获取 bool 属性
bool? getJSBoolProperty(JSObject obj, String key) {
  final value = obj.getProperty(key.toJS);
  if (value == null || value.isUndefinedOrNull) return null;
  if (value.isA<JSBoolean>()) return (value as JSBoolean).toDart;
  return null;
}

/// 安全地从 JSObject 中获取嵌套 JSObject 属性
JSObject? getJSObjectProperty(JSObject obj, String key) {
  final value = obj.getProperty(key.toJS);
  if (value == null || value.isUndefinedOrNull) return null;
  if (value.isA<JSObject>()) return value as JSObject;
  return null;
}

/// 安全地从 JSObject 中获取 JSArray 属性
JSArray? getJSArrayProperty(JSObject obj, String key) {
  final value = obj.getProperty(key.toJS);
  if (value == null || value.isUndefinedOrNull) return null;
  if (value.isA<JSArray>()) return value as JSArray;
  return null;
}
