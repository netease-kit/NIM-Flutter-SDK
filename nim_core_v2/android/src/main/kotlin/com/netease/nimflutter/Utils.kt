/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import org.json.JSONArray
import org.json.JSONObject

object Utils {

    fun jsonStringToMap(json: String?): Map<String, Any?> =
        runCatching {
            jsonObjectToMap(JSONObject(json!!))
        }.getOrDefault(mapOf())

    private fun jsonObjectToMap(jsonObject: JSONObject): Map<String, Any?> {
        val map: MutableMap<String, Any> = HashMap()
        val keys = jsonObject.keys()
        while (keys.hasNext()) {
            val key = keys.next()
            var value = jsonObject[key]
            if (value is JSONArray) {
                value = jsonArrayToList(value)
            } else if (value is JSONObject) {
                value = jsonObjectToMap(value)
            }
            map[key] = value
        }
        return map
    }

    private fun jsonArrayToList(array: JSONArray): List<Any?> {
        val list: MutableList<Any> = ArrayList()
        for (i in 0 until array.length()) {
            var value: Any = array.get(i)
            if (value is JSONArray) {
                value = jsonArrayToList(value)
            } else if (value is JSONObject) {
                value = jsonObjectToMap(value)
            }
            list.add(value)
        }
        return list
    }
}
