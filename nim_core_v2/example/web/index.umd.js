(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
    typeof define === 'function' && define.amd ? define(['exports'], factory) :
    (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.FlutterWeb = {}));
})(this, (function (exports) { 'use strict';

    /******************************************************************************
    Copyright (c) Microsoft Corporation.

    Permission to use, copy, modify, and/or distribute this software for any
    purpose with or without fee is hereby granted.

    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
    REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
    AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
    INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
    LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
    OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
    PERFORMANCE OF THIS SOFTWARE.
    ***************************************************************************** */

    var __assign = function() {
        __assign = Object.assign || function __assign(t) {
            for (var s, i = 1, n = arguments.length; i < n; i++) {
                s = arguments[i];
                for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p)) t[p] = s[p];
            }
            return t;
        };
        return __assign.apply(this, arguments);
    };

    function __decorate(decorators, target, key, desc) {
        var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
        if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
        else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
        return c > 3 && r && Object.defineProperty(target, key, r), r;
    }

    function __awaiter(thisArg, _arguments, P, generator) {
        function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
        return new (P || (P = Promise))(function (resolve, reject) {
            function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
            function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
            function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
            step((generator = generator.apply(thisArg, _arguments || [])).next());
        });
    }

    function __generator(thisArg, body) {
        var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
        return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
        function verb(n) { return function (v) { return step([n, v]); }; }
        function step(op) {
            if (f) throw new TypeError("Generator is already executing.");
            while (g && (g = 0, op[0] && (_ = 0)), _) try {
                if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
                if (y = 0, t) op = [op[0] & 2, t.value];
                switch (op[0]) {
                    case 0: case 1: t = op; break;
                    case 4: _.label++; return { value: op[1], done: false };
                    case 5: _.label++; y = op[1]; op = [0]; continue;
                    case 7: op = _.ops.pop(); _.trys.pop(); continue;
                    default:
                        if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                        if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                        if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                        if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                        if (t[2]) _.ops.pop();
                        _.trys.pop(); continue;
                }
                op = body.call(thisArg, _);
            } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
            if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
        }
    }

    typeof SuppressedError === "function" ? SuppressedError : function (error, suppressed, message) {
        var e = new Error(message);
        return e.name = "SuppressedError", e.error = error, e.suppressed = suppressed, e;
    };

    var commonjsGlobal = typeof globalThis !== 'undefined' ? globalThis : typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : typeof self !== 'undefined' ? self : {};

    function getDefaultExportFromCjs (x) {
    	return x && x.__esModule && Object.prototype.hasOwnProperty.call(x, 'default') ? x['default'] : x;
    }

    function createCommonjsModule(fn) {
      var module = { exports: {} };
    	return fn(module, module.exports), module.exports;
    }

    var bind = function bind(fn, thisArg) {
      return function wrap() {
        var args = new Array(arguments.length);
        for (var i = 0; i < args.length; i++) {
          args[i] = arguments[i];
        }
        return fn.apply(thisArg, args);
      };
    };

    // utils is a library of generic helper functions non-specific to axios

    var toString = Object.prototype.toString;

    // eslint-disable-next-line func-names
    var kindOf = (function(cache) {
      // eslint-disable-next-line func-names
      return function(thing) {
        var str = toString.call(thing);
        return cache[str] || (cache[str] = str.slice(8, -1).toLowerCase());
      };
    })(Object.create(null));

    function kindOfTest(type) {
      type = type.toLowerCase();
      return function isKindOf(thing) {
        return kindOf(thing) === type;
      };
    }

    /**
     * Determine if a value is an Array
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is an Array, otherwise false
     */
    function isArray(val) {
      return Array.isArray(val);
    }

    /**
     * Determine if a value is undefined
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if the value is undefined, otherwise false
     */
    function isUndefined(val) {
      return typeof val === 'undefined';
    }

    /**
     * Determine if a value is a Buffer
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a Buffer, otherwise false
     */
    function isBuffer(val) {
      return val !== null && !isUndefined(val) && val.constructor !== null && !isUndefined(val.constructor)
        && typeof val.constructor.isBuffer === 'function' && val.constructor.isBuffer(val);
    }

    /**
     * Determine if a value is an ArrayBuffer
     *
     * @function
     * @param {Object} val The value to test
     * @returns {boolean} True if value is an ArrayBuffer, otherwise false
     */
    var isArrayBuffer = kindOfTest('ArrayBuffer');


    /**
     * Determine if a value is a view on an ArrayBuffer
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a view on an ArrayBuffer, otherwise false
     */
    function isArrayBufferView(val) {
      var result;
      if ((typeof ArrayBuffer !== 'undefined') && (ArrayBuffer.isView)) {
        result = ArrayBuffer.isView(val);
      } else {
        result = (val) && (val.buffer) && (isArrayBuffer(val.buffer));
      }
      return result;
    }

    /**
     * Determine if a value is a String
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a String, otherwise false
     */
    function isString(val) {
      return typeof val === 'string';
    }

    /**
     * Determine if a value is a Number
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a Number, otherwise false
     */
    function isNumber(val) {
      return typeof val === 'number';
    }

    /**
     * Determine if a value is an Object
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is an Object, otherwise false
     */
    function isObject(val) {
      return val !== null && typeof val === 'object';
    }

    /**
     * Determine if a value is a plain Object
     *
     * @param {Object} val The value to test
     * @return {boolean} True if value is a plain Object, otherwise false
     */
    function isPlainObject(val) {
      if (kindOf(val) !== 'object') {
        return false;
      }

      var prototype = Object.getPrototypeOf(val);
      return prototype === null || prototype === Object.prototype;
    }

    /**
     * Determine if a value is a Date
     *
     * @function
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a Date, otherwise false
     */
    var isDate = kindOfTest('Date');

    /**
     * Determine if a value is a File
     *
     * @function
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a File, otherwise false
     */
    var isFile = kindOfTest('File');

    /**
     * Determine if a value is a Blob
     *
     * @function
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a Blob, otherwise false
     */
    var isBlob = kindOfTest('Blob');

    /**
     * Determine if a value is a FileList
     *
     * @function
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a File, otherwise false
     */
    var isFileList = kindOfTest('FileList');

    /**
     * Determine if a value is a Function
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a Function, otherwise false
     */
    function isFunction(val) {
      return toString.call(val) === '[object Function]';
    }

    /**
     * Determine if a value is a Stream
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a Stream, otherwise false
     */
    function isStream(val) {
      return isObject(val) && isFunction(val.pipe);
    }

    /**
     * Determine if a value is a FormData
     *
     * @param {Object} thing The value to test
     * @returns {boolean} True if value is an FormData, otherwise false
     */
    function isFormData(thing) {
      var pattern = '[object FormData]';
      return thing && (
        (typeof FormData === 'function' && thing instanceof FormData) ||
        toString.call(thing) === pattern ||
        (isFunction(thing.toString) && thing.toString() === pattern)
      );
    }

    /**
     * Determine if a value is a URLSearchParams object
     * @function
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a URLSearchParams object, otherwise false
     */
    var isURLSearchParams = kindOfTest('URLSearchParams');

    /**
     * Trim excess whitespace off the beginning and end of a string
     *
     * @param {String} str The String to trim
     * @returns {String} The String freed of excess whitespace
     */
    function trim(str) {
      return str.trim ? str.trim() : str.replace(/^\s+|\s+$/g, '');
    }

    /**
     * Determine if we're running in a standard browser environment
     *
     * This allows axios to run in a web worker, and react-native.
     * Both environments support XMLHttpRequest, but not fully standard globals.
     *
     * web workers:
     *  typeof window -> undefined
     *  typeof document -> undefined
     *
     * react-native:
     *  navigator.product -> 'ReactNative'
     * nativescript
     *  navigator.product -> 'NativeScript' or 'NS'
     */
    function isStandardBrowserEnv() {
      if (typeof navigator !== 'undefined' && (navigator.product === 'ReactNative' ||
                                               navigator.product === 'NativeScript' ||
                                               navigator.product === 'NS')) {
        return false;
      }
      return (
        typeof window !== 'undefined' &&
        typeof document !== 'undefined'
      );
    }

    /**
     * Iterate over an Array or an Object invoking a function for each item.
     *
     * If `obj` is an Array callback will be called passing
     * the value, index, and complete array for each item.
     *
     * If 'obj' is an Object callback will be called passing
     * the value, key, and complete object for each property.
     *
     * @param {Object|Array} obj The object to iterate
     * @param {Function} fn The callback to invoke for each item
     */
    function forEach(obj, fn) {
      // Don't bother if no value provided
      if (obj === null || typeof obj === 'undefined') {
        return;
      }

      // Force an array if not already something iterable
      if (typeof obj !== 'object') {
        /*eslint no-param-reassign:0*/
        obj = [obj];
      }

      if (isArray(obj)) {
        // Iterate over array values
        for (var i = 0, l = obj.length; i < l; i++) {
          fn.call(null, obj[i], i, obj);
        }
      } else {
        // Iterate over object keys
        for (var key in obj) {
          if (Object.prototype.hasOwnProperty.call(obj, key)) {
            fn.call(null, obj[key], key, obj);
          }
        }
      }
    }

    /**
     * Accepts varargs expecting each argument to be an object, then
     * immutably merges the properties of each object and returns result.
     *
     * When multiple objects contain the same key the later object in
     * the arguments list will take precedence.
     *
     * Example:
     *
     * ```js
     * var result = merge({foo: 123}, {foo: 456});
     * console.log(result.foo); // outputs 456
     * ```
     *
     * @param {Object} obj1 Object to merge
     * @returns {Object} Result of all merge properties
     */
    function merge(/* obj1, obj2, obj3, ... */) {
      var result = {};
      function assignValue(val, key) {
        if (isPlainObject(result[key]) && isPlainObject(val)) {
          result[key] = merge(result[key], val);
        } else if (isPlainObject(val)) {
          result[key] = merge({}, val);
        } else if (isArray(val)) {
          result[key] = val.slice();
        } else {
          result[key] = val;
        }
      }

      for (var i = 0, l = arguments.length; i < l; i++) {
        forEach(arguments[i], assignValue);
      }
      return result;
    }

    /**
     * Extends object a by mutably adding to it the properties of object b.
     *
     * @param {Object} a The object to be extended
     * @param {Object} b The object to copy properties from
     * @param {Object} thisArg The object to bind function to
     * @return {Object} The resulting value of object a
     */
    function extend(a, b, thisArg) {
      forEach(b, function assignValue(val, key) {
        if (thisArg && typeof val === 'function') {
          a[key] = bind(val, thisArg);
        } else {
          a[key] = val;
        }
      });
      return a;
    }

    /**
     * Remove byte order marker. This catches EF BB BF (the UTF-8 BOM)
     *
     * @param {string} content with BOM
     * @return {string} content value without BOM
     */
    function stripBOM(content) {
      if (content.charCodeAt(0) === 0xFEFF) {
        content = content.slice(1);
      }
      return content;
    }

    /**
     * Inherit the prototype methods from one constructor into another
     * @param {function} constructor
     * @param {function} superConstructor
     * @param {object} [props]
     * @param {object} [descriptors]
     */

    function inherits(constructor, superConstructor, props, descriptors) {
      constructor.prototype = Object.create(superConstructor.prototype, descriptors);
      constructor.prototype.constructor = constructor;
      props && Object.assign(constructor.prototype, props);
    }

    /**
     * Resolve object with deep prototype chain to a flat object
     * @param {Object} sourceObj source object
     * @param {Object} [destObj]
     * @param {Function} [filter]
     * @returns {Object}
     */

    function toFlatObject(sourceObj, destObj, filter) {
      var props;
      var i;
      var prop;
      var merged = {};

      destObj = destObj || {};

      do {
        props = Object.getOwnPropertyNames(sourceObj);
        i = props.length;
        while (i-- > 0) {
          prop = props[i];
          if (!merged[prop]) {
            destObj[prop] = sourceObj[prop];
            merged[prop] = true;
          }
        }
        sourceObj = Object.getPrototypeOf(sourceObj);
      } while (sourceObj && (!filter || filter(sourceObj, destObj)) && sourceObj !== Object.prototype);

      return destObj;
    }

    /*
     * determines whether a string ends with the characters of a specified string
     * @param {String} str
     * @param {String} searchString
     * @param {Number} [position= 0]
     * @returns {boolean}
     */
    function endsWith(str, searchString, position) {
      str = String(str);
      if (position === undefined || position > str.length) {
        position = str.length;
      }
      position -= searchString.length;
      var lastIndex = str.indexOf(searchString, position);
      return lastIndex !== -1 && lastIndex === position;
    }


    /**
     * Returns new array from array like object
     * @param {*} [thing]
     * @returns {Array}
     */
    function toArray(thing) {
      if (!thing) return null;
      var i = thing.length;
      if (isUndefined(i)) return null;
      var arr = new Array(i);
      while (i-- > 0) {
        arr[i] = thing[i];
      }
      return arr;
    }

    // eslint-disable-next-line func-names
    var isTypedArray = (function(TypedArray) {
      // eslint-disable-next-line func-names
      return function(thing) {
        return TypedArray && thing instanceof TypedArray;
      };
    })(typeof Uint8Array !== 'undefined' && Object.getPrototypeOf(Uint8Array));

    var utils = {
      isArray: isArray,
      isArrayBuffer: isArrayBuffer,
      isBuffer: isBuffer,
      isFormData: isFormData,
      isArrayBufferView: isArrayBufferView,
      isString: isString,
      isNumber: isNumber,
      isObject: isObject,
      isPlainObject: isPlainObject,
      isUndefined: isUndefined,
      isDate: isDate,
      isFile: isFile,
      isBlob: isBlob,
      isFunction: isFunction,
      isStream: isStream,
      isURLSearchParams: isURLSearchParams,
      isStandardBrowserEnv: isStandardBrowserEnv,
      forEach: forEach,
      merge: merge,
      extend: extend,
      trim: trim,
      stripBOM: stripBOM,
      inherits: inherits,
      toFlatObject: toFlatObject,
      kindOf: kindOf,
      kindOfTest: kindOfTest,
      endsWith: endsWith,
      toArray: toArray,
      isTypedArray: isTypedArray,
      isFileList: isFileList
    };

    function encode(val) {
      return encodeURIComponent(val).
        replace(/%3A/gi, ':').
        replace(/%24/g, '$').
        replace(/%2C/gi, ',').
        replace(/%20/g, '+').
        replace(/%5B/gi, '[').
        replace(/%5D/gi, ']');
    }

    /**
     * Build a URL by appending params to the end
     *
     * @param {string} url The base of the url (e.g., http://www.google.com)
     * @param {object} [params] The params to be appended
     * @returns {string} The formatted url
     */
    var buildURL = function buildURL(url, params, paramsSerializer) {
      /*eslint no-param-reassign:0*/
      if (!params) {
        return url;
      }

      var serializedParams;
      if (paramsSerializer) {
        serializedParams = paramsSerializer(params);
      } else if (utils.isURLSearchParams(params)) {
        serializedParams = params.toString();
      } else {
        var parts = [];

        utils.forEach(params, function serialize(val, key) {
          if (val === null || typeof val === 'undefined') {
            return;
          }

          if (utils.isArray(val)) {
            key = key + '[]';
          } else {
            val = [val];
          }

          utils.forEach(val, function parseValue(v) {
            if (utils.isDate(v)) {
              v = v.toISOString();
            } else if (utils.isObject(v)) {
              v = JSON.stringify(v);
            }
            parts.push(encode(key) + '=' + encode(v));
          });
        });

        serializedParams = parts.join('&');
      }

      if (serializedParams) {
        var hashmarkIndex = url.indexOf('#');
        if (hashmarkIndex !== -1) {
          url = url.slice(0, hashmarkIndex);
        }

        url += (url.indexOf('?') === -1 ? '?' : '&') + serializedParams;
      }

      return url;
    };

    function InterceptorManager() {
      this.handlers = [];
    }

    /**
     * Add a new interceptor to the stack
     *
     * @param {Function} fulfilled The function to handle `then` for a `Promise`
     * @param {Function} rejected The function to handle `reject` for a `Promise`
     *
     * @return {Number} An ID used to remove interceptor later
     */
    InterceptorManager.prototype.use = function use(fulfilled, rejected, options) {
      this.handlers.push({
        fulfilled: fulfilled,
        rejected: rejected,
        synchronous: options ? options.synchronous : false,
        runWhen: options ? options.runWhen : null
      });
      return this.handlers.length - 1;
    };

    /**
     * Remove an interceptor from the stack
     *
     * @param {Number} id The ID that was returned by `use`
     */
    InterceptorManager.prototype.eject = function eject(id) {
      if (this.handlers[id]) {
        this.handlers[id] = null;
      }
    };

    /**
     * Iterate over all the registered interceptors
     *
     * This method is particularly useful for skipping over any
     * interceptors that may have become `null` calling `eject`.
     *
     * @param {Function} fn The function to call for each interceptor
     */
    InterceptorManager.prototype.forEach = function forEach(fn) {
      utils.forEach(this.handlers, function forEachHandler(h) {
        if (h !== null) {
          fn(h);
        }
      });
    };

    var InterceptorManager_1 = InterceptorManager;

    var normalizeHeaderName = function normalizeHeaderName(headers, normalizedName) {
      utils.forEach(headers, function processHeader(value, name) {
        if (name !== normalizedName && name.toUpperCase() === normalizedName.toUpperCase()) {
          headers[normalizedName] = value;
          delete headers[name];
        }
      });
    };

    /**
     * Create an Error with the specified message, config, error code, request and response.
     *
     * @param {string} message The error message.
     * @param {string} [code] The error code (for example, 'ECONNABORTED').
     * @param {Object} [config] The config.
     * @param {Object} [request] The request.
     * @param {Object} [response] The response.
     * @returns {Error} The created error.
     */
    function AxiosError(message, code, config, request, response) {
      Error.call(this);
      this.message = message;
      this.name = 'AxiosError';
      code && (this.code = code);
      config && (this.config = config);
      request && (this.request = request);
      response && (this.response = response);
    }

    utils.inherits(AxiosError, Error, {
      toJSON: function toJSON() {
        return {
          // Standard
          message: this.message,
          name: this.name,
          // Microsoft
          description: this.description,
          number: this.number,
          // Mozilla
          fileName: this.fileName,
          lineNumber: this.lineNumber,
          columnNumber: this.columnNumber,
          stack: this.stack,
          // Axios
          config: this.config,
          code: this.code,
          status: this.response && this.response.status ? this.response.status : null
        };
      }
    });

    var prototype = AxiosError.prototype;
    var descriptors = {};

    [
      'ERR_BAD_OPTION_VALUE',
      'ERR_BAD_OPTION',
      'ECONNABORTED',
      'ETIMEDOUT',
      'ERR_NETWORK',
      'ERR_FR_TOO_MANY_REDIRECTS',
      'ERR_DEPRECATED',
      'ERR_BAD_RESPONSE',
      'ERR_BAD_REQUEST',
      'ERR_CANCELED'
    // eslint-disable-next-line func-names
    ].forEach(function(code) {
      descriptors[code] = {value: code};
    });

    Object.defineProperties(AxiosError, descriptors);
    Object.defineProperty(prototype, 'isAxiosError', {value: true});

    // eslint-disable-next-line func-names
    AxiosError.from = function(error, code, config, request, response, customProps) {
      var axiosError = Object.create(prototype);

      utils.toFlatObject(error, axiosError, function filter(obj) {
        return obj !== Error.prototype;
      });

      AxiosError.call(axiosError, error.message, code, config, request, response);

      axiosError.name = error.name;

      customProps && Object.assign(axiosError, customProps);

      return axiosError;
    };

    var AxiosError_1 = AxiosError;

    var transitional = {
      silentJSONParsing: true,
      forcedJSONParsing: true,
      clarifyTimeoutError: false
    };

    /**
     * Convert a data object to FormData
     * @param {Object} obj
     * @param {?Object} [formData]
     * @returns {Object}
     **/

    function toFormData(obj, formData) {
      // eslint-disable-next-line no-param-reassign
      formData = formData || new FormData();

      var stack = [];

      function convertValue(value) {
        if (value === null) return '';

        if (utils.isDate(value)) {
          return value.toISOString();
        }

        if (utils.isArrayBuffer(value) || utils.isTypedArray(value)) {
          return typeof Blob === 'function' ? new Blob([value]) : Buffer.from(value);
        }

        return value;
      }

      function build(data, parentKey) {
        if (utils.isPlainObject(data) || utils.isArray(data)) {
          if (stack.indexOf(data) !== -1) {
            throw Error('Circular reference detected in ' + parentKey);
          }

          stack.push(data);

          utils.forEach(data, function each(value, key) {
            if (utils.isUndefined(value)) return;
            var fullKey = parentKey ? parentKey + '.' + key : key;
            var arr;

            if (value && !parentKey && typeof value === 'object') {
              if (utils.endsWith(key, '{}')) {
                // eslint-disable-next-line no-param-reassign
                value = JSON.stringify(value);
              } else if (utils.endsWith(key, '[]') && (arr = utils.toArray(value))) {
                // eslint-disable-next-line func-names
                arr.forEach(function(el) {
                  !utils.isUndefined(el) && formData.append(fullKey, convertValue(el));
                });
                return;
              }
            }

            build(value, fullKey);
          });

          stack.pop();
        } else {
          formData.append(parentKey, convertValue(data));
        }
      }

      build(obj);

      return formData;
    }

    var toFormData_1 = toFormData;

    /**
     * Resolve or reject a Promise based on response status.
     *
     * @param {Function} resolve A function that resolves the promise.
     * @param {Function} reject A function that rejects the promise.
     * @param {object} response The response.
     */
    var settle = function settle(resolve, reject, response) {
      var validateStatus = response.config.validateStatus;
      if (!response.status || !validateStatus || validateStatus(response.status)) {
        resolve(response);
      } else {
        reject(new AxiosError_1(
          'Request failed with status code ' + response.status,
          [AxiosError_1.ERR_BAD_REQUEST, AxiosError_1.ERR_BAD_RESPONSE][Math.floor(response.status / 100) - 4],
          response.config,
          response.request,
          response
        ));
      }
    };

    var cookies = (
      utils.isStandardBrowserEnv() ?

      // Standard browser envs support document.cookie
        (function standardBrowserEnv() {
          return {
            write: function write(name, value, expires, path, domain, secure) {
              var cookie = [];
              cookie.push(name + '=' + encodeURIComponent(value));

              if (utils.isNumber(expires)) {
                cookie.push('expires=' + new Date(expires).toGMTString());
              }

              if (utils.isString(path)) {
                cookie.push('path=' + path);
              }

              if (utils.isString(domain)) {
                cookie.push('domain=' + domain);
              }

              if (secure === true) {
                cookie.push('secure');
              }

              document.cookie = cookie.join('; ');
            },

            read: function read(name) {
              var match = document.cookie.match(new RegExp('(^|;\\s*)(' + name + ')=([^;]*)'));
              return (match ? decodeURIComponent(match[3]) : null);
            },

            remove: function remove(name) {
              this.write(name, '', Date.now() - 86400000);
            }
          };
        })() :

      // Non standard browser env (web workers, react-native) lack needed support.
        (function nonStandardBrowserEnv() {
          return {
            write: function write() {},
            read: function read() { return null; },
            remove: function remove() {}
          };
        })()
    );

    /**
     * Determines whether the specified URL is absolute
     *
     * @param {string} url The URL to test
     * @returns {boolean} True if the specified URL is absolute, otherwise false
     */
    var isAbsoluteURL = function isAbsoluteURL(url) {
      // A URL is considered absolute if it begins with "<scheme>://" or "//" (protocol-relative URL).
      // RFC 3986 defines scheme name as a sequence of characters beginning with a letter and followed
      // by any combination of letters, digits, plus, period, or hyphen.
      return /^([a-z][a-z\d+\-.]*:)?\/\//i.test(url);
    };

    /**
     * Creates a new URL by combining the specified URLs
     *
     * @param {string} baseURL The base URL
     * @param {string} relativeURL The relative URL
     * @returns {string} The combined URL
     */
    var combineURLs = function combineURLs(baseURL, relativeURL) {
      return relativeURL
        ? baseURL.replace(/\/+$/, '') + '/' + relativeURL.replace(/^\/+/, '')
        : baseURL;
    };

    /**
     * Creates a new URL by combining the baseURL with the requestedURL,
     * only when the requestedURL is not already an absolute URL.
     * If the requestURL is absolute, this function returns the requestedURL untouched.
     *
     * @param {string} baseURL The base URL
     * @param {string} requestedURL Absolute or relative URL to combine
     * @returns {string} The combined full path
     */
    var buildFullPath = function buildFullPath(baseURL, requestedURL) {
      if (baseURL && !isAbsoluteURL(requestedURL)) {
        return combineURLs(baseURL, requestedURL);
      }
      return requestedURL;
    };

    // Headers whose duplicates are ignored by node
    // c.f. https://nodejs.org/api/http.html#http_message_headers
    var ignoreDuplicateOf = [
      'age', 'authorization', 'content-length', 'content-type', 'etag',
      'expires', 'from', 'host', 'if-modified-since', 'if-unmodified-since',
      'last-modified', 'location', 'max-forwards', 'proxy-authorization',
      'referer', 'retry-after', 'user-agent'
    ];

    /**
     * Parse headers into an object
     *
     * ```
     * Date: Wed, 27 Aug 2014 08:58:49 GMT
     * Content-Type: application/json
     * Connection: keep-alive
     * Transfer-Encoding: chunked
     * ```
     *
     * @param {String} headers Headers needing to be parsed
     * @returns {Object} Headers parsed into an object
     */
    var parseHeaders = function parseHeaders(headers) {
      var parsed = {};
      var key;
      var val;
      var i;

      if (!headers) { return parsed; }

      utils.forEach(headers.split('\n'), function parser(line) {
        i = line.indexOf(':');
        key = utils.trim(line.substr(0, i)).toLowerCase();
        val = utils.trim(line.substr(i + 1));

        if (key) {
          if (parsed[key] && ignoreDuplicateOf.indexOf(key) >= 0) {
            return;
          }
          if (key === 'set-cookie') {
            parsed[key] = (parsed[key] ? parsed[key] : []).concat([val]);
          } else {
            parsed[key] = parsed[key] ? parsed[key] + ', ' + val : val;
          }
        }
      });

      return parsed;
    };

    var isURLSameOrigin = (
      utils.isStandardBrowserEnv() ?

      // Standard browser envs have full support of the APIs needed to test
      // whether the request URL is of the same origin as current location.
        (function standardBrowserEnv() {
          var msie = /(msie|trident)/i.test(navigator.userAgent);
          var urlParsingNode = document.createElement('a');
          var originURL;

          /**
        * Parse a URL to discover it's components
        *
        * @param {String} url The URL to be parsed
        * @returns {Object}
        */
          function resolveURL(url) {
            var href = url;

            if (msie) {
            // IE needs attribute set twice to normalize properties
              urlParsingNode.setAttribute('href', href);
              href = urlParsingNode.href;
            }

            urlParsingNode.setAttribute('href', href);

            // urlParsingNode provides the UrlUtils interface - http://url.spec.whatwg.org/#urlutils
            return {
              href: urlParsingNode.href,
              protocol: urlParsingNode.protocol ? urlParsingNode.protocol.replace(/:$/, '') : '',
              host: urlParsingNode.host,
              search: urlParsingNode.search ? urlParsingNode.search.replace(/^\?/, '') : '',
              hash: urlParsingNode.hash ? urlParsingNode.hash.replace(/^#/, '') : '',
              hostname: urlParsingNode.hostname,
              port: urlParsingNode.port,
              pathname: (urlParsingNode.pathname.charAt(0) === '/') ?
                urlParsingNode.pathname :
                '/' + urlParsingNode.pathname
            };
          }

          originURL = resolveURL(window.location.href);

          /**
        * Determine if a URL shares the same origin as the current location
        *
        * @param {String} requestURL The URL to test
        * @returns {boolean} True if URL shares the same origin, otherwise false
        */
          return function isURLSameOrigin(requestURL) {
            var parsed = (utils.isString(requestURL)) ? resolveURL(requestURL) : requestURL;
            return (parsed.protocol === originURL.protocol &&
                parsed.host === originURL.host);
          };
        })() :

      // Non standard browser envs (web workers, react-native) lack needed support.
        (function nonStandardBrowserEnv() {
          return function isURLSameOrigin() {
            return true;
          };
        })()
    );

    /**
     * A `CanceledError` is an object that is thrown when an operation is canceled.
     *
     * @class
     * @param {string=} message The message.
     */
    function CanceledError(message) {
      // eslint-disable-next-line no-eq-null,eqeqeq
      AxiosError_1.call(this, message == null ? 'canceled' : message, AxiosError_1.ERR_CANCELED);
      this.name = 'CanceledError';
    }

    utils.inherits(CanceledError, AxiosError_1, {
      __CANCEL__: true
    });

    var CanceledError_1 = CanceledError;

    var parseProtocol = function parseProtocol(url) {
      var match = /^([-+\w]{1,25})(:?\/\/|:)/.exec(url);
      return match && match[1] || '';
    };

    var xhr = function xhrAdapter(config) {
      return new Promise(function dispatchXhrRequest(resolve, reject) {
        var requestData = config.data;
        var requestHeaders = config.headers;
        var responseType = config.responseType;
        var onCanceled;
        function done() {
          if (config.cancelToken) {
            config.cancelToken.unsubscribe(onCanceled);
          }

          if (config.signal) {
            config.signal.removeEventListener('abort', onCanceled);
          }
        }

        if (utils.isFormData(requestData) && utils.isStandardBrowserEnv()) {
          delete requestHeaders['Content-Type']; // Let the browser set it
        }

        var request = new XMLHttpRequest();

        // HTTP basic authentication
        if (config.auth) {
          var username = config.auth.username || '';
          var password = config.auth.password ? unescape(encodeURIComponent(config.auth.password)) : '';
          requestHeaders.Authorization = 'Basic ' + btoa(username + ':' + password);
        }

        var fullPath = buildFullPath(config.baseURL, config.url);

        request.open(config.method.toUpperCase(), buildURL(fullPath, config.params, config.paramsSerializer), true);

        // Set the request timeout in MS
        request.timeout = config.timeout;

        function onloadend() {
          if (!request) {
            return;
          }
          // Prepare the response
          var responseHeaders = 'getAllResponseHeaders' in request ? parseHeaders(request.getAllResponseHeaders()) : null;
          var responseData = !responseType || responseType === 'text' ||  responseType === 'json' ?
            request.responseText : request.response;
          var response = {
            data: responseData,
            status: request.status,
            statusText: request.statusText,
            headers: responseHeaders,
            config: config,
            request: request
          };

          settle(function _resolve(value) {
            resolve(value);
            done();
          }, function _reject(err) {
            reject(err);
            done();
          }, response);

          // Clean up request
          request = null;
        }

        if ('onloadend' in request) {
          // Use onloadend if available
          request.onloadend = onloadend;
        } else {
          // Listen for ready state to emulate onloadend
          request.onreadystatechange = function handleLoad() {
            if (!request || request.readyState !== 4) {
              return;
            }

            // The request errored out and we didn't get a response, this will be
            // handled by onerror instead
            // With one exception: request that using file: protocol, most browsers
            // will return status as 0 even though it's a successful request
            if (request.status === 0 && !(request.responseURL && request.responseURL.indexOf('file:') === 0)) {
              return;
            }
            // readystate handler is calling before onerror or ontimeout handlers,
            // so we should call onloadend on the next 'tick'
            setTimeout(onloadend);
          };
        }

        // Handle browser request cancellation (as opposed to a manual cancellation)
        request.onabort = function handleAbort() {
          if (!request) {
            return;
          }

          reject(new AxiosError_1('Request aborted', AxiosError_1.ECONNABORTED, config, request));

          // Clean up request
          request = null;
        };

        // Handle low level network errors
        request.onerror = function handleError() {
          // Real errors are hidden from us by the browser
          // onerror should only fire if it's a network error
          reject(new AxiosError_1('Network Error', AxiosError_1.ERR_NETWORK, config, request, request));

          // Clean up request
          request = null;
        };

        // Handle timeout
        request.ontimeout = function handleTimeout() {
          var timeoutErrorMessage = config.timeout ? 'timeout of ' + config.timeout + 'ms exceeded' : 'timeout exceeded';
          var transitional$1 = config.transitional || transitional;
          if (config.timeoutErrorMessage) {
            timeoutErrorMessage = config.timeoutErrorMessage;
          }
          reject(new AxiosError_1(
            timeoutErrorMessage,
            transitional$1.clarifyTimeoutError ? AxiosError_1.ETIMEDOUT : AxiosError_1.ECONNABORTED,
            config,
            request));

          // Clean up request
          request = null;
        };

        // Add xsrf header
        // This is only done if running in a standard browser environment.
        // Specifically not if we're in a web worker, or react-native.
        if (utils.isStandardBrowserEnv()) {
          // Add xsrf header
          var xsrfValue = (config.withCredentials || isURLSameOrigin(fullPath)) && config.xsrfCookieName ?
            cookies.read(config.xsrfCookieName) :
            undefined;

          if (xsrfValue) {
            requestHeaders[config.xsrfHeaderName] = xsrfValue;
          }
        }

        // Add headers to the request
        if ('setRequestHeader' in request) {
          utils.forEach(requestHeaders, function setRequestHeader(val, key) {
            if (typeof requestData === 'undefined' && key.toLowerCase() === 'content-type') {
              // Remove Content-Type if data is undefined
              delete requestHeaders[key];
            } else {
              // Otherwise add header to the request
              request.setRequestHeader(key, val);
            }
          });
        }

        // Add withCredentials to request if needed
        if (!utils.isUndefined(config.withCredentials)) {
          request.withCredentials = !!config.withCredentials;
        }

        // Add responseType to request if needed
        if (responseType && responseType !== 'json') {
          request.responseType = config.responseType;
        }

        // Handle progress if needed
        if (typeof config.onDownloadProgress === 'function') {
          request.addEventListener('progress', config.onDownloadProgress);
        }

        // Not all browsers support upload events
        if (typeof config.onUploadProgress === 'function' && request.upload) {
          request.upload.addEventListener('progress', config.onUploadProgress);
        }

        if (config.cancelToken || config.signal) {
          // Handle cancellation
          // eslint-disable-next-line func-names
          onCanceled = function(cancel) {
            if (!request) {
              return;
            }
            reject(!cancel || (cancel && cancel.type) ? new CanceledError_1() : cancel);
            request.abort();
            request = null;
          };

          config.cancelToken && config.cancelToken.subscribe(onCanceled);
          if (config.signal) {
            config.signal.aborted ? onCanceled() : config.signal.addEventListener('abort', onCanceled);
          }
        }

        if (!requestData) {
          requestData = null;
        }

        var protocol = parseProtocol(fullPath);

        if (protocol && [ 'http', 'https', 'file' ].indexOf(protocol) === -1) {
          reject(new AxiosError_1('Unsupported protocol ' + protocol + ':', AxiosError_1.ERR_BAD_REQUEST, config));
          return;
        }


        // Send the request
        request.send(requestData);
      });
    };

    // eslint-disable-next-line strict
    var _null = null;

    var DEFAULT_CONTENT_TYPE = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    function setContentTypeIfUnset(headers, value) {
      if (!utils.isUndefined(headers) && utils.isUndefined(headers['Content-Type'])) {
        headers['Content-Type'] = value;
      }
    }

    function getDefaultAdapter() {
      var adapter;
      if (typeof XMLHttpRequest !== 'undefined') {
        // For browsers use XHR adapter
        adapter = xhr;
      } else if (typeof process !== 'undefined' && Object.prototype.toString.call(process) === '[object process]') {
        // For node use HTTP adapter
        adapter = xhr;
      }
      return adapter;
    }

    function stringifySafely(rawValue, parser, encoder) {
      if (utils.isString(rawValue)) {
        try {
          (parser || JSON.parse)(rawValue);
          return utils.trim(rawValue);
        } catch (e) {
          if (e.name !== 'SyntaxError') {
            throw e;
          }
        }
      }

      return (encoder || JSON.stringify)(rawValue);
    }

    var defaults = {

      transitional: transitional,

      adapter: getDefaultAdapter(),

      transformRequest: [function transformRequest(data, headers) {
        normalizeHeaderName(headers, 'Accept');
        normalizeHeaderName(headers, 'Content-Type');

        if (utils.isFormData(data) ||
          utils.isArrayBuffer(data) ||
          utils.isBuffer(data) ||
          utils.isStream(data) ||
          utils.isFile(data) ||
          utils.isBlob(data)
        ) {
          return data;
        }
        if (utils.isArrayBufferView(data)) {
          return data.buffer;
        }
        if (utils.isURLSearchParams(data)) {
          setContentTypeIfUnset(headers, 'application/x-www-form-urlencoded;charset=utf-8');
          return data.toString();
        }

        var isObjectPayload = utils.isObject(data);
        var contentType = headers && headers['Content-Type'];

        var isFileList;

        if ((isFileList = utils.isFileList(data)) || (isObjectPayload && contentType === 'multipart/form-data')) {
          var _FormData = this.env && this.env.FormData;
          return toFormData_1(isFileList ? {'files[]': data} : data, _FormData && new _FormData());
        } else if (isObjectPayload || contentType === 'application/json') {
          setContentTypeIfUnset(headers, 'application/json');
          return stringifySafely(data);
        }

        return data;
      }],

      transformResponse: [function transformResponse(data) {
        var transitional = this.transitional || defaults.transitional;
        var silentJSONParsing = transitional && transitional.silentJSONParsing;
        var forcedJSONParsing = transitional && transitional.forcedJSONParsing;
        var strictJSONParsing = !silentJSONParsing && this.responseType === 'json';

        if (strictJSONParsing || (forcedJSONParsing && utils.isString(data) && data.length)) {
          try {
            return JSON.parse(data);
          } catch (e) {
            if (strictJSONParsing) {
              if (e.name === 'SyntaxError') {
                throw AxiosError_1.from(e, AxiosError_1.ERR_BAD_RESPONSE, this, null, this.response);
              }
              throw e;
            }
          }
        }

        return data;
      }],

      /**
       * A timeout in milliseconds to abort a request. If set to 0 (default) a
       * timeout is not created.
       */
      timeout: 0,

      xsrfCookieName: 'XSRF-TOKEN',
      xsrfHeaderName: 'X-XSRF-TOKEN',

      maxContentLength: -1,
      maxBodyLength: -1,

      env: {
        FormData: _null
      },

      validateStatus: function validateStatus(status) {
        return status >= 200 && status < 300;
      },

      headers: {
        common: {
          'Accept': 'application/json, text/plain, */*'
        }
      }
    };

    utils.forEach(['delete', 'get', 'head'], function forEachMethodNoData(method) {
      defaults.headers[method] = {};
    });

    utils.forEach(['post', 'put', 'patch'], function forEachMethodWithData(method) {
      defaults.headers[method] = utils.merge(DEFAULT_CONTENT_TYPE);
    });

    var defaults_1 = defaults;

    /**
     * Transform the data for a request or a response
     *
     * @param {Object|String} data The data to be transformed
     * @param {Array} headers The headers for the request or response
     * @param {Array|Function} fns A single function or Array of functions
     * @returns {*} The resulting transformed data
     */
    var transformData = function transformData(data, headers, fns) {
      var context = this || defaults_1;
      /*eslint no-param-reassign:0*/
      utils.forEach(fns, function transform(fn) {
        data = fn.call(context, data, headers);
      });

      return data;
    };

    var isCancel = function isCancel(value) {
      return !!(value && value.__CANCEL__);
    };

    /**
     * Throws a `CanceledError` if cancellation has been requested.
     */
    function throwIfCancellationRequested(config) {
      if (config.cancelToken) {
        config.cancelToken.throwIfRequested();
      }

      if (config.signal && config.signal.aborted) {
        throw new CanceledError_1();
      }
    }

    /**
     * Dispatch a request to the server using the configured adapter.
     *
     * @param {object} config The config that is to be used for the request
     * @returns {Promise} The Promise to be fulfilled
     */
    var dispatchRequest = function dispatchRequest(config) {
      throwIfCancellationRequested(config);

      // Ensure headers exist
      config.headers = config.headers || {};

      // Transform request data
      config.data = transformData.call(
        config,
        config.data,
        config.headers,
        config.transformRequest
      );

      // Flatten headers
      config.headers = utils.merge(
        config.headers.common || {},
        config.headers[config.method] || {},
        config.headers
      );

      utils.forEach(
        ['delete', 'get', 'head', 'post', 'put', 'patch', 'common'],
        function cleanHeaderConfig(method) {
          delete config.headers[method];
        }
      );

      var adapter = config.adapter || defaults_1.adapter;

      return adapter(config).then(function onAdapterResolution(response) {
        throwIfCancellationRequested(config);

        // Transform response data
        response.data = transformData.call(
          config,
          response.data,
          response.headers,
          config.transformResponse
        );

        return response;
      }, function onAdapterRejection(reason) {
        if (!isCancel(reason)) {
          throwIfCancellationRequested(config);

          // Transform response data
          if (reason && reason.response) {
            reason.response.data = transformData.call(
              config,
              reason.response.data,
              reason.response.headers,
              config.transformResponse
            );
          }
        }

        return Promise.reject(reason);
      });
    };

    /**
     * Config-specific merge-function which creates a new config-object
     * by merging two configuration objects together.
     *
     * @param {Object} config1
     * @param {Object} config2
     * @returns {Object} New object resulting from merging config2 to config1
     */
    var mergeConfig = function mergeConfig(config1, config2) {
      // eslint-disable-next-line no-param-reassign
      config2 = config2 || {};
      var config = {};

      function getMergedValue(target, source) {
        if (utils.isPlainObject(target) && utils.isPlainObject(source)) {
          return utils.merge(target, source);
        } else if (utils.isPlainObject(source)) {
          return utils.merge({}, source);
        } else if (utils.isArray(source)) {
          return source.slice();
        }
        return source;
      }

      // eslint-disable-next-line consistent-return
      function mergeDeepProperties(prop) {
        if (!utils.isUndefined(config2[prop])) {
          return getMergedValue(config1[prop], config2[prop]);
        } else if (!utils.isUndefined(config1[prop])) {
          return getMergedValue(undefined, config1[prop]);
        }
      }

      // eslint-disable-next-line consistent-return
      function valueFromConfig2(prop) {
        if (!utils.isUndefined(config2[prop])) {
          return getMergedValue(undefined, config2[prop]);
        }
      }

      // eslint-disable-next-line consistent-return
      function defaultToConfig2(prop) {
        if (!utils.isUndefined(config2[prop])) {
          return getMergedValue(undefined, config2[prop]);
        } else if (!utils.isUndefined(config1[prop])) {
          return getMergedValue(undefined, config1[prop]);
        }
      }

      // eslint-disable-next-line consistent-return
      function mergeDirectKeys(prop) {
        if (prop in config2) {
          return getMergedValue(config1[prop], config2[prop]);
        } else if (prop in config1) {
          return getMergedValue(undefined, config1[prop]);
        }
      }

      var mergeMap = {
        'url': valueFromConfig2,
        'method': valueFromConfig2,
        'data': valueFromConfig2,
        'baseURL': defaultToConfig2,
        'transformRequest': defaultToConfig2,
        'transformResponse': defaultToConfig2,
        'paramsSerializer': defaultToConfig2,
        'timeout': defaultToConfig2,
        'timeoutMessage': defaultToConfig2,
        'withCredentials': defaultToConfig2,
        'adapter': defaultToConfig2,
        'responseType': defaultToConfig2,
        'xsrfCookieName': defaultToConfig2,
        'xsrfHeaderName': defaultToConfig2,
        'onUploadProgress': defaultToConfig2,
        'onDownloadProgress': defaultToConfig2,
        'decompress': defaultToConfig2,
        'maxContentLength': defaultToConfig2,
        'maxBodyLength': defaultToConfig2,
        'beforeRedirect': defaultToConfig2,
        'transport': defaultToConfig2,
        'httpAgent': defaultToConfig2,
        'httpsAgent': defaultToConfig2,
        'cancelToken': defaultToConfig2,
        'socketPath': defaultToConfig2,
        'responseEncoding': defaultToConfig2,
        'validateStatus': mergeDirectKeys
      };

      utils.forEach(Object.keys(config1).concat(Object.keys(config2)), function computeConfigValue(prop) {
        var merge = mergeMap[prop] || mergeDeepProperties;
        var configValue = merge(prop);
        (utils.isUndefined(configValue) && merge !== mergeDirectKeys) || (config[prop] = configValue);
      });

      return config;
    };

    var data = {
      "version": "0.27.2"
    };

    var VERSION = data.version;


    var validators$1 = {};

    // eslint-disable-next-line func-names
    ['object', 'boolean', 'number', 'function', 'string', 'symbol'].forEach(function(type, i) {
      validators$1[type] = function validator(thing) {
        return typeof thing === type || 'a' + (i < 1 ? 'n ' : ' ') + type;
      };
    });

    var deprecatedWarnings = {};

    /**
     * Transitional option validator
     * @param {function|boolean?} validator - set to false if the transitional option has been removed
     * @param {string?} version - deprecated version / removed since version
     * @param {string?} message - some message with additional info
     * @returns {function}
     */
    validators$1.transitional = function transitional(validator, version, message) {
      function formatMessage(opt, desc) {
        return '[Axios v' + VERSION + '] Transitional option \'' + opt + '\'' + desc + (message ? '. ' + message : '');
      }

      // eslint-disable-next-line func-names
      return function(value, opt, opts) {
        if (validator === false) {
          throw new AxiosError_1(
            formatMessage(opt, ' has been removed' + (version ? ' in ' + version : '')),
            AxiosError_1.ERR_DEPRECATED
          );
        }

        if (version && !deprecatedWarnings[opt]) {
          deprecatedWarnings[opt] = true;
          // eslint-disable-next-line no-console
          console.warn(
            formatMessage(
              opt,
              ' has been deprecated since v' + version + ' and will be removed in the near future'
            )
          );
        }

        return validator ? validator(value, opt, opts) : true;
      };
    };

    /**
     * Assert object's properties type
     * @param {object} options
     * @param {object} schema
     * @param {boolean?} allowUnknown
     */

    function assertOptions(options, schema, allowUnknown) {
      if (typeof options !== 'object') {
        throw new AxiosError_1('options must be an object', AxiosError_1.ERR_BAD_OPTION_VALUE);
      }
      var keys = Object.keys(options);
      var i = keys.length;
      while (i-- > 0) {
        var opt = keys[i];
        var validator = schema[opt];
        if (validator) {
          var value = options[opt];
          var result = value === undefined || validator(value, opt, options);
          if (result !== true) {
            throw new AxiosError_1('option ' + opt + ' must be ' + result, AxiosError_1.ERR_BAD_OPTION_VALUE);
          }
          continue;
        }
        if (allowUnknown !== true) {
          throw new AxiosError_1('Unknown option ' + opt, AxiosError_1.ERR_BAD_OPTION);
        }
      }
    }

    var validator = {
      assertOptions: assertOptions,
      validators: validators$1
    };

    var validators = validator.validators;
    /**
     * Create a new instance of Axios
     *
     * @param {Object} instanceConfig The default config for the instance
     */
    function Axios(instanceConfig) {
      this.defaults = instanceConfig;
      this.interceptors = {
        request: new InterceptorManager_1(),
        response: new InterceptorManager_1()
      };
    }

    /**
     * Dispatch a request
     *
     * @param {Object} config The config specific for this request (merged with this.defaults)
     */
    Axios.prototype.request = function request(configOrUrl, config) {
      /*eslint no-param-reassign:0*/
      // Allow for axios('example/url'[, config]) a la fetch API
      if (typeof configOrUrl === 'string') {
        config = config || {};
        config.url = configOrUrl;
      } else {
        config = configOrUrl || {};
      }

      config = mergeConfig(this.defaults, config);

      // Set config.method
      if (config.method) {
        config.method = config.method.toLowerCase();
      } else if (this.defaults.method) {
        config.method = this.defaults.method.toLowerCase();
      } else {
        config.method = 'get';
      }

      var transitional = config.transitional;

      if (transitional !== undefined) {
        validator.assertOptions(transitional, {
          silentJSONParsing: validators.transitional(validators.boolean),
          forcedJSONParsing: validators.transitional(validators.boolean),
          clarifyTimeoutError: validators.transitional(validators.boolean)
        }, false);
      }

      // filter out skipped interceptors
      var requestInterceptorChain = [];
      var synchronousRequestInterceptors = true;
      this.interceptors.request.forEach(function unshiftRequestInterceptors(interceptor) {
        if (typeof interceptor.runWhen === 'function' && interceptor.runWhen(config) === false) {
          return;
        }

        synchronousRequestInterceptors = synchronousRequestInterceptors && interceptor.synchronous;

        requestInterceptorChain.unshift(interceptor.fulfilled, interceptor.rejected);
      });

      var responseInterceptorChain = [];
      this.interceptors.response.forEach(function pushResponseInterceptors(interceptor) {
        responseInterceptorChain.push(interceptor.fulfilled, interceptor.rejected);
      });

      var promise;

      if (!synchronousRequestInterceptors) {
        var chain = [dispatchRequest, undefined];

        Array.prototype.unshift.apply(chain, requestInterceptorChain);
        chain = chain.concat(responseInterceptorChain);

        promise = Promise.resolve(config);
        while (chain.length) {
          promise = promise.then(chain.shift(), chain.shift());
        }

        return promise;
      }


      var newConfig = config;
      while (requestInterceptorChain.length) {
        var onFulfilled = requestInterceptorChain.shift();
        var onRejected = requestInterceptorChain.shift();
        try {
          newConfig = onFulfilled(newConfig);
        } catch (error) {
          onRejected(error);
          break;
        }
      }

      try {
        promise = dispatchRequest(newConfig);
      } catch (error) {
        return Promise.reject(error);
      }

      while (responseInterceptorChain.length) {
        promise = promise.then(responseInterceptorChain.shift(), responseInterceptorChain.shift());
      }

      return promise;
    };

    Axios.prototype.getUri = function getUri(config) {
      config = mergeConfig(this.defaults, config);
      var fullPath = buildFullPath(config.baseURL, config.url);
      return buildURL(fullPath, config.params, config.paramsSerializer);
    };

    // Provide aliases for supported request methods
    utils.forEach(['delete', 'get', 'head', 'options'], function forEachMethodNoData(method) {
      /*eslint func-names:0*/
      Axios.prototype[method] = function(url, config) {
        return this.request(mergeConfig(config || {}, {
          method: method,
          url: url,
          data: (config || {}).data
        }));
      };
    });

    utils.forEach(['post', 'put', 'patch'], function forEachMethodWithData(method) {
      /*eslint func-names:0*/

      function generateHTTPMethod(isForm) {
        return function httpMethod(url, data, config) {
          return this.request(mergeConfig(config || {}, {
            method: method,
            headers: isForm ? {
              'Content-Type': 'multipart/form-data'
            } : {},
            url: url,
            data: data
          }));
        };
      }

      Axios.prototype[method] = generateHTTPMethod();

      Axios.prototype[method + 'Form'] = generateHTTPMethod(true);
    });

    var Axios_1 = Axios;

    /**
     * A `CancelToken` is an object that can be used to request cancellation of an operation.
     *
     * @class
     * @param {Function} executor The executor function.
     */
    function CancelToken(executor) {
      if (typeof executor !== 'function') {
        throw new TypeError('executor must be a function.');
      }

      var resolvePromise;

      this.promise = new Promise(function promiseExecutor(resolve) {
        resolvePromise = resolve;
      });

      var token = this;

      // eslint-disable-next-line func-names
      this.promise.then(function(cancel) {
        if (!token._listeners) return;

        var i;
        var l = token._listeners.length;

        for (i = 0; i < l; i++) {
          token._listeners[i](cancel);
        }
        token._listeners = null;
      });

      // eslint-disable-next-line func-names
      this.promise.then = function(onfulfilled) {
        var _resolve;
        // eslint-disable-next-line func-names
        var promise = new Promise(function(resolve) {
          token.subscribe(resolve);
          _resolve = resolve;
        }).then(onfulfilled);

        promise.cancel = function reject() {
          token.unsubscribe(_resolve);
        };

        return promise;
      };

      executor(function cancel(message) {
        if (token.reason) {
          // Cancellation has already been requested
          return;
        }

        token.reason = new CanceledError_1(message);
        resolvePromise(token.reason);
      });
    }

    /**
     * Throws a `CanceledError` if cancellation has been requested.
     */
    CancelToken.prototype.throwIfRequested = function throwIfRequested() {
      if (this.reason) {
        throw this.reason;
      }
    };

    /**
     * Subscribe to the cancel signal
     */

    CancelToken.prototype.subscribe = function subscribe(listener) {
      if (this.reason) {
        listener(this.reason);
        return;
      }

      if (this._listeners) {
        this._listeners.push(listener);
      } else {
        this._listeners = [listener];
      }
    };

    /**
     * Unsubscribe from the cancel signal
     */

    CancelToken.prototype.unsubscribe = function unsubscribe(listener) {
      if (!this._listeners) {
        return;
      }
      var index = this._listeners.indexOf(listener);
      if (index !== -1) {
        this._listeners.splice(index, 1);
      }
    };

    /**
     * Returns an object that contains a new `CancelToken` and a function that, when called,
     * cancels the `CancelToken`.
     */
    CancelToken.source = function source() {
      var cancel;
      var token = new CancelToken(function executor(c) {
        cancel = c;
      });
      return {
        token: token,
        cancel: cancel
      };
    };

    var CancelToken_1 = CancelToken;

    /**
     * Syntactic sugar for invoking a function and expanding an array for arguments.
     *
     * Common use case would be to use `Function.prototype.apply`.
     *
     *  ```js
     *  function f(x, y, z) {}
     *  var args = [1, 2, 3];
     *  f.apply(null, args);
     *  ```
     *
     * With `spread` this example can be re-written.
     *
     *  ```js
     *  spread(function(x, y, z) {})([1, 2, 3]);
     *  ```
     *
     * @param {Function} callback
     * @returns {Function}
     */
    var spread = function spread(callback) {
      return function wrap(arr) {
        return callback.apply(null, arr);
      };
    };

    /**
     * Determines whether the payload is an error thrown by Axios
     *
     * @param {*} payload The value to test
     * @returns {boolean} True if the payload is an error thrown by Axios, otherwise false
     */
    var isAxiosError = function isAxiosError(payload) {
      return utils.isObject(payload) && (payload.isAxiosError === true);
    };

    /**
     * Create an instance of Axios
     *
     * @param {Object} defaultConfig The default config for the instance
     * @return {Axios} A new instance of Axios
     */
    function createInstance(defaultConfig) {
      var context = new Axios_1(defaultConfig);
      var instance = bind(Axios_1.prototype.request, context);

      // Copy axios.prototype to instance
      utils.extend(instance, Axios_1.prototype, context);

      // Copy context to instance
      utils.extend(instance, context);

      // Factory for creating new instances
      instance.create = function create(instanceConfig) {
        return createInstance(mergeConfig(defaultConfig, instanceConfig));
      };

      return instance;
    }

    // Create the default instance to be exported
    var axios$1 = createInstance(defaults_1);

    // Expose Axios class to allow class inheritance
    axios$1.Axios = Axios_1;

    // Expose Cancel & CancelToken
    axios$1.CanceledError = CanceledError_1;
    axios$1.CancelToken = CancelToken_1;
    axios$1.isCancel = isCancel;
    axios$1.VERSION = data.version;
    axios$1.toFormData = toFormData_1;

    // Expose AxiosError class
    axios$1.AxiosError = AxiosError_1;

    // alias for CanceledError for backward compatibility
    axios$1.Cancel = axios$1.CanceledError;

    // Expose all/spread
    axios$1.all = function all(promises) {
      return Promise.all(promises);
    };
    axios$1.spread = spread;

    // Expose isAxiosError
    axios$1.isAxiosError = isAxiosError;

    var axios_1 = axios$1;

    // Allow use of default import syntax in TypeScript
    var _default = axios$1;
    axios_1.default = _default;

    var axios = axios_1;

    var eventemitter3 = createCommonjsModule(function (module) {

    var has = Object.prototype.hasOwnProperty
      , prefix = '~';

    /**
     * Constructor to create a storage for our `EE` objects.
     * An `Events` instance is a plain object whose properties are event names.
     *
     * @constructor
     * @private
     */
    function Events() {}

    //
    // We try to not inherit from `Object.prototype`. In some engines creating an
    // instance in this way is faster than calling `Object.create(null)` directly.
    // If `Object.create(null)` is not supported we prefix the event names with a
    // character to make sure that the built-in object properties are not
    // overridden or used as an attack vector.
    //
    if (Object.create) {
      Events.prototype = Object.create(null);

      //
      // This hack is needed because the `__proto__` property is still inherited in
      // some old browsers like Android 4, iPhone 5.1, Opera 11 and Safari 5.
      //
      if (!new Events().__proto__) prefix = false;
    }

    /**
     * Representation of a single event listener.
     *
     * @param {Function} fn The listener function.
     * @param {*} context The context to invoke the listener with.
     * @param {Boolean} [once=false] Specify if the listener is a one-time listener.
     * @constructor
     * @private
     */
    function EE(fn, context, once) {
      this.fn = fn;
      this.context = context;
      this.once = once || false;
    }

    /**
     * Add a listener for a given event.
     *
     * @param {EventEmitter} emitter Reference to the `EventEmitter` instance.
     * @param {(String|Symbol)} event The event name.
     * @param {Function} fn The listener function.
     * @param {*} context The context to invoke the listener with.
     * @param {Boolean} once Specify if the listener is a one-time listener.
     * @returns {EventEmitter}
     * @private
     */
    function addListener(emitter, event, fn, context, once) {
      if (typeof fn !== 'function') {
        throw new TypeError('The listener must be a function');
      }

      var listener = new EE(fn, context || emitter, once)
        , evt = prefix ? prefix + event : event;

      if (!emitter._events[evt]) emitter._events[evt] = listener, emitter._eventsCount++;
      else if (!emitter._events[evt].fn) emitter._events[evt].push(listener);
      else emitter._events[evt] = [emitter._events[evt], listener];

      return emitter;
    }

    /**
     * Clear event by name.
     *
     * @param {EventEmitter} emitter Reference to the `EventEmitter` instance.
     * @param {(String|Symbol)} evt The Event name.
     * @private
     */
    function clearEvent(emitter, evt) {
      if (--emitter._eventsCount === 0) emitter._events = new Events();
      else delete emitter._events[evt];
    }

    /**
     * Minimal `EventEmitter` interface that is molded against the Node.js
     * `EventEmitter` interface.
     *
     * @constructor
     * @public
     */
    function EventEmitter() {
      this._events = new Events();
      this._eventsCount = 0;
    }

    /**
     * Return an array listing the events for which the emitter has registered
     * listeners.
     *
     * @returns {Array}
     * @public
     */
    EventEmitter.prototype.eventNames = function eventNames() {
      var names = []
        , events
        , name;

      if (this._eventsCount === 0) return names;

      for (name in (events = this._events)) {
        if (has.call(events, name)) names.push(prefix ? name.slice(1) : name);
      }

      if (Object.getOwnPropertySymbols) {
        return names.concat(Object.getOwnPropertySymbols(events));
      }

      return names;
    };

    /**
     * Return the listeners registered for a given event.
     *
     * @param {(String|Symbol)} event The event name.
     * @returns {Array} The registered listeners.
     * @public
     */
    EventEmitter.prototype.listeners = function listeners(event) {
      var evt = prefix ? prefix + event : event
        , handlers = this._events[evt];

      if (!handlers) return [];
      if (handlers.fn) return [handlers.fn];

      for (var i = 0, l = handlers.length, ee = new Array(l); i < l; i++) {
        ee[i] = handlers[i].fn;
      }

      return ee;
    };

    /**
     * Return the number of listeners listening to a given event.
     *
     * @param {(String|Symbol)} event The event name.
     * @returns {Number} The number of listeners.
     * @public
     */
    EventEmitter.prototype.listenerCount = function listenerCount(event) {
      var evt = prefix ? prefix + event : event
        , listeners = this._events[evt];

      if (!listeners) return 0;
      if (listeners.fn) return 1;
      return listeners.length;
    };

    /**
     * Calls each of the listeners registered for a given event.
     *
     * @param {(String|Symbol)} event The event name.
     * @returns {Boolean} `true` if the event had listeners, else `false`.
     * @public
     */
    EventEmitter.prototype.emit = function emit(event, a1, a2, a3, a4, a5) {
      var evt = prefix ? prefix + event : event;

      if (!this._events[evt]) return false;

      var listeners = this._events[evt]
        , len = arguments.length
        , args
        , i;

      if (listeners.fn) {
        if (listeners.once) this.removeListener(event, listeners.fn, undefined, true);

        switch (len) {
          case 1: return listeners.fn.call(listeners.context), true;
          case 2: return listeners.fn.call(listeners.context, a1), true;
          case 3: return listeners.fn.call(listeners.context, a1, a2), true;
          case 4: return listeners.fn.call(listeners.context, a1, a2, a3), true;
          case 5: return listeners.fn.call(listeners.context, a1, a2, a3, a4), true;
          case 6: return listeners.fn.call(listeners.context, a1, a2, a3, a4, a5), true;
        }

        for (i = 1, args = new Array(len -1); i < len; i++) {
          args[i - 1] = arguments[i];
        }

        listeners.fn.apply(listeners.context, args);
      } else {
        var length = listeners.length
          , j;

        for (i = 0; i < length; i++) {
          if (listeners[i].once) this.removeListener(event, listeners[i].fn, undefined, true);

          switch (len) {
            case 1: listeners[i].fn.call(listeners[i].context); break;
            case 2: listeners[i].fn.call(listeners[i].context, a1); break;
            case 3: listeners[i].fn.call(listeners[i].context, a1, a2); break;
            case 4: listeners[i].fn.call(listeners[i].context, a1, a2, a3); break;
            default:
              if (!args) for (j = 1, args = new Array(len -1); j < len; j++) {
                args[j - 1] = arguments[j];
              }

              listeners[i].fn.apply(listeners[i].context, args);
          }
        }
      }

      return true;
    };

    /**
     * Add a listener for a given event.
     *
     * @param {(String|Symbol)} event The event name.
     * @param {Function} fn The listener function.
     * @param {*} [context=this] The context to invoke the listener with.
     * @returns {EventEmitter} `this`.
     * @public
     */
    EventEmitter.prototype.on = function on(event, fn, context) {
      return addListener(this, event, fn, context, false);
    };

    /**
     * Add a one-time listener for a given event.
     *
     * @param {(String|Symbol)} event The event name.
     * @param {Function} fn The listener function.
     * @param {*} [context=this] The context to invoke the listener with.
     * @returns {EventEmitter} `this`.
     * @public
     */
    EventEmitter.prototype.once = function once(event, fn, context) {
      return addListener(this, event, fn, context, true);
    };

    /**
     * Remove the listeners of a given event.
     *
     * @param {(String|Symbol)} event The event name.
     * @param {Function} fn Only remove the listeners that match this function.
     * @param {*} context Only remove the listeners that have this context.
     * @param {Boolean} once Only remove one-time listeners.
     * @returns {EventEmitter} `this`.
     * @public
     */
    EventEmitter.prototype.removeListener = function removeListener(event, fn, context, once) {
      var evt = prefix ? prefix + event : event;

      if (!this._events[evt]) return this;
      if (!fn) {
        clearEvent(this, evt);
        return this;
      }

      var listeners = this._events[evt];

      if (listeners.fn) {
        if (
          listeners.fn === fn &&
          (!once || listeners.once) &&
          (!context || listeners.context === context)
        ) {
          clearEvent(this, evt);
        }
      } else {
        for (var i = 0, events = [], length = listeners.length; i < length; i++) {
          if (
            listeners[i].fn !== fn ||
            (once && !listeners[i].once) ||
            (context && listeners[i].context !== context)
          ) {
            events.push(listeners[i]);
          }
        }

        //
        // Reset the array, or remove it completely if we have no more listeners.
        //
        if (events.length) this._events[evt] = events.length === 1 ? events[0] : events;
        else clearEvent(this, evt);
      }

      return this;
    };

    /**
     * Remove all listeners, or those of the specified event.
     *
     * @param {(String|Symbol)} [event] The event name.
     * @returns {EventEmitter} `this`.
     * @public
     */
    EventEmitter.prototype.removeAllListeners = function removeAllListeners(event) {
      var evt;

      if (event) {
        evt = prefix ? prefix + event : event;
        if (this._events[evt]) clearEvent(this, evt);
      } else {
        this._events = new Events();
        this._eventsCount = 0;
      }

      return this;
    };

    //
    // Alias methods names because people roll like that.
    //
    EventEmitter.prototype.off = EventEmitter.prototype.removeListener;
    EventEmitter.prototype.addListener = EventEmitter.prototype.on;

    //
    // Expose the prefix.
    //
    EventEmitter.prefixed = prefix;

    //
    // Allow `EventEmitter` to be imported as module namespace.
    //
    EventEmitter.EventEmitter = EventEmitter;

    //
    // Expose the module.
    //
    {
      module.exports = EventEmitter;
    }
    });

    var index_cjs = createCommonjsModule(function (module, exports) {

    Object.defineProperty(exports, '__esModule', { value: true });




    function _interopDefaultLegacy (e) { return e && typeof e === 'object' && 'default' in e ? e : { 'default': e }; }

    var axios__default = /*#__PURE__*/_interopDefaultLegacy(axios);
    var EventEmitter__default = /*#__PURE__*/_interopDefaultLegacy(eventemitter3);

    /******************************************************************************
    Copyright (c) Microsoft Corporation.

    Permission to use, copy, modify, and/or distribute this software for any
    purpose with or without fee is hereby granted.

    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
    REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
    AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
    INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
    LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
    OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
    PERFORMANCE OF THIS SOFTWARE.
    ***************************************************************************** */
    /* global Reflect, Promise, SuppressedError, Symbol */

    var extendStatics = function(d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };

    function __extends(d, b) {
        if (typeof b !== "function" && b !== null)
            throw new TypeError("Class extends value " + String(b) + " is not a constructor or null");
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    }

    var __assign = function() {
        __assign = Object.assign || function __assign(t) {
            for (var s, i = 1, n = arguments.length; i < n; i++) {
                s = arguments[i];
                for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p)) t[p] = s[p];
            }
            return t;
        };
        return __assign.apply(this, arguments);
    };

    function __awaiter(thisArg, _arguments, P, generator) {
        function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
        return new (P || (P = Promise))(function (resolve, reject) {
            function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
            function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
            function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
            step((generator = generator.apply(thisArg, _arguments || [])).next());
        });
    }

    function __generator(thisArg, body) {
        var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
        return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
        function verb(n) { return function (v) { return step([n, v]); }; }
        function step(op) {
            if (f) throw new TypeError("Generator is already executing.");
            while (g && (g = 0, op[0] && (_ = 0)), _) try {
                if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
                if (y = 0, t) op = [op[0] & 2, t.value];
                switch (op[0]) {
                    case 0: case 1: t = op; break;
                    case 4: _.label++; return { value: op[1], done: false };
                    case 5: _.label++; y = op[1]; op = [0]; continue;
                    case 7: op = _.ops.pop(); _.trys.pop(); continue;
                    default:
                        if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                        if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                        if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                        if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                        if (t[2]) _.ops.pop();
                        _.trys.pop(); continue;
                }
                op = body.call(thisArg, _);
            } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
            if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
        }
    }

    function __values(o) {
        var s = typeof Symbol === "function" && Symbol.iterator, m = s && o[s], i = 0;
        if (m) return m.call(o);
        if (o && typeof o.length === "number") return {
            next: function () {
                if (o && i >= o.length) o = void 0;
                return { value: o && o[i++], done: !o };
            }
        };
        throw new TypeError(s ? "Object is not iterable." : "Symbol.iterator is not defined.");
    }

    function __read(o, n) {
        var m = typeof Symbol === "function" && o[Symbol.iterator];
        if (!m) return o;
        var i = m.call(o), r, ar = [], e;
        try {
            while ((n === void 0 || n-- > 0) && !(r = i.next()).done) ar.push(r.value);
        }
        catch (error) { e = { error: error }; }
        finally {
            try {
                if (r && !r.done && (m = i["return"])) m.call(i);
            }
            finally { if (e) throw e.error; }
        }
        return ar;
    }

    function __spreadArray(to, from, pack) {
        if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
            if (ar || !(i in from)) {
                if (!ar) ar = Array.prototype.slice.call(from, 0, i);
                ar[i] = from[i];
            }
        }
        return to.concat(ar || Array.prototype.slice.call(from));
    }

    typeof SuppressedError === "function" ? SuppressedError : function (error, suppressed, message) {
        var e = new Error(message);
        return e.name = "SuppressedError", e.error = error, e.suppressed = suppressed, e;
    };

    var request$1 = function (_a) {
        var _b = _a.method, method = _b === void 0 ? 'POST' : _b, url = _a.url, data = _a.data, headers = _a.headers;
        return __awaiter(void 0, void 0, void 0, function () {
            var res, err_1;
            return __generator(this, function (_c) {
                switch (_c.label) {
                    case 0:
                        _c.trys.push([0, 2, , 3]);
                        return [4 /*yield*/, axios__default["default"]({
                                method: method,
                                url: url,
                                data: data,
                                headers: headers,
                            })];
                    case 1:
                        res = _c.sent();
                        if (res.data.code !== 200) {
                            return [2 /*return*/, Promise.reject(res.data)];
                        }
                        return [2 /*return*/, res.data];
                    case 2:
                        err_1 = _c.sent();
                        return [2 /*return*/, Promise.reject(err_1)];
                    case 3: return [2 /*return*/];
                }
            });
        });
    };
    var webRequestHelper = request$1;

    var request = webRequestHelper;

    var Storage = /** @class */ (function () {
        function Storage(type, salt) {
            this.store = new Map();
            this.type = 'memory';
            this.salt = '__salt__';
            type && (this.type = type);
            salt && (this.salt = salt);
        }
        Storage.prototype.get = function (key) {
            var value;
            switch (this.type) {
                case 'memory':
                    return this.store.get(key);
                case 'localStorage':
                    value = localStorage.getItem("".concat(this.salt).concat(key));
                    if (value) {
                        return JSON.parse(value);
                    }
                    return value;
                case 'sessionStorage':
                    value = sessionStorage.getItem("".concat(this.salt).concat(key));
                    if (value) {
                        return JSON.parse(value);
                    }
                    return value;
            }
        };
        Storage.prototype.set = function (key, value) {
            switch (this.type) {
                case 'memory':
                    this.store.set(key, value);
                    break;
                case 'localStorage':
                    localStorage.setItem("".concat(this.salt).concat(key), JSON.stringify(value));
                    break;
                case 'sessionStorage':
                    sessionStorage.setItem("".concat(this.salt).concat(key), JSON.stringify(value));
                    break;
            }
        };
        Storage.prototype.remove = function (key) {
            switch (this.type) {
                case 'memory':
                    this.store.delete(key);
                    break;
                case 'localStorage':
                    localStorage.removeItem("".concat(this.salt).concat(key));
                    break;
                case 'sessionStorage':
                    sessionStorage.removeItem("".concat(this.salt).concat(key));
                    break;
            }
        };
        return Storage;
    }());
    var webStorage = Storage;

    var index = webStorage;

    var url$1 = "https://statistic.live.126.net/statics/report/xkit/action";
    var EventTracking = /** @class */ (function () {
        function EventTracking(_a) {
            var appKey = _a.appKey, version = _a.version, component = _a.component, nertcVersion = _a.nertcVersion, imVersion = _a.imVersion, _b = _a.platform, platform = _b === void 0 ? 'Web' : _b, _c = _a.channel, channel = _c === void 0 ? 'netease' : _c;
            this.platform = platform;
            this.appKey = appKey;
            this.version = version;
            this.component = component;
            this.nertcVersion = nertcVersion;
            this.imVersion = imVersion;
            this.channel = channel;
        }
        EventTracking.prototype.track = function (reportType, data) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, appKey, version, component, nertcVersion, imVersion, platform, channel, timeStamp;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _a = this, appKey = _a.appKey, version = _a.version, component = _a.component, nertcVersion = _a.nertcVersion, imVersion = _a.imVersion, platform = _a.platform, channel = _a.channel;
                            timeStamp = Date.now();
                            _c.label = 1;
                        case 1:
                            _c.trys.push([1, 3, , 4]);
                            return [4 /*yield*/, request({
                                    method: 'POST',
                                    url: url$1,
                                    data: {
                                        appKey: appKey,
                                        version: version,
                                        component: component,
                                        timeStamp: timeStamp,
                                        nertcVersion: nertcVersion,
                                        imVersion: imVersion,
                                        platform: platform,
                                        reportType: reportType,
                                        data: data,
                                        channel: channel,
                                    },
                                })];
                        case 2:
                            _c.sent();
                            return [3 /*break*/, 4];
                        case 3:
                            _c.sent();
                            return [3 /*break*/, 4];
                        case 4: return [2 /*return*/];
                    }
                });
            });
        };
        return EventTracking;
    }());
    var EventTracking$1 = EventTracking;

    /**
     * 判断元素是否可见
     * 融合了 IntersectionObserver 与 visibilityChange 事件
     */
    var VisibilityObserver = /** @class */ (function (_super) {
        __extends(VisibilityObserver, _super);
        // 入参说明参考：https://developer.mozilla.org/zh-CN/docs/Web/API/Intersection_Observer_API
        function VisibilityObserver(options) {
            var _this = _super.call(this) || this;
            _this.visibilityState = document.visibilityState;
            _this.entries = [];
            _this._visibilitychange = function () {
                _this.visibilityState = document.visibilityState;
                _this._trigger();
            };
            _this.intersectionObserver = new IntersectionObserver(_this._intersectionObserverHandler.bind(_this), options);
            document.addEventListener('visibilitychange', _this._visibilitychange);
            return _this;
        }
        VisibilityObserver.prototype.observe = function (target) {
            return this.intersectionObserver.observe(target);
        };
        VisibilityObserver.prototype.unobserve = function (target) {
            return this.intersectionObserver.unobserve(target);
        };
        VisibilityObserver.prototype.destroy = function () {
            this.intersectionObserver.disconnect();
            document.removeEventListener('visibilitychange', this._visibilitychange);
            this.entries = [];
        };
        VisibilityObserver.prototype._intersectionObserverHandler = function (entries) {
            this.entries = entries;
            this._trigger();
        };
        VisibilityObserver.prototype._trigger = function () {
            var _this = this;
            this.entries.forEach(function (item) {
                if (_this.visibilityState !== 'visible' || item.intersectionRatio <= 0) {
                    _this.emit('visibleChange', {
                        visible: false,
                        target: item.target,
                    });
                    return;
                }
                _this.emit('visibleChange', {
                    visible: true,
                    target: item.target,
                });
            });
        };
        return VisibilityObserver;
    }(EventEmitter__default["default"]));
    var VisibilityObserver$1 = VisibilityObserver;

    var commonjsGlobal$1 = typeof globalThis !== 'undefined' ? globalThis : typeof window !== 'undefined' ? window : typeof commonjsGlobal !== 'undefined' ? commonjsGlobal : typeof self !== 'undefined' ? self : {};

    function createCommonjsModule(fn, module) {
    	return module = { exports: {} }, fn(module, module.exports), module.exports;
    }

    var loglevel = createCommonjsModule(function (module) {
    /*
    * loglevel - https://github.com/pimterry/loglevel
    *
    * Copyright (c) 2013 Tim Perry
    * Licensed under the MIT license.
    */
    (function (root, definition) {
        if (module.exports) {
            module.exports = definition();
        } else {
            root.log = definition();
        }
    }(commonjsGlobal$1, function () {

        // Slightly dubious tricks to cut down minimized file size
        var noop = function() {};
        var undefinedType = "undefined";
        var isIE = (typeof window !== undefinedType) && (typeof window.navigator !== undefinedType) && (
            /Trident\/|MSIE /.test(window.navigator.userAgent)
        );

        var logMethods = [
            "trace",
            "debug",
            "info",
            "warn",
            "error"
        ];

        var _loggersByName = {};
        var defaultLogger = null;

        // Cross-browser bind equivalent that works at least back to IE6
        function bindMethod(obj, methodName) {
            var method = obj[methodName];
            if (typeof method.bind === 'function') {
                return method.bind(obj);
            } else {
                try {
                    return Function.prototype.bind.call(method, obj);
                } catch (e) {
                    // Missing bind shim or IE8 + Modernizr, fallback to wrapping
                    return function() {
                        return Function.prototype.apply.apply(method, [obj, arguments]);
                    };
                }
            }
        }

        // Trace() doesn't print the message in IE, so for that case we need to wrap it
        function traceForIE() {
            if (console.log) {
                if (console.log.apply) {
                    console.log.apply(console, arguments);
                } else {
                    // In old IE, native console methods themselves don't have apply().
                    Function.prototype.apply.apply(console.log, [console, arguments]);
                }
            }
            if (console.trace) console.trace();
        }

        // Build the best logging method possible for this env
        // Wherever possible we want to bind, not wrap, to preserve stack traces
        function realMethod(methodName) {
            if (methodName === 'debug') {
                methodName = 'log';
            }

            if (typeof console === undefinedType) {
                return false; // No method possible, for now - fixed later by enableLoggingWhenConsoleArrives
            } else if (methodName === 'trace' && isIE) {
                return traceForIE;
            } else if (console[methodName] !== undefined) {
                return bindMethod(console, methodName);
            } else if (console.log !== undefined) {
                return bindMethod(console, 'log');
            } else {
                return noop;
            }
        }

        // These private functions always need `this` to be set properly

        function replaceLoggingMethods() {
            /*jshint validthis:true */
            var level = this.getLevel();

            // Replace the actual methods.
            for (var i = 0; i < logMethods.length; i++) {
                var methodName = logMethods[i];
                this[methodName] = (i < level) ?
                    noop :
                    this.methodFactory(methodName, level, this.name);
            }

            // Define log.log as an alias for log.debug
            this.log = this.debug;

            // Return any important warnings.
            if (typeof console === undefinedType && level < this.levels.SILENT) {
                return "No console available for logging";
            }
        }

        // In old IE versions, the console isn't present until you first open it.
        // We build realMethod() replacements here that regenerate logging methods
        function enableLoggingWhenConsoleArrives(methodName) {
            return function () {
                if (typeof console !== undefinedType) {
                    replaceLoggingMethods.call(this);
                    this[methodName].apply(this, arguments);
                }
            };
        }

        // By default, we use closely bound real methods wherever possible, and
        // otherwise we wait for a console to appear, and then try again.
        function defaultMethodFactory(methodName, _level, _loggerName) {
            /*jshint validthis:true */
            return realMethod(methodName) ||
                   enableLoggingWhenConsoleArrives.apply(this, arguments);
        }

        function Logger(name, factory) {
          // Private instance variables.
          var self = this;
          /**
           * The level inherited from a parent logger (or a global default). We
           * cache this here rather than delegating to the parent so that it stays
           * in sync with the actual logging methods that we have installed (the
           * parent could change levels but we might not have rebuilt the loggers
           * in this child yet).
           * @type {number}
           */
          var inheritedLevel;
          /**
           * The default level for this logger, if any. If set, this overrides
           * `inheritedLevel`.
           * @type {number|null}
           */
          var defaultLevel;
          /**
           * A user-specific level for this logger. If set, this overrides
           * `defaultLevel`.
           * @type {number|null}
           */
          var userLevel;

          var storageKey = "loglevel";
          if (typeof name === "string") {
            storageKey += ":" + name;
          } else if (typeof name === "symbol") {
            storageKey = undefined;
          }

          function persistLevelIfPossible(levelNum) {
              var levelName = (logMethods[levelNum] || 'silent').toUpperCase();

              if (typeof window === undefinedType || !storageKey) return;

              // Use localStorage if available
              try {
                  window.localStorage[storageKey] = levelName;
                  return;
              } catch (ignore) {}

              // Use session cookie as fallback
              try {
                  window.document.cookie =
                    encodeURIComponent(storageKey) + "=" + levelName + ";";
              } catch (ignore) {}
          }

          function getPersistedLevel() {
              var storedLevel;

              if (typeof window === undefinedType || !storageKey) return;

              try {
                  storedLevel = window.localStorage[storageKey];
              } catch (ignore) {}

              // Fallback to cookies if local storage gives us nothing
              if (typeof storedLevel === undefinedType) {
                  try {
                      var cookie = window.document.cookie;
                      var cookieName = encodeURIComponent(storageKey);
                      var location = cookie.indexOf(cookieName + "=");
                      if (location !== -1) {
                          storedLevel = /^([^;]+)/.exec(
                              cookie.slice(location + cookieName.length + 1)
                          )[1];
                      }
                  } catch (ignore) {}
              }

              // If the stored level is not valid, treat it as if nothing was stored.
              if (self.levels[storedLevel] === undefined) {
                  storedLevel = undefined;
              }

              return storedLevel;
          }

          function clearPersistedLevel() {
              if (typeof window === undefinedType || !storageKey) return;

              // Use localStorage if available
              try {
                  window.localStorage.removeItem(storageKey);
              } catch (ignore) {}

              // Use session cookie as fallback
              try {
                  window.document.cookie =
                    encodeURIComponent(storageKey) + "=; expires=Thu, 01 Jan 1970 00:00:00 UTC";
              } catch (ignore) {}
          }

          function normalizeLevel(input) {
              var level = input;
              if (typeof level === "string" && self.levels[level.toUpperCase()] !== undefined) {
                  level = self.levels[level.toUpperCase()];
              }
              if (typeof level === "number" && level >= 0 && level <= self.levels.SILENT) {
                  return level;
              } else {
                  throw new TypeError("log.setLevel() called with invalid level: " + input);
              }
          }

          /*
           *
           * Public logger API - see https://github.com/pimterry/loglevel for details
           *
           */

          self.name = name;

          self.levels = { "TRACE": 0, "DEBUG": 1, "INFO": 2, "WARN": 3,
              "ERROR": 4, "SILENT": 5};

          self.methodFactory = factory || defaultMethodFactory;

          self.getLevel = function () {
              if (userLevel != null) {
                return userLevel;
              } else if (defaultLevel != null) {
                return defaultLevel;
              } else {
                return inheritedLevel;
              }
          };

          self.setLevel = function (level, persist) {
              userLevel = normalizeLevel(level);
              if (persist !== false) {  // defaults to true
                  persistLevelIfPossible(userLevel);
              }

              // NOTE: in v2, this should call rebuild(), which updates children.
              return replaceLoggingMethods.call(self);
          };

          self.setDefaultLevel = function (level) {
              defaultLevel = normalizeLevel(level);
              if (!getPersistedLevel()) {
                  self.setLevel(level, false);
              }
          };

          self.resetLevel = function () {
              userLevel = null;
              clearPersistedLevel();
              replaceLoggingMethods.call(self);
          };

          self.enableAll = function(persist) {
              self.setLevel(self.levels.TRACE, persist);
          };

          self.disableAll = function(persist) {
              self.setLevel(self.levels.SILENT, persist);
          };

          self.rebuild = function () {
              if (defaultLogger !== self) {
                  inheritedLevel = normalizeLevel(defaultLogger.getLevel());
              }
              replaceLoggingMethods.call(self);

              if (defaultLogger === self) {
                  for (var childName in _loggersByName) {
                    _loggersByName[childName].rebuild();
                  }
              }
          };

          // Initialize all the internal levels.
          inheritedLevel = normalizeLevel(
              defaultLogger ? defaultLogger.getLevel() : "WARN"
          );
          var initialLevel = getPersistedLevel();
          if (initialLevel != null) {
              userLevel = normalizeLevel(initialLevel);
          }
          replaceLoggingMethods.call(self);
        }

        /*
         *
         * Top-level API
         *
         */

        defaultLogger = new Logger();

        defaultLogger.getLogger = function getLogger(name) {
            if ((typeof name !== "symbol" && typeof name !== "string") || name === "") {
                throw new TypeError("You must supply a name when creating a logger.");
            }

            var logger = _loggersByName[name];
            if (!logger) {
                logger = _loggersByName[name] = new Logger(
                    name,
                    defaultLogger.methodFactory
                );
            }
            return logger;
        };

        // Grab the current global log variable in case of overwrite
        var _log = (typeof window !== undefinedType) ? window.log : undefined;
        defaultLogger.noConflict = function() {
            if (typeof window !== undefinedType &&
                   window.log === defaultLogger) {
                window.log = _log;
            }

            return defaultLogger;
        };

        defaultLogger.getLoggers = function getLoggers() {
            return _loggersByName;
        };

        // ES6 default export, for compatibility
        defaultLogger['default'] = defaultLogger;

        return defaultLogger;
    }));
    });

    var log = loglevel;

    function createLoggerDecorator(MODULE_NAME, logger) {
        return function (__, propKey, descriptor) {
            var method = descriptor.value;
            descriptor.value = function () {
                var args = [];
                for (var _i = 0; _i < arguments.length; _i++) {
                    args[_i] = arguments[_i];
                }
                return __awaiter(this, void 0, void 0, function () {
                    var methodName, res, err_1;
                    return __generator(this, function (_a) {
                        switch (_a.label) {
                            case 0:
                                if (!logger) {
                                    // @ts-ignore
                                    logger = this.logger;
                                }
                                if (['log', 'error'].some(function (item) { return !logger[item]; })) {
                                    console.warn('loggerDecorator warning: your logger is not complete');
                                }
                                methodName = method.name || propKey || '';
                                _a.label = 1;
                            case 1:
                                _a.trys.push([1, 3, , 4]);
                                logger === null || logger === void 0 ? void 0 : logger.log.apply(logger, __spreadArray([MODULE_NAME, methodName], __read(args), false));
                                return [4 /*yield*/, method.apply(this, args)];
                            case 2:
                                res = _a.sent();
                                logger === null || logger === void 0 ? void 0 : logger.log(MODULE_NAME, "".concat(methodName, " success: "), res);
                                return [2 /*return*/, res];
                            case 3:
                                err_1 = _a.sent();
                                logger === null || logger === void 0 ? void 0 : logger.error(MODULE_NAME, "".concat(methodName, " failed: "), err_1);
                                throw err_1;
                            case 4: return [2 /*return*/];
                        }
                    });
                });
            };
        };
    }

    function sensitiveInfoFilter(content) {
        var regexs = [
            'scene/apps/[a-z0-9]{32}/',
            '"rtcKey":"[a-z0-9]{32}"',
            '"imKey":"[a-z0-9]{32}"',
            '"appkey":"[a-z0-9]{32}"',
            '"appkey": "[a-z0-9]{32}"',
            'appkey:"[a-z0-9]{32}"',
            'appkey: "[a-z0-9]{32}"',
            '"appkey":[a-z0-9]{32}',
            '"appkey": [a-z0-9]{32}',
            'appkey:[a-z0-9]{32}',
            'appkey: [a-z0-9]{32}',
        ];
        var templates = [
            'scene/apps/***/',
            '"rtcKey":"***"',
            '"imKey":"***"',
            '"appkey":"***"',
            '"appkey": "***"',
            'appkey:"***"',
            'appkey: "***"',
            '"appkey":***',
            '"appkey": ***',
            'appkey:***',
            'appkey: ***',
        ];
        regexs.forEach(function (regex, index) {
            var reg = new RegExp(regex, 'gi');
            content = content.replace(reg, templates[index]);
        });
        return content;
    }
    var logDebug = function (_a) {
        var _b = _a === void 0 ? {
            appName: '',
            version: '',
            storeWindow: false,
        } : _a, level = _b.level, _c = _b.appName, appName = _c === void 0 ? '' : _c, _d = _b.storeWindow, storeWindow = _d === void 0 ? false : _d;
        var genTime = function () {
            var now = new Date();
            var year = now.getFullYear();
            var month = now.getMonth() + 1;
            var day = now.getDate();
            var hour = now.getHours() < 10 ? "0".concat(now.getHours()) : now.getHours();
            var min = now.getMinutes() < 10 ? "0".concat(now.getMinutes()) : now.getMinutes();
            var s = now.getSeconds() < 10 ? "0".concat(now.getSeconds()) : now.getSeconds();
            var nowString = "".concat(year, "-").concat(month, "-").concat(day, " ").concat(hour, ":").concat(min, ":").concat(s);
            return nowString;
        };
        var genUserAgent = function () {
            try {
                var ua = navigator.userAgent.toLocaleLowerCase();
                var re = /(msie|firefox|chrome|opera|version).*?([\d.]+)/;
                var m = ua.match(re) || [];
                var browser = m[1].replace(/version/, 'safari');
                var ver = m[2];
                return {
                    browser: browser,
                    ver: ver,
                };
            }
            catch (error) {
                return null;
            }
        };
        var proxyLog = function () {
            var _log = new Proxy(log, {
                get: function (target, prop) {
                    var _a, _b;
                    if (!(prop in target)) {
                        return;
                    }
                    var func = target[prop];
                    if (!['log', 'info', 'warn', 'error', 'trace', 'debug'].includes(prop)) {
                        return func;
                    }
                    var prefix = genTime();
                    if (genUserAgent()) {
                        prefix += "[".concat((_a = genUserAgent()) === null || _a === void 0 ? void 0 : _a.browser, " ").concat((_b = genUserAgent()) === null || _b === void 0 ? void 0 : _b.ver, "]");
                    }
                    prefix +=
                        "[".concat({
                            log: 'L',
                            info: 'I',
                            warn: 'W',
                            error: 'E',
                            trace: 'E',
                            debug: 'D',
                        }[prop], "]") +
                            "[".concat(appName, "]") +
                            ':';
                    // eslint-disable-next-line @typescript-eslint/no-this-alias
                    var that = this;
                    return function () {
                        var args = [];
                        for (var _i = 0; _i < arguments.length; _i++) {
                            args[_i] = arguments[_i];
                        }
                        for (var i = 0; i < args.length; i++) {
                            if (typeof args[i] === 'object') {
                                try {
                                    args[i] = JSON.stringify(args[i]);
                                }
                                catch (_a) {
                                    console.warn('[日志打印对象无法序列化]', args[i]);
                                }
                            }
                            if (typeof args[i] === 'string') {
                                args[i] = sensitiveInfoFilter(args[i]);
                            }
                        }
                        return func.apply(that, __spreadArray([prefix], __read(args), false));
                    };
                },
            });
            return _log;
        };
        var logger = proxyLog();
        if (level) {
            logger.setLevel(level);
        }
        if (storeWindow) {
            // @ts-ignore
            window.__LOGGER__ = logger;
        }
        return logger;
    };
    var logDebug$1 = logDebug;

    exports.EventPriority = void 0;
    (function (EventPriority) {
        EventPriority[EventPriority["LOW"] = 0] = "LOW";
        EventPriority[EventPriority["NORMAL"] = 1] = "NORMAL";
        EventPriority[EventPriority["HIGH"] = 2] = "HIGH";
    })(exports.EventPriority || (exports.EventPriority = {}));
    var ReportEvent = /** @class */ (function () {
        // private _report: XKitReporter
        function ReportEvent(options) {
            // static appInfo: AppInfo
            this.appKey = '';
            this.component = '';
            this.data = {};
            this.framework = '';
            this.version = '';
            this.startTime = 0;
            this.endTime = 0;
            this.duration = 0;
            this.data.startTime = new Date().getTime();
            this.data.timeStamp = this.data.startTime;
            this.eventId = options.eventId;
            this.priority = options.priority;
        }
        ReportEvent.prototype.end = function () {
            // 如果已经end过 不再end
            if (this.data.endTime && this.data.duration) {
                return;
            }
            this.data.endTime = this.data.endTime || new Date().getTime();
            this.data.duration =
                this.data.duration || this.data.endTime - this.data.startTime;
        };
        ReportEvent.prototype.setAppInfo = function (appInfo) {
            this.appKey = appInfo.appKey;
            this.component = appInfo.component;
            this.version = appInfo.version;
            if (appInfo.framework) {
                this.framework = appInfo.framework;
            }
        };
        ReportEvent.prototype.endWith = function (data) {
            var code = data.code, msg = data.msg, requestId = data.requestId, serverCost = data.serverCost;
            // 过滤code非number类型
            if (typeof code != 'number') {
                this.data.code = -2;
            }
            else {
                this.data.code = code;
            }
            this.data.message = msg;
            this.data.requestId = requestId;
            this.data.serverCost = serverCost;
            this.end();
        };
        ReportEvent.prototype.endWithSuccess = function (data) {
            if (data) {
                var requestId = data.requestId, serverCost = data.serverCost;
                this.data.requestId = requestId;
                this.data.serverCost = serverCost;
            }
            this.data.code = 0;
            this.data.message = 'success';
            this.end();
        };
        ReportEvent.prototype.endWithFailure = function (data) {
            if (data) {
                var requestId = data.requestId, serverCost = data.serverCost;
                this.data.requestId = requestId;
                this.data.serverCost = serverCost;
            }
            this.data.code = -1;
            this.data.message = 'failure';
            this.end();
        };
        ReportEvent.prototype.setParams = function (params) {
            this.data.params = __assign({}, params);
            return this;
        };
        ReportEvent.prototype.addParams = function (params) {
            this.data.params = __assign(__assign({}, this.data.params), params);
            return this;
        };
        ReportEvent.prototype.setData = function (data) {
            this.data = __assign(__assign({}, this.data), data);
        };
        ReportEvent.prototype.setUserId = function (userId) {
            this.data.userId = userId;
        };
        return ReportEvent;
    }());
    var EventStep = /** @class */ (function (_super) {
        __extends(EventStep, _super);
        function EventStep(options) {
            return _super.call(this, options) || this;
        }
        return EventStep;
    }(ReportEvent));
    var IntervalEvent = /** @class */ (function (_super) {
        __extends(IntervalEvent, _super);
        function IntervalEvent(options) {
            var _this = _super.call(this, options) || this;
            _this._stepMap = new Map();
            return _this;
        }
        IntervalEvent.prototype.beginStep = function (name) {
            if (this._stepMap.has(name)) {
                return this._stepMap[name];
            }
            var step = new EventStep({ eventId: name, priority: this.priority });
            step.setData({ step: name });
            this._stepMap.set(name, step);
            return step;
        };
        IntervalEvent.prototype.addStep = function (data) {
            this._stepMap.set(data.eventId, data);
        };
        IntervalEvent.prototype.removeStep = function (eventId) {
            this._stepMap.delete(eventId);
        };
        IntervalEvent.prototype.endWith = function (data) {
            _super.prototype.endWith.call(this, data);
            this.end();
        };
        IntervalEvent.prototype.endWithSuccess = function (data) {
            _super.prototype.endWithSuccess.call(this, data);
            this.end();
        };
        IntervalEvent.prototype.endWithFailure = function (data) {
            _super.prototype.endWithFailure.call(this, data);
            this.end();
        };
        IntervalEvent.prototype.end = function () {
            var e_1, _a;
            var steps = [];
            _super.prototype.end.call(this);
            try {
                for (var _b = __values(this._stepMap.values()), _c = _b.next(); !_c.done; _c = _b.next()) {
                    var step = _c.value;
                    // step.end()
                    step.data.index = steps.length;
                    steps.push(step.data);
                }
            }
            catch (e_1_1) { e_1 = { error: e_1_1 }; }
            finally {
                try {
                    if (_c && !_c.done && (_a = _b.return)) _a.call(_b);
                }
                finally { if (e_1) throw e_1.error; }
            }
            if (steps.length > 0) {
                this.data.steps = steps;
            }
        };
        return IntervalEvent;
    }(EventStep));

    /**
     * 异步频率控制
     * 一段时间内只请求一次，多余的用这一次执行的结果做为结果
     * @param fn
     * @param delay
     */
    var frequencyControl = function (fn, delay) {
        var queue = [];
        var last = 0;
        var timer;
        return function () {
            var _this = this;
            var args = [];
            for (var _i = 0; _i < arguments.length; _i++) {
                args[_i] = arguments[_i];
            }
            return new Promise(function (resolve, reject) {
                queue.push({ resolve: resolve, reject: reject });
                var cur = Date.now();
                var consumer = function (success, res) {
                    while (queue.length) {
                        var _a = queue.shift(), resolve_1 = _a.resolve, reject_1 = _a.reject;
                        success ? resolve_1(res) : reject_1(res);
                    }
                };
                var excute = function () {
                    last = cur;
                    if (!queue.length)
                        return;
                    // @ts-ignore
                    fn.apply(_this, args).then(function (res) {
                        consumer(true, res);
                    }, function (err) {
                        consumer(false, err);
                    });
                };
                if (cur - last > delay) {
                    excute();
                }
                else {
                    clearTimeout(timer);
                    timer = setTimeout(function () {
                        excute();
                    }, delay);
                }
            });
        };
    };
    function getFileType(filename) {
        var fileMap = {
            img: /(png|gif|jpg)/i,
            pdf: /pdf$/i,
            word: /(doc|docx)$/i,
            excel: /(xls|xlsx)$/i,
            ppt: /(ppt|pptx)$/i,
            zip: /(zip|rar|7z)$/i,
            audio: /(mp3|wav|wmv)$/i,
            video: /(mp4|mkv|rmvb|wmv|avi|flv|mov)$/i,
        };
        return Object.keys(fileMap).find(function (type) { return fileMap[type].test(filename); }) || '';
    }
    /**
     * 解析输入的文件大小
     * @param size 文件大小，单位b
     * @param level 递归等级，对应fileSizeMap
     */
    var parseFileSize = function (size, level) {
        if (level === void 0) { level = 0; }
        var fileSizeMap = {
            0: 'B',
            1: 'KB',
            2: 'MB',
            3: 'GB',
            4: 'TB',
        };
        var handler = function (size, level) {
            if (level >= Object.keys(fileSizeMap).length) {
                return 'the file is too big';
            }
            if (size < 1024) {
                return "".concat(size).concat(fileSizeMap[level]);
            }
            return handler(Math.round(size / 1024), level + 1);
        };
        return handler(size, level);
    };
    var addUrlSearch = function (url, search) {
        var urlObj = new URL(url);
        urlObj.search += (urlObj.search.startsWith('?') ? '&' : '?') + search;
        return urlObj.href;
    };
    function debounce(fn, wait) {
        var timer = null;
        return function () {
            var _this = this;
            var args = [];
            for (var _i = 0; _i < arguments.length; _i++) {
                args[_i] = arguments[_i];
            }
            if (timer) {
                clearTimeout(timer);
                timer = null;
            }
            timer = setTimeout(function () {
                // @ts-ignore
                fn.apply(_this, args);
            }, wait);
        };
    }
    function getOperatingSystem() {
        try {
            var userAgent = navigator.userAgent;
            if (userAgent.includes('Windows')) {
                return 'Windows';
            }
            else if (userAgent.includes('Mac OS')) {
                return 'Mac OS';
            }
            else if (userAgent.includes('Linux')) {
                return 'Linux';
            }
            else if (userAgent.includes('Android')) {
                return 'Android';
            }
            else if (userAgent.includes('iOS')) {
                return 'iOS';
            }
            else {
                return 'Unknown';
            }
        }
        catch (_a) {
            return 'Unknown';
        }
    }
    function getBrowserInfo() {
        var browserName = 'Unknown';
        var browserVersion = '';
        try {
            var userAgent = navigator.userAgent;
            // 判断是否为Chrome浏览器
            if (userAgent.indexOf('Chrome') !== -1) {
                browserName = 'Chrome';
                var start = userAgent.indexOf('Chrome') + 7;
                var end = userAgent.indexOf(' ', start);
                browserVersion = userAgent.substring(start, end);
            }
            // 判断是否为Firefox浏览器
            else if (userAgent.indexOf('Firefox') !== -1) {
                browserName = 'Firefox';
                var start = userAgent.indexOf('Firefox') + 8;
                browserVersion = userAgent.substring(start);
            }
            // 判断是否为Safari浏览器
            else if (userAgent.indexOf('Safari') !== -1) {
                browserName = 'Safari';
                var start = userAgent.indexOf('Version') + 8;
                var end = userAgent.indexOf(' ', start);
                browserVersion = userAgent.substring(start, end);
            }
            // 判断是否为Edge浏览器
            else if (userAgent.indexOf('Edg') !== -1) {
                browserName = 'Edge';
                var start = userAgent.indexOf('Edg') + 4;
                browserVersion = userAgent.substring(start);
            }
            // 判断是否为IE浏览器（IE11及以下版本）
            else if (userAgent.indexOf('MSIE') !== -1) {
                browserName = 'Internet Explorer';
                var start = userAgent.indexOf('MSIE') + 5;
                var end = userAgent.indexOf(';', start);
                browserVersion = userAgent.substring(start, end);
            }
        }
        catch (error) {
            console.error('getBrowserInfo error:', error);
        }
        return {
            name: browserName,
            version: browserVersion,
        };
    }

    var url = "https://statistic.live.126.net/statics/report/common/form";
    var HEADER_VALUE_SDK_TYPE = 'NEXKitStatistics';
    var HEADER_VALUE_REPORTER_VERSION = '1.0.0';
    var HEADER_VALUE_CONTENT_TYPE = 'application/json;charset=utf-8';
    var EVENT_REPORT_INTERVAL = 5000;
    var MAX_EVENT_CACHE_SIZE = 100;
    var LOW_PRIORITY_RETRY = 0;
    var NORMAL_PRIORITY_RETRY = 2;
    var HIGH_PRIORITY_RETRY = 5;
    var MAX_RETRY_COUNT = 3;
    var XKitReporter = /** @class */ (function () {
        function XKitReporter(options) {
            this._eventsCache = [];
            this._noReport = false; // 是否上报数据
            this._configMap = new Map();
            this._retryCount = 0;
            var browserInfo = getBrowserInfo();
            var appInfo = window.__XKitReporter__;
            var userAgent = '';
            try {
                userAgent = navigator.userAgent;
            }
            catch (_a) {
                console.log('navigator is not defined');
            }
            this.common = {
                imVersion: options.imVersion,
                nertcVersion: options.nertcVersion,
                platform: 'Web',
                osVer: browserInfo.version,
                userAgent: userAgent,
                manufacturer: '',
                model: browserInfo.name,
                packageId: (appInfo === null || appInfo === void 0 ? void 0 : appInfo.packageId) || '',
                appVer: (appInfo === null || appInfo === void 0 ? void 0 : appInfo.appVer) || '',
                appName: (appInfo === null || appInfo === void 0 ? void 0 : appInfo.appName) || '',
                deviceId: options.deviceId,
            };
            this._logger = logDebug$1({
                level: 'debug',
                appName: 'XKitReporter',
                version: '2.0.0',
            });
        }
        XKitReporter.prototype.getConfig = function (appKey) {
            return __awaiter(this, void 0, void 0, function () {
                var _this = this;
                return __generator(this, function (_a) {
                    return [2 /*return*/, axios__default["default"]({
                            method: 'GET',
                            url: 'https://yiyong.netease.im/report_conf',
                            headers: {
                                platform: 'web',
                                appKey: appKey,
                            },
                        })
                            .then(function (res) {
                            _this._configMap.set(appKey, res.data);
                        })
                            .catch(function () {
                            _this._retryCount += 1;
                            if (_this._retryCount > MAX_RETRY_COUNT) {
                                _this._retryCount = 0;
                                return;
                            }
                            _this.getConfig(appKey);
                        })];
                });
            });
        };
        XKitReporter.prototype.setNoReport = function (noReport) {
            this._noReport = noReport;
        };
        XKitReporter.prototype.reportEvent = function (event, options) {
            // 如果禁止上包则返回
            if (this._noReport) {
                return;
            }
            if (this._eventsCache.length >= MAX_EVENT_CACHE_SIZE) {
                this._evictEvent(event);
            }
            else {
                this._eventsCache.push(event);
            }
            this._scheduleReportEventsTask(options === null || options === void 0 ? void 0 : options.immediate);
        };
        XKitReporter.prototype._evictEvent = function (event) {
            var index = this._eventsCache.findIndex(function (item) { return item.priority < event.priority; });
            this._eventsCache.push(event);
            if (index !== -1) {
                this._evictEvent(this._eventsCache[index]);
            }
            else {
                this._logger.debug('Full event cache, evict event:', event);
                this._eventsCache = this._eventsCache.filter(function (item) { return item !== event; });
            }
        };
        XKitReporter.prototype._scheduleReportEventsTask = function (immediate) {
            var _this = this;
            if (immediate === void 0) { immediate = false; }
            var execute = function () { return __awaiter(_this, void 0, void 0, function () {
                var groupByAppKey, _a, _b, _c, _i, appKey, config;
                return __generator(this, function (_d) {
                    switch (_d.label) {
                        case 0:
                            groupByAppKey = this._eventsCache.reduce(function (acc, obj) {
                                var key = obj.appKey;
                                if (!acc[key]) {
                                    acc[key] = [];
                                }
                                acc[key].push(obj);
                                return acc;
                            }, {});
                            _a = groupByAppKey;
                            _b = [];
                            for (_c in _a)
                                _b.push(_c);
                            _i = 0;
                            _d.label = 1;
                        case 1:
                            if (!(_i < _b.length)) return [3 /*break*/, 5];
                            _c = _b[_i];
                            if (!(_c in _a)) return [3 /*break*/, 4];
                            appKey = _c;
                            if (!!this._configMap.has(appKey)) return [3 /*break*/, 3];
                            return [4 /*yield*/, this.getConfig(appKey)];
                        case 2:
                            _d.sent();
                            _d.label = 3;
                        case 3:
                            if (this._configMap.has(appKey)) {
                                config = this._configMap.get(appKey);
                                if (!(config === null || config === void 0 ? void 0 : config.enabled)) {
                                    return [2 /*return*/];
                                }
                            }
                            this._reportEventsToServer(appKey, groupByAppKey[appKey]);
                            _d.label = 4;
                        case 4:
                            _i++;
                            return [3 /*break*/, 1];
                        case 5:
                            this._eventsCache = [];
                            return [2 /*return*/];
                    }
                });
            }); };
            if (immediate) {
                execute();
            }
            if (this._queueTimer) {
                return;
            }
            this._queueTimer = setInterval(function () {
                if (_this._eventsCache.length === 0) {
                    _this._queueTimer && clearInterval(_this._queueTimer);
                    _this._queueTimer = undefined;
                    return;
                }
                execute();
            }, EVENT_REPORT_INTERVAL);
        };
        XKitReporter.prototype._determineMaxRetry = function (events) {
            var e_1, _a;
            var retry = LOW_PRIORITY_RETRY;
            try {
                for (var events_1 = __values(events), events_1_1 = events_1.next(); !events_1_1.done; events_1_1 = events_1.next()) {
                    var event_1 = events_1_1.value;
                    if (event_1.priority === exports.EventPriority.HIGH) {
                        retry = HIGH_PRIORITY_RETRY;
                        break;
                    }
                    if (event_1.priority === exports.EventPriority.NORMAL) {
                        retry = NORMAL_PRIORITY_RETRY;
                    }
                }
            }
            catch (e_1_1) { e_1 = { error: e_1_1 }; }
            finally {
                try {
                    if (events_1_1 && !events_1_1.done && (_a = events_1.return)) _a.call(events_1);
                }
                finally { if (e_1) throw e_1.error; }
            }
            return retry;
        };
        XKitReporter.prototype._reportEventsToServer = function (appKey, events) {
            return __awaiter(this, void 0, void 0, function () {
                var config, groupByEventId, maxRetry, retry, data, networkRequest;
                var _this = this;
                return __generator(this, function (_a) {
                    if (!this._configMap.has(appKey)) {
                        return [2 /*return*/];
                    }
                    config = this._configMap.get(appKey);
                    groupByEventId = events.reduce(function (acc, obj) {
                        var _a, _b, _c, _d;
                        if (((_a = config === null || config === void 0 ? void 0 : config.blacklist) === null || _a === void 0 ? void 0 : _a.length) > 0 &&
                            ((_b = config === null || config === void 0 ? void 0 : config.blacklist) === null || _b === void 0 ? void 0 : _b.includes(obj.component))) {
                            return acc;
                        }
                        //blacklist 不包含A，whitelist 为空 ： 允许 A 上报
                        if (((_c = config === null || config === void 0 ? void 0 : config.whitelist) === null || _c === void 0 ? void 0 : _c.length) > 0 &&
                            !((_d = config === null || config === void 0 ? void 0 : config.whitelist) === null || _d === void 0 ? void 0 : _d.includes(obj.component))) {
                            return acc;
                        }
                        var key = obj.eventId;
                        if (!acc[key]) {
                            acc[key] = [];
                        }
                        acc[key].push(__assign(__assign({}, obj.data), { appKey: obj.appKey, component: obj.component, version: obj.version, framework: obj.framework }));
                        return acc;
                    }, {});
                    maxRetry = this._determineMaxRetry(events);
                    retry = 0;
                    data = {
                        common: this.common,
                        event: groupByEventId,
                    };
                    networkRequest = function () {
                        request({
                            method: 'POST',
                            url: url,
                            headers: {
                                appkey: appKey,
                                sdktype: HEADER_VALUE_SDK_TYPE,
                                ver: HEADER_VALUE_REPORTER_VERSION,
                                'Content-Type': HEADER_VALUE_CONTENT_TYPE,
                            },
                            data: data,
                        }).catch(function () {
                            if (retry <= maxRetry) {
                                setTimeout(networkRequest, 2000 * retry);
                            }
                            else {
                                _this._logger.debug("Failed to report events to server after ".concat(retry, " retries."), data);
                            }
                            retry++;
                        });
                    };
                    networkRequest();
                    return [2 /*return*/];
                });
            });
        };
        XKitReporter.setAppInfo = function (info) {
            window.__XKitReporter__ = {
                packageId: info === null || info === void 0 ? void 0 : info.packageId,
                appName: info === null || info === void 0 ? void 0 : info.appName,
                appVer: info === null || info === void 0 ? void 0 : info.appVer,
            };
        };
        XKitReporter.getInstance = function (options) {
            if (!options) {
                if (!this.instance) {
                    throw new Error('XKitReporter not initialized');
                }
                return this.instance;
            }
            if (!this.instance) {
                this.instance = new XKitReporter(options);
            }
            return this.instance;
        };
        return XKitReporter;
    }());
    var XKitReporter$1 = XKitReporter;

    exports.EventStep = EventStep;
    exports.EventTracking = EventTracking$1;
    exports.IntervalEvent = IntervalEvent;
    exports.ReportEvent = ReportEvent;
    exports.Storage = index;
    exports.VisibilityObserver = VisibilityObserver$1;
    exports.XKitReporter = XKitReporter$1;
    exports.addUrlSearch = addUrlSearch;
    exports.createLoggerDecorator = createLoggerDecorator;
    exports.debounce = debounce;
    exports.frequencyControl = frequencyControl;
    exports.getBrowserInfo = getBrowserInfo;
    exports.getFileType = getFileType;
    exports.getOperatingSystem = getOperatingSystem;
    exports.logDebug = logDebug$1;
    exports.parseFileSize = parseFileSize;
    exports.request = request;
    });

    var name = "@xkit-yx/im-flutter-kit";
    var version = "0.0.1";
    var description = "";
    var main = "dist/index.esm.js";
    var module = "dist/index.esm.js";
    var typings = "dist/types/index.d.ts";
    var scripts = {
    	watch: "rollup -c -w --env DEV",
    	dev: "rm -rf ./dist && rollup -c --environment DEV",
    	build: "rm -rf ./dist && rollup -c --environment PROD"
    };
    var author = "";
    var license = "MIT";
    var files = [
    	"dist"
    ];
    var devDependencies = {
    	"@rollup/plugin-commonjs": "^17.1.0",
    	"@rollup/plugin-json": "^4.1.0",
    	"@rollup/plugin-node-resolve": "^11.2.0",
    	"@types/node": "^12.12.7",
    	"@typescript-eslint/eslint-plugin": "^2.6.1",
    	"@typescript-eslint/parser": "^2.6.1",
    	eslint: "^6.6.0",
    	"eslint-config-prettier": "^6.5.0",
    	"eslint-formatter-friendly": "^7.0.0",
    	"eslint-plugin-prettier": "^3.1.1",
    	prettier: "^2.0.0",
    	rollup: "^2.39.0",
    	"rollup-plugin-terser": "^7.0.2",
    	"rollup-plugin-typescript2": "^0.31.0",
    	tslib: "^2.3.1",
    	typescript: "^4.8.2"
    };
    var dependencies = {
    	"@xkit-yx/utils": "^0.7.0",
    	"nim-web-sdk-ng": "^10.3.0"
    };
    var packageJson = {
    	name: name,
    	version: version,
    	"private": true,
    	description: description,
    	main: main,
    	module: module,
    	typings: typings,
    	scripts: scripts,
    	author: author,
    	license: license,
    	files: files,
    	devDependencies: devDependencies,
    	dependencies: dependencies
    };

    var logger = index_cjs.logDebug({
        level: 'debug',
        version: packageJson.version,
        appName: packageJson.name,
    });

    var successRes = function (data) {
        return {
            code: 0,
            data: data,
        };
    };
    var failRes = function (error) {
        var _a;
        return {
            code: (_a = error.code) !== null && _a !== void 0 ? _a : -1,
            errorDetails: error.desc + '' || '',
            errorMsg: error.toString ? error.toString() : error,
        };
    };
    var formatV2Message = function (msg) {
        return __assign(__assign({}, msg), { attachment: msg.attachment
                ? __assign(__assign({}, msg.attachment), { nimCoreMessageType: msg.messageType }) : void 0 });
    };
    var formatV2ConversationLastMessage = function (conversation) {
        return __assign(__assign({}, conversation), { lastMessage: conversation.lastMessage
                ? __assign(__assign({}, conversation.lastMessage), { attachment: conversation.lastMessage.attachment
                        ? __assign(__assign({}, conversation.lastMessage.attachment), { nimCoreMessageType: conversation.lastMessage.messageType }) : void 0 }) : void 0 });
    };
    var emit = function (serviceName, methodName, params) {
        logger.log('emit: ', { serviceName: serviceName, methodName: methodName, params: params });
        if (!window.__yx_emit__) {
            window.__yx_emit__ = function (serviceName, methodName, params) {
                return { serviceName: serviceName, methodName: methodName, params: params };
            };
        }
        return window.__yx_emit__(serviceName, methodName, params);
    };

    /**
     * 
     *   Version: 10.3.0
     * 
     *   Git Hash: 5ff1b66dcaa8bef14b6bea572c7d8002e9b87bb0
     * 
     *   Created At: 2024/7/4 19:22:27
     * 
     *   Target: NIM_BROWSER_SDK.js
     *   
     */

    var NIM_BROWSER_SDK = createCommonjsModule(function (module, exports) {
    });

    var V2NIM = /*@__PURE__*/getDefaultExportFromCjs(NIM_BROWSER_SDK);

    var TAG_NAME$c = 'InitializeService';
    var loggerDec$c = index_cjs.createLoggerDecorator(TAG_NAME$c, logger);
    var InitializeService = /** @class */ (function () {
        function InitializeService(rootService, nim) {
            this.rootService = rootService;
            this.nim = nim;
        }
        // 用户初始化传参保存
        InitializeService.prototype.initialize = function (options) {
            var _a, _b, _c;
            return __awaiter(this, void 0, void 0, function () {
                var nim;
                return __generator(this, function (_d) {
                    this.initOptions = options;
                    nim = V2NIM.getInstance(options.initializeOptions, __assign(__assign({}, options.otherOptions), { cloudStorageConfig: __assign(__assign({}, (_a = options.otherOptions) === null || _a === void 0 ? void 0 : _a.cloudStorageConfig), { s3: ((_c = (_b = options.otherOptions) === null || _b === void 0 ? void 0 : _b.cloudStorageConfig) === null || _c === void 0 ? void 0 : _c.s3) ? window.s3 : void 0 }) }));
                    Object.assign(this.nim, nim);
                    // 如果这里参数有 debug 级别，就在这里设置
                    if (options.initializeOptions.debugLevel &&
                        options.initializeOptions.debugLevel !== 'off') {
                        logger.setLevel(options.initializeOptions.debugLevel);
                    }
                    else {
                        logger.setLevel('silent');
                    }
                    this.rootService.init();
                    return [2 /*return*/, successRes()];
                });
            });
        };
        InitializeService.prototype.releaseDesktop = function () {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    this.rootService.destroy();
                    return [2 /*return*/, successRes()];
                });
            });
        };
        InitializeService.prototype.destroy = function () {
            //
        };
        __decorate([
            loggerDec$c
        ], InitializeService.prototype, "initialize", null);
        __decorate([
            loggerDec$c
        ], InitializeService.prototype, "releaseDesktop", null);
        return InitializeService;
    }());

    var NOT_IMPLEMENTED_ERROR = {
        code: -1,
        errorDetails: 'Not Implemented',
    };
    var YX_EMIT_RESULT = '__yx_result__';
    var defaultDelay = 500;

    var TAG_NAME$b = 'LoginService';
    var loggerDec$b = index_cjs.createLoggerDecorator(TAG_NAME$b, logger);
    var LoginService = /** @class */ (function () {
        function LoginService(rootService, nim) {
            this.rootService = rootService;
            this.nim = nim;
            this._onLoginStatus = this._onLoginStatus.bind(this);
            this._onLoginFailed = this._onLoginFailed.bind(this);
            this._onKickedOffline = this._onKickedOffline.bind(this);
            this._onLoginClientChanged = this._onLoginClientChanged.bind(this);
            this._onConnectStatus = this._onConnectStatus.bind(this);
            this._onDisconnected = this._onDisconnected.bind(this);
            this._onConnectFailed = this._onConnectFailed.bind(this);
            this._onDataSync = this._onDataSync.bind(this);
            // 登录状态变化
            nim.V2NIMLoginService.on('onLoginStatus', this._onLoginStatus);
            // 登录失败
            nim.V2NIMLoginService.on('onLoginFailed', this._onLoginFailed);
            // 被踢下线
            nim.V2NIMLoginService.on('onKickedOffline', this._onKickedOffline);
            // 多端登录回调
            nim.V2NIMLoginService.on('onLoginClientChanged', this._onLoginClientChanged);
            // 连接状态变化
            nim.V2NIMLoginService.on('onConnectStatus', this._onConnectStatus);
            // 登录连接断开
            nim.V2NIMLoginService.on('onDisconnected', this._onDisconnected);
            // 登录连接失败
            nim.V2NIMLoginService.on('onConnectFailed', this._onConnectFailed);
            // 数据同步
            nim.V2NIMLoginService.on('onDataSync', this._onDataSync);
        }
        LoginService.prototype.login = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_1;
                var _this = this;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMLoginService.login(params.accountId, params.token, __assign(__assign({}, params.option), { tokenProvider: function (accountId) { return __awaiter(_this, void 0, void 0, function () {
                                        var params;
                                        var _a;
                                        var _this = this;
                                        return __generator(this, function (_b) {
                                            params = (_a = { accountId: accountId }, _a[YX_EMIT_RESULT] = '', _a);
                                            emit('LoginService', 'getToken', params);
                                            return [2 /*return*/, new Promise(function (resolve) {
                                                    var _a, _b;
                                                    setTimeout(function () {
                                                        resolve(params[YX_EMIT_RESULT]);
                                                    }, ((_b = (_a = _this.rootService.InitializeService.initOptions) === null || _a === void 0 ? void 0 : _a.initializeOptions) === null || _b === void 0 ? void 0 : _b.tokenProviderDelay) || defaultDelay);
                                                })];
                                        });
                                    }); }, loginExtensionProvider: function (accountId) { return __awaiter(_this, void 0, void 0, function () {
                                        var params;
                                        var _a;
                                        var _this = this;
                                        return __generator(this, function (_b) {
                                            params = (_a = { accountId: accountId }, _a[YX_EMIT_RESULT] = '', _a);
                                            emit('LoginService', 'getLoginExtension', params);
                                            return [2 /*return*/, new Promise(function (resolve) {
                                                    var _a, _b;
                                                    setTimeout(function () {
                                                        resolve(params[YX_EMIT_RESULT]);
                                                    }, ((_b = (_a = _this.rootService.InitializeService.initOptions) === null || _a === void 0 ? void 0 : _a.initializeOptions) === null || _b === void 0 ? void 0 : _b.loginExtensionProviderDelay) || defaultDelay);
                                                })];
                                        });
                                    }); } }))];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_1 = _b.sent();
                            throw failRes(error_1);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        LoginService.prototype.logout = function () {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_2;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMLoginService.logout()];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_2 = _b.sent();
                            throw failRes(error_2);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        LoginService.prototype.getLoginUser = function () {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    return [2 /*return*/, successRes(this.nim.V2NIMLoginService.getLoginUser())];
                });
            });
        };
        LoginService.prototype.getLoginStatus = function () {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    return [2 /*return*/, successRes({ status: this.nim.V2NIMLoginService.getLoginStatus() })];
                });
            });
        };
        LoginService.prototype.getLoginClients = function () {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    return [2 /*return*/, successRes({
                            loginClient: this.nim.V2NIMLoginService.getLoginClients(),
                        })];
                });
            });
        };
        LoginService.prototype.kickOffline = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_3;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMLoginService.kickOffline(params.client)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_3 = _b.sent();
                            throw failRes(error_3);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        LoginService.prototype.getKickedOfflineDetail = function () {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    return [2 /*return*/, successRes(this.nim.V2NIMLoginService.getKickedOfflineDetail())];
                });
            });
        };
        LoginService.prototype.getConnectStatus = function () {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    return [2 /*return*/, successRes({ status: this.nim.V2NIMLoginService.getConnectStatus() })];
                });
            });
        };
        LoginService.prototype.getDataSync = function () {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    return [2 /*return*/, successRes({
                            dataSync: this.nim.V2NIMLoginService.getDataSync() || [],
                        })];
                });
            });
        };
        LoginService.prototype.getChatroomLinkAddress = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_4;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMLoginService.getChatroomLinkAddress(params.roomId, false)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.linkAddress = _c.sent(),
                                    _b)])];
                        case 2:
                            error_4 = _c.sent();
                            throw failRes(error_4);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        LoginService.prototype.setReconnectDelayProvider = function () {
            return __awaiter(this, void 0, void 0, function () {
                var _this = this;
                return __generator(this, function (_a) {
                    return [2 /*return*/, successRes(
                        // @ts-ignore
                        this.nim.V2NIMLoginService.setReconnectDelayProvider(function (delay) { return __awaiter(_this, void 0, void 0, function () {
                            var params;
                            var _a;
                            var _this = this;
                            return __generator(this, function (_b) {
                                params = (_a = { delay: delay }, _a[YX_EMIT_RESULT] = 0, _a);
                                emit('LoginService', 'getReconnectDelay', params);
                                return [2 /*return*/, new Promise(function (resolve) {
                                        var _a, _b;
                                        setTimeout(function () {
                                            // @ts-ignore
                                            resolve(params[YX_EMIT_RESULT]);
                                        }, ((_b = (_a = _this.rootService.InitializeService.initOptions) === null || _a === void 0 ? void 0 : _a.initializeOptions) === null || _b === void 0 ? void 0 : _b.reconnectDelayProviderDelay) || defaultDelay);
                                    })];
                            });
                        }); }))];
                });
            });
        };
        LoginService.prototype.destroy = function () {
            this.nim.V2NIMLoginService.off('onLoginStatus', this._onLoginStatus);
            this.nim.V2NIMLoginService.off('onLoginFailed', this._onLoginFailed);
            this.nim.V2NIMLoginService.off('onKickedOffline', this._onKickedOffline);
            this.nim.V2NIMLoginService.off('onLoginClientChanged', this._onLoginClientChanged);
            this.nim.V2NIMLoginService.off('onConnectStatus', this._onConnectStatus);
            this.nim.V2NIMLoginService.off('onDisconnected', this._onDisconnected);
            this.nim.V2NIMLoginService.off('onConnectFailed', this._onConnectFailed);
            this.nim.V2NIMLoginService.off('onDataSync', this._onDataSync);
        };
        LoginService.prototype._onLoginStatus = function (status) {
            logger.log('_onLoginStatus', status);
            emit('LoginService', 'onLoginStatus', { status: status });
        };
        LoginService.prototype._onLoginFailed = function (e) {
            logger.log('_onLoginFailed', e);
            emit('LoginService', 'onLoginFailed', e);
        };
        LoginService.prototype._onKickedOffline = function (e) {
            logger.log('_onKickedOffline', e);
            emit('LoginService', 'onKickedOffline', e);
        };
        LoginService.prototype._onLoginClientChanged = function (change, clients) {
            logger.log('_onLoginClientChanged', change, clients);
            emit('LoginService', 'onLoginClientChanged', { change: change, clients: clients });
        };
        LoginService.prototype._onConnectStatus = function (status) {
            logger.log('_onConnectStatus', status);
            emit('LoginService', 'onConnectStatus', { status: status });
        };
        LoginService.prototype._onDisconnected = function (e) {
            logger.log('_onDisconnected', e);
            emit('LoginService', 'onDisconnected', e);
        };
        LoginService.prototype._onConnectFailed = function (e) {
            logger.log('_onConnectFailed', e);
            emit('LoginService', 'onConnectFailed', e);
        };
        LoginService.prototype._onDataSync = function (type, state, error) {
            logger.log('_onDataSync', { type: type, state: state, error: error });
            emit('LoginService', 'onDataSync', { type: type, state: state, error: error });
        };
        __decorate([
            loggerDec$b
        ], LoginService.prototype, "login", null);
        __decorate([
            loggerDec$b
        ], LoginService.prototype, "logout", null);
        __decorate([
            loggerDec$b
        ], LoginService.prototype, "getLoginUser", null);
        __decorate([
            loggerDec$b
        ], LoginService.prototype, "getLoginStatus", null);
        __decorate([
            loggerDec$b
        ], LoginService.prototype, "getLoginClients", null);
        __decorate([
            loggerDec$b
        ], LoginService.prototype, "kickOffline", null);
        __decorate([
            loggerDec$b
        ], LoginService.prototype, "getKickedOfflineDetail", null);
        __decorate([
            loggerDec$b
        ], LoginService.prototype, "getConnectStatus", null);
        __decorate([
            loggerDec$b
        ], LoginService.prototype, "getDataSync", null);
        __decorate([
            loggerDec$b
        ], LoginService.prototype, "getChatroomLinkAddress", null);
        __decorate([
            loggerDec$b
        ], LoginService.prototype, "setReconnectDelayProvider", null);
        return LoginService;
    }());

    var TAG_NAME$a = 'SettingsService';
    var loggerDec$a = index_cjs.createLoggerDecorator(TAG_NAME$a, logger);
    var SettingsService = /** @class */ (function () {
        function SettingsService(rootService, nim) {
            this.rootService = rootService;
            this.nim = nim;
            this._onP2PMessageMuteModeChanged =
                this._onP2PMessageMuteModeChanged.bind(this);
            this._onTeamMessageMuteModeChanged =
                this._onTeamMessageMuteModeChanged.bind(this);
            this.nim.V2NIMSettingService.on('onP2PMessageMuteModeChanged', this._onP2PMessageMuteModeChanged);
            this.nim.V2NIMSettingService.on('onTeamMessageMuteModeChanged', this._onTeamMessageMuteModeChanged);
        }
        SettingsService.prototype.destroy = function () {
            this.nim.V2NIMSettingService.off('onP2PMessageMuteModeChanged', this._onP2PMessageMuteModeChanged);
            this.nim.V2NIMSettingService.off('onTeamMessageMuteModeChanged', this._onTeamMessageMuteModeChanged);
        };
        SettingsService.prototype.getDndConfig = function () {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        SettingsService.prototype.getConversationMuteStatus = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    try {
                        return [2 /*return*/, successRes(this.nim.V2NIMSettingService.getConversationMuteStatus(params.conversationId))];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        SettingsService.prototype.setTeamMessageMuteMode = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_1;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMSettingService.setTeamMessageMuteMode(params.teamId, params.teamType, params.muteMode)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_1 = _b.sent();
                            throw failRes(error_1);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        SettingsService.prototype.getTeamMessageMuteMode = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    try {
                        return [2 /*return*/, successRes({
                                muteMode: this.nim.V2NIMSettingService.getTeamMessageMuteMode(params.teamId, params.teamType),
                            })];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        SettingsService.prototype.setP2PMessageMuteMode = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_2;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMSettingService.setP2PMessageMuteMode(params.accountId, params.muteMode)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_2 = _b.sent();
                            throw failRes(error_2);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        SettingsService.prototype.getP2PMessageMuteMode = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    try {
                        return [2 /*return*/, successRes({
                                muteMode: this.nim.V2NIMSettingService.getP2PMessageMuteMode(params.accountId),
                            })];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        SettingsService.prototype.getP2PMessageMuteList = function () {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_3;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMSettingService.getP2PMessageMuteList()];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.muteList = _c.sent(),
                                    _b)])];
                        case 2:
                            error_3 = _c.sent();
                            throw failRes(error_3);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        SettingsService.prototype.setAppBackground = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_4;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMSettingService.setAppBackground(params.isBackground, params.badge)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_4 = _b.sent();
                            throw failRes(error_4);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        SettingsService.prototype.setPushMobileOnDesktopOnline = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_5;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMSettingService.setPushMobileOnDesktopOnline(params.need)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_5 = _b.sent();
                            throw failRes(error_5);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        SettingsService.prototype.setDndConfig = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        SettingsService.prototype.getApnsDndConfig = function () {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        SettingsService.prototype._onP2PMessageMuteModeChanged = function (accountId, muteMode) {
            logger.info('_onP2PMessageMuteModeChanged', accountId, muteMode);
            emit('SettingsService', 'onP2PMessageMuteModeChanged', {
                accountId: accountId,
                muteMode: muteMode,
            });
        };
        SettingsService.prototype._onTeamMessageMuteModeChanged = function (teamId, teamType, muteMode) {
            logger.info('_onTeamMessageMuteModeChanged', teamId, teamType, muteMode);
            emit('SettingsService', 'onTeamMessageMuteModeChanged', {
                teamId: teamId,
                teamType: teamType,
                muteMode: muteMode,
            });
        };
        __decorate([
            loggerDec$a
        ], SettingsService.prototype, "getDndConfig", null);
        __decorate([
            loggerDec$a
        ], SettingsService.prototype, "getConversationMuteStatus", null);
        __decorate([
            loggerDec$a
        ], SettingsService.prototype, "setTeamMessageMuteMode", null);
        __decorate([
            loggerDec$a
        ], SettingsService.prototype, "getTeamMessageMuteMode", null);
        __decorate([
            loggerDec$a
        ], SettingsService.prototype, "setP2PMessageMuteMode", null);
        __decorate([
            loggerDec$a
        ], SettingsService.prototype, "getP2PMessageMuteMode", null);
        __decorate([
            loggerDec$a
        ], SettingsService.prototype, "getP2PMessageMuteList", null);
        __decorate([
            loggerDec$a
        ], SettingsService.prototype, "setAppBackground", null);
        __decorate([
            loggerDec$a
        ], SettingsService.prototype, "setPushMobileOnDesktopOnline", null);
        __decorate([
            loggerDec$a
        ], SettingsService.prototype, "setDndConfig", null);
        __decorate([
            loggerDec$a
        ], SettingsService.prototype, "getApnsDndConfig", null);
        return SettingsService;
    }());

    var TAG_NAME$9 = 'MessageService';
    var loggerDec$9 = index_cjs.createLoggerDecorator(TAG_NAME$9, logger);
    var MessageService = /** @class */ (function () {
        function MessageService(rootService, nim) {
            this.rootService = rootService;
            this.nim = nim;
            this._onReceiveMessages = this._onReceiveMessages.bind(this);
            this._onClearHistoryNotifications =
                this._onClearHistoryNotifications.bind(this);
            this._onMessageDeletedNotifications =
                this._onMessageDeletedNotifications.bind(this);
            this._onMessagePinNotification = this._onMessagePinNotification.bind(this);
            this._onMessageQuickCommentNotification =
                this._onMessageQuickCommentNotification.bind(this);
            this._onMessageRevokeNotifications =
                this._onMessageRevokeNotifications.bind(this);
            this._onReceiveP2PMessageReadReceipts =
                this._onReceiveP2PMessageReadReceipts.bind(this);
            this._onReceiveTeamMessageReadReceipts =
                this._onReceiveTeamMessageReadReceipts.bind(this);
            this._onSendMessage = this._onSendMessage.bind(this);
            // 收到消息
            nim.V2NIMMessageService.on('onReceiveMessages', this._onReceiveMessages);
            // 清空会话历史消息通知
            nim.V2NIMMessageService.on('onClearHistoryNotifications', this._onClearHistoryNotifications);
            // 消息被删除通知
            nim.V2NIMMessageService.on('onMessageDeletedNotifications', this._onMessageDeletedNotifications);
            // 收到消息 pin 状态更新
            nim.V2NIMMessageService.on('onMessagePinNotification', this._onMessagePinNotification);
            // 收到消息快捷评论更新
            nim.V2NIMMessageService.on('onMessageQuickCommentNotification', this._onMessageQuickCommentNotification);
            // 收到消息撤回通知
            nim.V2NIMMessageService.on('onMessageRevokeNotifications', this._onMessageRevokeNotifications);
            // 收到点对点消息的已读回执
            nim.V2NIMMessageService.on('onReceiveP2PMessageReadReceipts', this._onReceiveP2PMessageReadReceipts);
            // 收到群消息的已读回执
            nim.V2NIMMessageService.on('onReceiveTeamMessageReadReceipts', this._onReceiveTeamMessageReadReceipts);
            // 本端发送消息状态回调
            nim.V2NIMMessageService.on('onSendMessage', this._onSendMessage);
        }
        MessageService.prototype.destroy = function () {
            this.nim.V2NIMMessageService.off('onReceiveMessages', this._onReceiveMessages);
            this.nim.V2NIMMessageService.off('onClearHistoryNotifications', this._onClearHistoryNotifications);
            this.nim.V2NIMMessageService.off('onMessageDeletedNotifications', this._onMessageDeletedNotifications);
            this.nim.V2NIMMessageService.off('onMessagePinNotification', this._onMessagePinNotification);
            this.nim.V2NIMMessageService.off('onMessageQuickCommentNotification', this._onMessageQuickCommentNotification);
            this.nim.V2NIMMessageService.off('onMessageRevokeNotifications', this._onMessageRevokeNotifications);
            this.nim.V2NIMMessageService.off('onReceiveP2PMessageReadReceipts', this._onReceiveP2PMessageReadReceipts);
            this.nim.V2NIMMessageService.off('onReceiveTeamMessageReadReceipts', this._onReceiveTeamMessageReadReceipts);
            this.nim.V2NIMMessageService.off('onSendMessage', this._onSendMessage);
        };
        MessageService.prototype.getMessageList = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_1;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMMessageService.getMessageList(params.option)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.messages = (_c.sent()).map(function (item) { return formatV2Message(item); }),
                                    _b)])];
                        case 2:
                            error_1 = _c.sent();
                            throw failRes(error_1);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.getMessageListByIds = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        MessageService.prototype.getMessageListByRefers = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_2;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMMessageService.getMessageListByRefers(params.messageRefers)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.messages = (_c.sent()).map(function (item) { return formatV2Message(item); }),
                                    _b)])];
                        case 2:
                            error_2 = _c.sent();
                            throw failRes(error_2);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.searchCloudMessages = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_3;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMMessageService.searchCloudMessages(params.params)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.messages = (_c.sent()).map(function (item) { return formatV2Message(item); }),
                                    _b)])];
                        case 2:
                            error_3 = _c.sent();
                            throw failRes(error_3);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.getLocalThreadMessageList = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        MessageService.prototype.getThreadMessageList = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var res, error_4;
                return __generator(this, function (_a) {
                    switch (_a.label) {
                        case 0:
                            _a.trys.push([0, 2, , 3]);
                            return [4 /*yield*/, this.nim.V2NIMMessageService.getThreadMessageList(params.option)];
                        case 1:
                            res = _a.sent();
                            return [2 /*return*/, successRes(__assign(__assign({}, res), { message: formatV2Message(res.message) }))];
                        case 2:
                            error_4 = _a.sent();
                            throw failRes(error_4);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.insertMessageToLocal = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        MessageService.prototype.updateMessageLocalExtension = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        MessageService.prototype.sendMessage = function (params) {
            var _a, _b, _c, _d;
            return __awaiter(this, void 0, void 0, function () {
                var messageClientId_1, msg, finalMsg, res, error_5;
                return __generator(this, function (_e) {
                    switch (_e.label) {
                        case 0:
                            _e.trys.push([0, 2, , 3]);
                            messageClientId_1 = params.message.messageClientId;
                            msg = (_b = (_a = this.rootService.MessageCreatorService) === null || _a === void 0 ? void 0 : _a.msgMap) === null || _b === void 0 ? void 0 : _b.get(messageClientId_1);
                            finalMsg = __assign(__assign({}, params.message), msg);
                            return [4 /*yield*/, this.nim.V2NIMMessageService.sendMessage(finalMsg, params.conversationId, params.params, function (percentage) {
                                    emit('MessageService', 'onSendMessageProgress', {
                                        messageClientId: messageClientId_1,
                                        percentage: percentage,
                                    });
                                })];
                        case 1:
                            res = _e.sent();
                            (_d = (_c = this.rootService.MessageCreatorService) === null || _c === void 0 ? void 0 : _c.msgMap) === null || _d === void 0 ? void 0 : _d.delete(messageClientId_1);
                            return [2 /*return*/, successRes(__assign(__assign({}, res), { message: formatV2Message(res.message) }))];
                        case 2:
                            error_5 = _e.sent();
                            throw failRes(error_5);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.replyMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var res, error_6;
                return __generator(this, function (_a) {
                    switch (_a.label) {
                        case 0:
                            _a.trys.push([0, 2, , 3]);
                            return [4 /*yield*/, this.nim.V2NIMMessageService.replyMessage(params.message, params.replyMessage, params.params, function (percentage) {
                                    emit('MessageService', 'onSendMessageProgress', {
                                        messageClientId: params.message.messageClientId,
                                        percentage: percentage,
                                    });
                                })];
                        case 1:
                            res = _a.sent();
                            return [2 /*return*/, successRes(__assign(__assign({}, res), { message: formatV2Message(res.message) }))];
                        case 2:
                            error_6 = _a.sent();
                            throw failRes(error_6);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.revokeMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_7;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.revokeMessage(params.message, params.revokeParams)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_7 = _b.sent();
                            throw failRes(error_7);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.pinMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_8;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.pinMessage(params.message, params.serverExtension)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_8 = _b.sent();
                            throw failRes(error_8);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.unpinMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_9;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.unpinMessage(params.messageRefer, params.serverExtension)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_9 = _b.sent();
                            throw failRes(error_9);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.updatePinMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_10;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.updatePinMessage(params.message, params.serverExtension)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_10 = _b.sent();
                            throw failRes(error_10);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.getPinnedMessageList = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_11;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMMessageService.getPinnedMessageList(params.conversationId)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.pinMessages = _c.sent(),
                                    _b)])];
                        case 2:
                            error_11 = _c.sent();
                            throw failRes(error_11);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.addQuickComment = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_12;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.addQuickComment(params.message, params.index, params.serverExtension, params.pushConfig)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_12 = _b.sent();
                            throw failRes(error_12);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.removeQuickComment = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_13;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.removeQuickComment(params.messageRefer, params.index, params.serverExtension)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_13 = _b.sent();
                            throw failRes(error_13);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.getQuickCommentList = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_14;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.getQuickCommentList(params.messages)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_14 = _b.sent();
                            throw failRes(error_14);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.deleteMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_15;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.deleteMessage(params.message, params.serverExtension)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_15 = _b.sent();
                            throw failRes(error_15);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.deleteMessages = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_16;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.deleteMessages(params.messages, params.serverExtension)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_16 = _b.sent();
                            throw failRes(error_16);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.clearHistoryMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_17;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.clearHistoryMessage(params.option)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_17 = _b.sent();
                            throw failRes(error_17);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.sendP2PMessageReceipt = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_18;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.sendP2PMessageReceipt(params.message)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_18 = _b.sent();
                            throw failRes(error_18);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.getP2PMessageReceipt = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_19;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.getP2PMessageReceipt(params.conversationId)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_19 = _b.sent();
                            throw failRes(error_19);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.isPeerRead = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    try {
                        return [2 /*return*/, successRes(this.nim.V2NIMMessageService.isPeerRead(params.message))];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        MessageService.prototype.sendTeamMessageReceipts = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_20;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.sendTeamMessageReceipts(params.messages)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_20 = _b.sent();
                            throw failRes(error_20);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.getTeamMessageReceipts = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_21;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMMessageService.getTeamMessageReceipts(params.messages)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.readReceipts = _c.sent(),
                                    _b)])];
                        case 2:
                            error_21 = _c.sent();
                            throw failRes(error_21);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.getTeamMessageReceiptDetail = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_22;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.getTeamMessageReceiptDetail(params.message, params.memberAccountIds)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_22 = _b.sent();
                            throw failRes(error_22);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.addCollection = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_23;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.addCollection(params.params)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_23 = _b.sent();
                            throw failRes(error_23);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.removeCollections = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_24;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.removeCollections(params.collections)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_24 = _b.sent();
                            throw failRes(error_24);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.updateCollectionExtension = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_25;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.updateCollectionExtension(params.collection, params.serverExtension)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_25 = _b.sent();
                            throw failRes(error_25);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.getCollectionListByOption = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_26;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMMessageService.getCollectionListByOption(params.option)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.collections = _c.sent(),
                                    _b)])];
                        case 2:
                            error_26 = _c.sent();
                            throw failRes(error_26);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.voiceToText = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_27;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.voiceToText(params.params)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_27 = _b.sent();
                            throw failRes(error_27);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype.cancelMessageAttachmentUpload = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_28;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMMessageService.cancelMessageAttachmentUpload(params.message)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_28 = _b.sent();
                            throw failRes(error_28);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        MessageService.prototype._onReceiveMessages = function (messages) {
            logger.log('_onReceiveMessages', messages);
            emit('MessageService', 'onReceiveMessages', {
                messages: messages.map(function (item) { return formatV2Message(item); }),
            });
        };
        MessageService.prototype._onClearHistoryNotifications = function (notification) {
            logger.log('_onClearHistoryNotifications', notification);
            emit('MessageService', 'onClearHistoryNotifications', {
                clearHistoryNotifications: notification,
            });
        };
        MessageService.prototype._onMessageDeletedNotifications = function (notification) {
            logger.log('_onMessageDeletedNotifications', notification);
            emit('MessageService', 'onMessageDeletedNotifications', {
                deletedNotifications: notification,
            });
        };
        MessageService.prototype._onMessagePinNotification = function (notification) {
            logger.log('_onMessagePinNotification', notification);
            emit('MessageService', 'onMessagePinNotification', notification);
        };
        MessageService.prototype._onMessageQuickCommentNotification = function (notification) {
            logger.log('_onMessageQuickCommentNotification', notification);
            emit('MessageService', 'onMessageQuickCommentNotification', notification);
        };
        MessageService.prototype._onMessageRevokeNotifications = function (notification) {
            logger.log('_onMessageRevokeNotifications', notification);
            emit('MessageService', 'onMessageRevokeNotifications', {
                revokeNotifications: notification,
            });
        };
        MessageService.prototype._onReceiveP2PMessageReadReceipts = function (readReceipts) {
            logger.log('_onReceiveP2PMessageReadReceipts', readReceipts);
            emit('MessageService', 'onReceiveP2PMessageReadReceipts', {
                p2pMessageReadReceipts: readReceipts,
            });
        };
        MessageService.prototype._onReceiveTeamMessageReadReceipts = function (readReceipts) {
            logger.log('_onReceiveTeamMessageReadReceipts', readReceipts);
            emit('MessageService', 'onReceiveTeamMessageReadReceipts', {
                teamMessageReadReceipts: readReceipts,
            });
        };
        MessageService.prototype._onSendMessage = function (message) {
            logger.log('_onSendMessage', message);
            emit('MessageService', 'onSendMessage', formatV2Message(message));
        };
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "getMessageList", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "getMessageListByIds", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "getMessageListByRefers", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "searchCloudMessages", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "getLocalThreadMessageList", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "getThreadMessageList", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "insertMessageToLocal", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "updateMessageLocalExtension", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "sendMessage", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "replyMessage", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "revokeMessage", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "pinMessage", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "unpinMessage", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "updatePinMessage", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "getPinnedMessageList", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "addQuickComment", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "removeQuickComment", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "getQuickCommentList", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "deleteMessage", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "deleteMessages", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "clearHistoryMessage", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "sendP2PMessageReceipt", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "getP2PMessageReceipt", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "isPeerRead", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "sendTeamMessageReceipts", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "getTeamMessageReceipts", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "getTeamMessageReceiptDetail", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "addCollection", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "removeCollections", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "updateCollectionExtension", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "getCollectionListByOption", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "voiceToText", null);
        __decorate([
            loggerDec$9
        ], MessageService.prototype, "cancelMessageAttachmentUpload", null);
        return MessageService;
    }());

    var TAG_NAME$8 = 'UserService';
    var loggerDec$8 = index_cjs.createLoggerDecorator(TAG_NAME$8, logger);
    var UserService = /** @class */ (function () {
        function UserService(rootService, nim) {
            this.rootService = rootService;
            this.nim = nim;
            this._onBlockListAdded = this._onBlockListAdded.bind(this);
            this._onBlockListRemoved = this._onBlockListRemoved.bind(this);
            this._onUserProfileChanged = this._onUserProfileChanged.bind(this);
            nim.V2NIMUserService.on('onBlockListAdded', this._onBlockListAdded);
            nim.V2NIMUserService.on('onBlockListRemoved', this._onBlockListRemoved);
            nim.V2NIMUserService.on('onUserProfileChanged', this._onUserProfileChanged);
        }
        UserService.prototype.destroy = function () {
            this.nim.V2NIMUserService.off('onBlockListAdded', this._onBlockListAdded);
            this.nim.V2NIMUserService.off('onBlockListRemoved', this._onBlockListRemoved);
            this.nim.V2NIMUserService.off('onUserProfileChanged', this._onUserProfileChanged);
        };
        UserService.prototype.getUserList = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_1;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMUserService.getUserList(params.userIdList)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.userInfoList = _c.sent(),
                                    _b)])];
                        case 2:
                            error_1 = _c.sent();
                            throw failRes(error_1);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        UserService.prototype.getUserListFromCloud = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_2;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMUserService.getUserListFromCloud(params.userIdList)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.userInfoList = _c.sent(),
                                    _b)])];
                        case 2:
                            error_2 = _c.sent();
                            throw failRes(error_2);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        UserService.prototype.updateSelfUserProfile = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_3;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMUserService.updateSelfUserProfile(params.updateParam)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_3 = _b.sent();
                            throw failRes(error_3);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        UserService.prototype.addUserToBlockList = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_4;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMUserService.addUserToBlockList(params.userId)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_4 = _b.sent();
                            throw failRes(error_4);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        UserService.prototype.removeUserFromBlockList = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_5;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMUserService.removeUserFromBlockList(params.userId)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_5 = _b.sent();
                            throw failRes(error_5);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        UserService.prototype.getBlockList = function () {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_6;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMUserService.getBlockList()];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.userIdList = _c.sent(),
                                    _b)])];
                        case 2:
                            error_6 = _c.sent();
                            throw failRes(error_6);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        UserService.prototype.searchUserByOption = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_7;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMUserService.searchUserByOption(params.userSearchOption)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.userInfoList = _c.sent(),
                                    _b)])];
                        case 2:
                            error_7 = _c.sent();
                            throw failRes(error_7);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        UserService.prototype._onBlockListAdded = function (user) {
            logger.log('_onBlockListAdded', user);
            emit('UserService', 'onBlockListAdded', user);
        };
        UserService.prototype._onBlockListRemoved = function (accountId) {
            logger.log('_onBlockListRemoved', accountId);
            emit('UserService', 'onBlockListRemoved', { userId: accountId });
        };
        UserService.prototype._onUserProfileChanged = function (users) {
            logger.log('_onUserProfileChanged', users);
            emit('UserService', 'onUserProfileChanged', { userInfoList: users });
        };
        __decorate([
            loggerDec$8
        ], UserService.prototype, "getUserList", null);
        __decorate([
            loggerDec$8
        ], UserService.prototype, "getUserListFromCloud", null);
        __decorate([
            loggerDec$8
        ], UserService.prototype, "updateSelfUserProfile", null);
        __decorate([
            loggerDec$8
        ], UserService.prototype, "addUserToBlockList", null);
        __decorate([
            loggerDec$8
        ], UserService.prototype, "removeUserFromBlockList", null);
        __decorate([
            loggerDec$8
        ], UserService.prototype, "getBlockList", null);
        __decorate([
            loggerDec$8
        ], UserService.prototype, "searchUserByOption", null);
        return UserService;
    }());

    var TAG_NAME$7 = 'FriendService';
    var loggerDec$7 = index_cjs.createLoggerDecorator(TAG_NAME$7, logger);
    var FriendService = /** @class */ (function () {
        function FriendService(rootService, nim) {
            this.rootService = rootService;
            this.nim = nim;
            this._onFriendAdded = this._onFriendAdded.bind(this);
            this._onFriendDeleted = this._onFriendDeleted.bind(this);
            this._onFriendAddApplication = this._onFriendAddApplication.bind(this);
            this._onFriendAddRejected = this._onFriendAddRejected.bind(this);
            this._onFriendInfoChanged = this._onFriendInfoChanged.bind(this);
            nim.V2NIMFriendService.on('onFriendAdded', this._onFriendAdded);
            nim.V2NIMFriendService.on('onFriendDeleted', this._onFriendDeleted);
            // 申请添加好友的相关信息，其他端向本端发送好友申请,会触发该事件
            nim.V2NIMFriendService.on('onFriendAddApplication', this._onFriendAddApplication);
            // 对端拒绝本端好友申请，本端会触发该事件
            nim.V2NIMFriendService.on('onFriendAddRejected', this._onFriendAddRejected);
            // 好友信息更新回调，返回变更的好友信息，包括本端直接更新的好友信息和其他端同步更新的好友信息
            nim.V2NIMFriendService.on('onFriendInfoChanged', this._onFriendInfoChanged);
        }
        FriendService.prototype.destroy = function () {
            this.nim.V2NIMFriendService.off('onFriendAdded', this._onFriendAdded);
            this.nim.V2NIMFriendService.off('onFriendDeleted', this._onFriendDeleted);
            this.nim.V2NIMFriendService.off('onFriendAddApplication', this._onFriendAddApplication);
            this.nim.V2NIMFriendService.off('onFriendAddRejected', this._onFriendAddRejected);
            this.nim.V2NIMFriendService.off('onFriendInfoChanged', this._onFriendInfoChanged);
        };
        FriendService.prototype.addFriend = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_1;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMFriendService.addFriend(params.accountId, params.params || {
                                    addMode: NIM_BROWSER_SDK.V2NIMConst.V2NIMFriendAddMode.V2NIM_FRIEND_MODE_TYPE_ADD,
                                    postscript: '',
                                })];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_1 = _b.sent();
                            throw failRes(error_1);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        FriendService.prototype.deleteFriend = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_2;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMFriendService.deleteFriend(params.accountId, params.params || {
                                    deleteAlias: true,
                                })];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_2 = _b.sent();
                            throw failRes(error_2);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        FriendService.prototype.acceptAddApplication = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_3;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMFriendService.acceptAddApplication(params.application)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_3 = _b.sent();
                            throw failRes(error_3);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        FriendService.prototype.rejectAddApplication = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_4;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMFriendService.rejectAddApplication(params.application, params.postscript)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_4 = _b.sent();
                            throw failRes(error_4);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        FriendService.prototype.setFriendInfo = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_5;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMFriendService.setFriendInfo(params.accountId, params.params)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_5 = _b.sent();
                            throw failRes(error_5);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        FriendService.prototype.getFriendList = function () {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_6;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMFriendService.getFriendList()];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.friendList = _c.sent(),
                                    _b)])];
                        case 2:
                            error_6 = _c.sent();
                            throw failRes(error_6);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        FriendService.prototype.getFriendByIds = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_7;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMFriendService.getFriendByIds(params.accountIds)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.friendList = _c.sent(),
                                    _b)])];
                        case 2:
                            error_7 = _c.sent();
                            throw failRes(error_7);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        FriendService.prototype.checkFriend = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_8;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMFriendService.checkFriend(params.accountIds)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.result = _c.sent(),
                                    _b)])];
                        case 2:
                            error_8 = _c.sent();
                            throw failRes(error_8);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        FriendService.prototype.getAddApplicationList = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_9;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMFriendService.getAddApplicationList(params.option)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_9 = _b.sent();
                            throw failRes(error_9);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        FriendService.prototype.getAddApplicationUnreadCount = function () {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_10;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMFriendService.getAddApplicationUnreadCount()];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_10 = _b.sent();
                            throw failRes(error_10);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        FriendService.prototype.setAddApplicationRead = function () {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_11;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMFriendService.setAddApplicationRead()];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_11 = _b.sent();
                            throw failRes(error_11);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        FriendService.prototype.searchFriendByOption = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_12;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMFriendService.searchFriendByOption(params.friendSearchOption)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.friendList = _c.sent(),
                                    _b)])];
                        case 2:
                            error_12 = _c.sent();
                            throw failRes(error_12);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        /**
         * 监听添加好友
         */
        FriendService.prototype._onFriendAdded = function (friend) {
            logger.log('_onFriendAdded', friend);
            emit('FriendService', 'onFriendAdded', friend);
        };
        /**
         * 监听删除好友
         */
        FriendService.prototype._onFriendDeleted = function (accountId, deletionType) {
            logger.log('_onFriendDeleted', accountId);
            emit('FriendService', 'onFriendDeleted', { accountId: accountId, deletionType: deletionType });
        };
        /**
         * 申请添加好友的相关信息，其他端向本端发送好友申请,会触发该事件
         */
        FriendService.prototype._onFriendAddApplication = function (application) {
            logger.log('_onFriendAddApplication', application);
            emit('FriendService', 'onFriendAddApplication', application);
        };
        /**
         * 对端拒绝本端好友申请，本端会触发该事件
         */
        FriendService.prototype._onFriendAddRejected = function (rejection) {
            logger.log('_onFriendAddRejected', rejection);
            emit('FriendService', 'onFriendAddRejected', rejection);
        };
        /**
         * 好友信息更新回调，返回变更的好友信息，包括本端直接更新的好友信息和其他端同步更新的好友信息
         */
        FriendService.prototype._onFriendInfoChanged = function (friend) {
            logger.log('_onFriendInfoChanged', friend);
            emit('FriendService', 'onFriendInfoChanged', friend);
        };
        __decorate([
            loggerDec$7
        ], FriendService.prototype, "addFriend", null);
        __decorate([
            loggerDec$7
        ], FriendService.prototype, "deleteFriend", null);
        __decorate([
            loggerDec$7
        ], FriendService.prototype, "acceptAddApplication", null);
        __decorate([
            loggerDec$7
        ], FriendService.prototype, "rejectAddApplication", null);
        __decorate([
            loggerDec$7
        ], FriendService.prototype, "setFriendInfo", null);
        __decorate([
            loggerDec$7
        ], FriendService.prototype, "getFriendList", null);
        __decorate([
            loggerDec$7
        ], FriendService.prototype, "getFriendByIds", null);
        __decorate([
            loggerDec$7
        ], FriendService.prototype, "checkFriend", null);
        __decorate([
            loggerDec$7
        ], FriendService.prototype, "getAddApplicationList", null);
        __decorate([
            loggerDec$7
        ], FriendService.prototype, "getAddApplicationUnreadCount", null);
        __decorate([
            loggerDec$7
        ], FriendService.prototype, "setAddApplicationRead", null);
        __decorate([
            loggerDec$7
        ], FriendService.prototype, "searchFriendByOption", null);
        return FriendService;
    }());

    var TAG_NAME$6 = 'TeamService';
    var loggerDec$6 = index_cjs.createLoggerDecorator(TAG_NAME$6, logger);
    var TeamService = /** @class */ (function () {
        function TeamService(rootService, nim) {
            this.rootService = rootService;
            this.nim = nim;
            this._onReceiveTeamJoinActionInfo =
                this._onReceiveTeamJoinActionInfo.bind(this);
            this._onSyncFailed = this._onSyncFailed.bind(this);
            this._onSyncFinished = this._onSyncFinished.bind(this);
            this._onSyncStarted = this._onSyncStarted.bind(this);
            this._onTeamCreated = this._onTeamCreated.bind(this);
            this._onTeamDismissed = this._onTeamDismissed.bind(this);
            this._onTeamInfoUpdated = this._onTeamInfoUpdated.bind(this);
            this._onTeamJoined = this._onTeamJoined.bind(this);
            this._onTeamLeft = this._onTeamLeft.bind(this);
            this._onTeamMemberInfoUpdated = this._onTeamMemberInfoUpdated.bind(this);
            this._onTeamMemberJoined = this._onTeamMemberJoined.bind(this);
            this._onTeamMemberKicked = this._onTeamMemberKicked.bind(this);
            this._onTeamMemberLeft = this._onTeamMemberLeft.bind(this);
            // 群组申请动作回调
            nim.V2NIMTeamService.on('onReceiveTeamJoinActionInfo', this._onReceiveTeamJoinActionInfo);
            // 群组信息数据同步失败
            nim.V2NIMTeamService.on('onSyncFailed', this._onSyncFailed);
            // 群组信息数据同步完成
            nim.V2NIMTeamService.on('onSyncFinished', this._onSyncFinished);
            // 群组信息数据同步开始
            nim.V2NIMTeamService.on('onSyncStarted', this._onSyncStarted);
            // 创建群组回调
            nim.V2NIMTeamService.on('onTeamCreated', this._onTeamCreated);
            // 解散群组回调
            nim.V2NIMTeamService.on('onTeamDismissed', this._onTeamDismissed);
            // 更新群组信息回调
            nim.V2NIMTeamService.on('onTeamInfoUpdated', this._onTeamInfoUpdated);
            // 自己被邀请后接受邀请， 或申请通过，或直接被拉入群组回调
            nim.V2NIMTeamService.on('onTeamJoined', this._onTeamJoined);
            // 自己主动离开群组或被管理员踢出回调
            nim.V2NIMTeamService.on('onTeamLeft', this._onTeamLeft);
            // 群组成员信息更新回调
            nim.V2NIMTeamService.on('onTeamMemberInfoUpdated', this._onTeamMemberInfoUpdated);
            // 群组成员加入回调(非自己)
            nim.V2NIMTeamService.on('onTeamMemberJoined', this._onTeamMemberJoined);
            // 群组成员被踢回调(非自己)
            nim.V2NIMTeamService.on('onTeamMemberKicked', this._onTeamMemberKicked);
            // 群组成员离开回调(非自己)
            nim.V2NIMTeamService.on('onTeamMemberLeft', this._onTeamMemberLeft);
        }
        TeamService.prototype.destroy = function () {
            this.nim.V2NIMTeamService.off('onReceiveTeamJoinActionInfo', this._onReceiveTeamJoinActionInfo);
            this.nim.V2NIMTeamService.off('onSyncFailed', this._onSyncFailed);
            this.nim.V2NIMTeamService.off('onSyncFinished', this._onSyncFinished);
            this.nim.V2NIMTeamService.off('onSyncStarted', this._onSyncStarted);
            this.nim.V2NIMTeamService.off('onTeamCreated', this._onTeamCreated);
            this.nim.V2NIMTeamService.off('onTeamDismissed', this._onTeamDismissed);
            this.nim.V2NIMTeamService.off('onTeamInfoUpdated', this._onTeamInfoUpdated);
            this.nim.V2NIMTeamService.off('onTeamJoined', this._onTeamJoined);
            this.nim.V2NIMTeamService.off('onTeamLeft', this._onTeamLeft);
            this.nim.V2NIMTeamService.off('onTeamMemberInfoUpdated', this._onTeamMemberInfoUpdated);
            this.nim.V2NIMTeamService.off('onTeamMemberJoined', this._onTeamMemberJoined);
            this.nim.V2NIMTeamService.off('onTeamMemberKicked', this._onTeamMemberKicked);
            this.nim.V2NIMTeamService.off('onTeamMemberLeft', this._onTeamMemberLeft);
        };
        TeamService.prototype.createTeam = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_1;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.createTeam(params.createTeamParams, params.inviteeAccountIds, params.postscript, params.antispamConfig)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_1 = _b.sent();
                            throw failRes(error_1);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.updateTeamInfo = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_2;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.updateTeamInfo(params.teamId, params.teamType, params.updateTeamInfoParams, params.antispamConfig)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_2 = _b.sent();
                            throw failRes(error_2);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.leaveTeam = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_3;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.leaveTeam(params.teamId, params.teamType)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_3 = _b.sent();
                            throw failRes(error_3);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.getTeamInfo = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_4;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.getTeamInfo(params.teamId, params.teamType)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_4 = _b.sent();
                            throw failRes(error_4);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.getTeamInfoByIds = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_5;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMTeamService.getTeamInfoByIds(params.teamIds, params.teamType)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.teamList = _c.sent(),
                                    _b)])];
                        case 2:
                            error_5 = _c.sent();
                            throw failRes(error_5);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.dismissTeam = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_6;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.dismissTeam(params.teamId, params.teamType)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_6 = _b.sent();
                            throw failRes(error_6);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.inviteMember = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_7;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMTeamService.inviteMember(params.teamId, params.teamType, params.inviteeAccountIds, params.postscript)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.failedList = _c.sent(),
                                    _b)])];
                        case 2:
                            error_7 = _c.sent();
                            throw failRes(error_7);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.acceptInvitation = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_8;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.acceptInvitation(params.invitationInfo)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_8 = _b.sent();
                            throw failRes(error_8);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.rejectInvitation = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_9;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.rejectInvitation(params.invitationInfo, params.postscript)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_9 = _b.sent();
                            throw failRes(error_9);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.kickMember = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_10;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.kickMember(params.teamId, params.teamType, params.memberAccountIds || [])];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_10 = _b.sent();
                            throw failRes(error_10);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.applyJoinTeam = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_11;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.applyJoinTeam(params.teamId, params.teamType, params.postscript)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_11 = _b.sent();
                            throw failRes(error_11);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.acceptJoinApplication = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_12;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.acceptJoinApplication(params.joinInfo)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_12 = _b.sent();
                            throw failRes(error_12);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.rejectJoinApplication = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_13;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.rejectJoinApplication(params.joinInfo, params.postscript)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_13 = _b.sent();
                            throw failRes(error_13);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.updateTeamMemberRole = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_14;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.updateTeamMemberRole(params.teamId, params.teamType, params.memberAccountIds, params.memberRole)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_14 = _b.sent();
                            throw failRes(error_14);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.transferTeamOwner = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_15;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.transferTeamOwner(params.teamId, params.teamType, params.accountId, params.leave)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_15 = _b.sent();
                            throw failRes(error_15);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.updateSelfTeamMemberInfo = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_16;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.updateSelfTeamMemberInfo(params.teamId, params.teamType, params.memberInfoParams)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_16 = _b.sent();
                            throw failRes(error_16);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.updateTeamMemberNick = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_17;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.updateTeamMemberNick(params.teamId, params.teamType, params.accountId, params.teamNick)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_17 = _b.sent();
                            throw failRes(error_17);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.setTeamChatBannedMode = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_18;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.setTeamChatBannedMode(params.teamId, params.teamType, params.chatBannedMode)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_18 = _b.sent();
                            throw failRes(error_18);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.setTeamMemberChatBannedStatus = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_19;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.setTeamMemberChatBannedStatus(params.teamId, params.teamType, params.accountId, params.chatBanned)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_19 = _b.sent();
                            throw failRes(error_19);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.getJoinedTeamList = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_20;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMTeamService.getJoinedTeamList(params.teamTypes)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.teamList = _c.sent(),
                                    _b)])];
                        case 2:
                            error_20 = _c.sent();
                            throw failRes(error_20);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.getJoinedTeamCount = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    try {
                        return [2 /*return*/, successRes(this.nim.V2NIMTeamService.getJoinedTeamCount(params.teamTypes))];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        TeamService.prototype.getTeamMemberList = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_21;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.getTeamMemberList(params.teamId, params.teamType, params.queryOption)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_21 = _b.sent();
                            throw failRes(error_21);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.getTeamMemberListByIds = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_22;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMTeamService.getTeamMemberListByIds(params.teamId, params.teamType, params.accountIds)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.memberList = _c.sent(),
                                    _b)])];
                        case 2:
                            error_22 = _c.sent();
                            throw failRes(error_22);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.getTeamMemberInvitor = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_23;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.getTeamMemberInvitor(params.teamId, params.teamType, params.accountIds)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_23 = _b.sent();
                            throw failRes(error_23);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.getTeamJoinActionInfoList = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_24;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMTeamService.getTeamJoinActionInfoList(params.queryOption)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_24 = _b.sent();
                            throw failRes(error_24);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.searchTeamByKeyword = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_25;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMTeamService.searchTeamByKeyword(params.keyword)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.teamList = _c.sent(),
                                    _b)])];
                        case 2:
                            error_25 = _c.sent();
                            throw failRes(error_25);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        TeamService.prototype.searchTeamMembers = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        TeamService.prototype._onReceiveTeamJoinActionInfo = function (data) {
            logger.log('_onReceiveTeamJoinActionInfo: ', data);
            emit('TeamService', 'onReceiveTeamJoinActionInfo', data);
        };
        TeamService.prototype._onSyncFailed = function (data) {
            logger.log('_onSyncFailed: ', data);
            emit('TeamService', 'onSyncFailed', failRes(data));
        };
        TeamService.prototype._onSyncFinished = function () {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    logger.log('_onSyncFinished');
                    emit('TeamService', 'onSyncFinished', {});
                    return [2 /*return*/];
                });
            });
        };
        TeamService.prototype._onSyncStarted = function () {
            logger.log('_onSyncStarted');
            emit('TeamService', 'onSyncStarted', {});
        };
        TeamService.prototype._onTeamCreated = function (data) {
            logger.log('_onTeamCreated: ', data);
            emit('TeamService', 'onTeamCreated', data);
        };
        TeamService.prototype._onTeamDismissed = function (data) {
            logger.log('_onTeamDismissed: ', data);
            emit('TeamService', 'onTeamDismissed', data);
        };
        TeamService.prototype._onTeamInfoUpdated = function (data) {
            logger.log('_onTeamInfoUpdated: ', data);
            emit('TeamService', 'onTeamInfoUpdated', data);
        };
        TeamService.prototype._onTeamJoined = function (data) {
            logger.log('_onTeamJoined: ', data);
            emit('TeamService', 'onTeamJoined', data);
        };
        TeamService.prototype._onTeamLeft = function (team, isKicked) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    logger.log('_onTeamLeft: ', team, isKicked);
                    emit('TeamService', 'onTeamLeft', { team: team, isKicked: isKicked });
                    return [2 /*return*/];
                });
            });
        };
        TeamService.prototype._onTeamMemberInfoUpdated = function (memberList) {
            logger.log('_onTeamMemberInfoUpdated: ', memberList);
            emit('TeamService', 'onTeamMemberInfoUpdated', { memberList: memberList });
        };
        TeamService.prototype._onTeamMemberJoined = function (data) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    logger.log('_onTeamMemberJoined: ', data);
                    emit('TeamService', 'onTeamMemberJoined', data);
                    return [2 /*return*/];
                });
            });
        };
        TeamService.prototype._onTeamMemberKicked = function (operateAccountId, memberList) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    logger.log('_onTeamMemberKicked: ', operateAccountId, memberList);
                    emit('TeamService', 'onTeamMemberKicked', { operateAccountId: operateAccountId, memberList: memberList });
                    return [2 /*return*/];
                });
            });
        };
        TeamService.prototype._onTeamMemberLeft = function (memberList) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    logger.log('_onTeamMemberLeft: ', memberList);
                    emit('TeamService', 'onTeamMemberLeft', { memberList: memberList });
                    return [2 /*return*/];
                });
            });
        };
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "createTeam", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "updateTeamInfo", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "leaveTeam", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "getTeamInfo", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "getTeamInfoByIds", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "dismissTeam", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "inviteMember", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "acceptInvitation", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "rejectInvitation", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "kickMember", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "applyJoinTeam", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "acceptJoinApplication", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "rejectJoinApplication", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "updateTeamMemberRole", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "transferTeamOwner", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "updateSelfTeamMemberInfo", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "updateTeamMemberNick", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "setTeamChatBannedMode", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "setTeamMemberChatBannedStatus", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "getJoinedTeamList", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "getJoinedTeamCount", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "getTeamMemberList", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "getTeamMemberListByIds", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "getTeamMemberInvitor", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "getTeamJoinActionInfoList", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "searchTeamByKeyword", null);
        __decorate([
            loggerDec$6
        ], TeamService.prototype, "searchTeamMembers", null);
        return TeamService;
    }());

    var TAG_NAME$5 = 'ConversationService';
    var loggerDec$5 = index_cjs.createLoggerDecorator(TAG_NAME$5, logger);
    var ConversationService = /** @class */ (function () {
        function ConversationService(rootService, nim) {
            this.rootService = rootService;
            this.nim = nim;
            this._onConversationChanged = this._onConversationChanged.bind(this);
            this._onConversationCreated = this._onConversationCreated.bind(this);
            this._onConversationDeleted = this._onConversationDeleted.bind(this);
            this._onConversationReadTimeUpdated =
                this._onConversationReadTimeUpdated.bind(this);
            this._onSyncFailed = this._onSyncFailed.bind(this);
            this._onSyncFinished = this._onSyncFinished.bind(this);
            this._onSyncStarted = this._onSyncStarted.bind(this);
            this._onTotalUnreadCountChanged = this._onTotalUnreadCountChanged.bind(this);
            this._onUnreadCountChangedByFilter =
                this._onUnreadCountChangedByFilter.bind(this);
            nim.V2NIMConversationService.on('onConversationChanged', this._onConversationChanged);
            nim.V2NIMConversationService.on('onConversationCreated', this._onConversationCreated);
            nim.V2NIMConversationService.on('onConversationDeleted', this._onConversationDeleted);
            nim.V2NIMConversationService.on('onConversationReadTimeUpdated', this._onConversationReadTimeUpdated);
            nim.V2NIMConversationService.on('onSyncFailed', this._onSyncFailed);
            nim.V2NIMConversationService.on('onSyncFinished', this._onSyncFinished);
            nim.V2NIMConversationService.on('onSyncStarted', this._onSyncStarted);
            nim.V2NIMConversationService.on('onTotalUnreadCountChanged', this._onTotalUnreadCountChanged);
            nim.V2NIMConversationService.on('onUnreadCountChangedByFilter', this._onUnreadCountChangedByFilter);
        }
        ConversationService.prototype.destroy = function () {
            this.nim.V2NIMConversationService.off('onConversationChanged', this._onConversationChanged);
            this.nim.V2NIMConversationService.off('onConversationCreated', this._onConversationCreated);
            this.nim.V2NIMConversationService.off('onConversationDeleted', this._onConversationDeleted);
            this.nim.V2NIMConversationService.off('onConversationReadTimeUpdated', this._onConversationReadTimeUpdated);
            this.nim.V2NIMConversationService.off('onSyncFailed', this._onSyncFailed);
            this.nim.V2NIMConversationService.off('onSyncFinished', this._onSyncFinished);
            this.nim.V2NIMConversationService.off('onSyncStarted', this._onSyncStarted);
            this.nim.V2NIMConversationService.off('onTotalUnreadCountChanged', this._onTotalUnreadCountChanged);
            this.nim.V2NIMConversationService.off('onUnreadCountChangedByFilter', this._onUnreadCountChangedByFilter);
        };
        ConversationService.prototype.getConversationList = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var res, error_1;
                return __generator(this, function (_a) {
                    switch (_a.label) {
                        case 0:
                            _a.trys.push([0, 2, , 3]);
                            return [4 /*yield*/, this.nim.V2NIMConversationService.getConversationList(params.offset, params.limit)];
                        case 1:
                            res = _a.sent();
                            return [2 /*return*/, successRes(__assign(__assign({}, res), { conversationList: res.conversationList.map(function (item) {
                                        return formatV2ConversationLastMessage(item);
                                    }) }))];
                        case 2:
                            error_1 = _a.sent();
                            throw failRes(error_1);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.getConversationListByOption = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var res, error_2;
                return __generator(this, function (_a) {
                    switch (_a.label) {
                        case 0:
                            _a.trys.push([0, 2, , 3]);
                            return [4 /*yield*/, this.nim.V2NIMConversationService.getConversationListByOption(params.offset, params.limit, params.option)];
                        case 1:
                            res = _a.sent();
                            return [2 /*return*/, successRes(__assign(__assign({}, res), { conversationList: res.conversationList.map(function (item) {
                                        return formatV2ConversationLastMessage(item);
                                    }) }))];
                        case 2:
                            error_2 = _a.sent();
                            throw failRes(error_2);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.getConversation = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, _b, error_3;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = formatV2ConversationLastMessage;
                            return [4 /*yield*/, this.nim.V2NIMConversationService.getConversation(params.conversationId)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.apply(void 0, [_c.sent()])])];
                        case 2:
                            error_3 = _c.sent();
                            throw failRes(error_3);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.getConversationListByIds = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_4;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMConversationService.getConversationListByIds(params.conversationIdList)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.conversationList = (_c.sent()).map(function (item) { return formatV2ConversationLastMessage(item); }),
                                    _b)])];
                        case 2:
                            error_4 = _c.sent();
                            throw failRes(error_4);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.createConversation = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, _b, error_5;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = formatV2ConversationLastMessage;
                            return [4 /*yield*/, this.nim.V2NIMConversationService.createConversation(params.conversationId)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.apply(void 0, [_c.sent()])])];
                        case 2:
                            error_5 = _c.sent();
                            throw failRes(error_5);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.deleteConversation = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_6;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMConversationService.deleteConversation(params.conversationId, params.clearMessage)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_6 = _b.sent();
                            throw failRes(error_6);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.deleteConversationListByIds = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_7;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMConversationService.deleteConversationListByIds(params.conversationIdList, params.clearMessage)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.conversationOperationResult = _c.sent(),
                                    _b)])];
                        case 2:
                            error_7 = _c.sent();
                            throw failRes(error_7);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.stickTopConversation = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_8;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMConversationService.stickTopConversation(params.conversationId, params.stickTop)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_8 = _b.sent();
                            throw failRes(error_8);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.updateConversation = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_9;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMConversationService.updateConversation(params.conversationId, params.updateInfo)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_9 = _b.sent();
                            throw failRes(error_9);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.updateConversationLocalExtension = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_10;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMConversationService.updateConversationLocalExtension(params.conversationId, params.localExtension || '')];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_10 = _b.sent();
                            throw failRes(error_10);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.getTotalUnreadCount = function () {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    try {
                        return [2 /*return*/, successRes(this.nim.V2NIMConversationService.getTotalUnreadCount())];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        ConversationService.prototype.getUnreadCountByIds = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_11;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMConversationService.getUnreadCountByIds(params.conversationIdList)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_11 = _b.sent();
                            throw failRes(error_11);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.getUnreadCountByFilter = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_12;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMConversationService.getUnreadCountByFilter(params)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_12 = _b.sent();
                            throw failRes(error_12);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.clearTotalUnreadCount = function () {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_13;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMConversationService.clearTotalUnreadCount()];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_13 = _b.sent();
                            throw failRes(error_13);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.clearUnreadCountByIds = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_14;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMConversationService.clearUnreadCountByIds(params.conversationIdList)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.conversationOperationResult = _c.sent(),
                                    _b)])];
                        case 2:
                            error_14 = _c.sent();
                            throw failRes(error_14);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.clearUnreadCountByGroupId = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_15;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMConversationService.clearUnreadCountByGroupId(params.groupId)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_15 = _b.sent();
                            throw failRes(error_15);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.clearUnreadCountByTypes = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_16;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMConversationService.clearUnreadCountByTypes(params.conversationTypeList)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_16 = _b.sent();
                            throw failRes(error_16);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.subscribeUnreadCountByFilter = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    try {
                        return [2 /*return*/, successRes(this.nim.V2NIMConversationService.subscribeUnreadCountByFilter(params.filter))];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        ConversationService.prototype.unsubscribeUnreadCountByFilter = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    try {
                        return [2 /*return*/, successRes(this.nim.V2NIMConversationService.unsubscribeUnreadCountByFilter(params.filter))];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        ConversationService.prototype.getConversationReadTime = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_17;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMConversationService.getConversationReadTime(params.conversationId)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_17 = _b.sent();
                            throw failRes(error_17);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype.markConversationRead = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_18;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMConversationService.markConversationRead(params.conversationId)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_18 = _b.sent();
                            throw failRes(error_18);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        ConversationService.prototype._onConversationChanged = function (conversationList) {
            logger.log('_onConversationChanged', conversationList);
            emit('ConversationService', 'onConversationChanged', {
                conversationList: conversationList.map(function (item) {
                    return formatV2ConversationLastMessage(item);
                }),
            });
        };
        ConversationService.prototype._onConversationCreated = function (conversation) {
            logger.log('_onConversationCreated', conversation);
            emit('ConversationService', 'onConversationCreated', formatV2ConversationLastMessage(conversation));
        };
        ConversationService.prototype._onConversationDeleted = function (conversationIds) {
            logger.log('_onConversationDeleted', conversationIds);
            emit('ConversationService', 'onConversationDeleted', {
                conversationIdList: conversationIds,
            });
        };
        ConversationService.prototype._onConversationReadTimeUpdated = function (conversationId, readTime) {
            logger.log('_onConversationReadTimeUpdated', conversationId, readTime);
            emit('ConversationService', 'onConversationReadTimeUpdated', {
                conversationId: conversationId,
                readTime: readTime,
            });
        };
        ConversationService.prototype._onSyncFailed = function (error) {
            logger.log('_onSyncFailed', error);
            emit('ConversationService', 'onSyncFailed', {});
        };
        ConversationService.prototype._onSyncFinished = function () {
            logger.log('_onSyncFinished');
            emit('ConversationService', 'onSyncFinished', {});
        };
        ConversationService.prototype._onSyncStarted = function () {
            logger.log('_onSyncStarted');
            emit('ConversationService', 'onSyncStarted', {});
        };
        ConversationService.prototype._onTotalUnreadCountChanged = function (unreadCount) {
            logger.log('_onTotalUnreadCountChanged', unreadCount);
            emit('ConversationService', 'onTotalUnreadCountChanged', {
                unreadCount: unreadCount,
            });
        };
        ConversationService.prototype._onUnreadCountChangedByFilter = function (filter, unreadCount) {
            logger.log('_onUnreadCountChangedByFilter', unreadCount, filter);
            emit('ConversationService', 'onUnreadCountChangedByFilter', {
                unreadCount: unreadCount,
                conversationFilter: filter,
            });
        };
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "getConversationList", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "getConversationListByOption", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "getConversation", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "getConversationListByIds", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "createConversation", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "deleteConversation", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "deleteConversationListByIds", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "stickTopConversation", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "updateConversation", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "updateConversationLocalExtension", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "getTotalUnreadCount", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "getUnreadCountByIds", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "getUnreadCountByFilter", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "clearTotalUnreadCount", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "clearUnreadCountByIds", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "clearUnreadCountByGroupId", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "clearUnreadCountByTypes", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "subscribeUnreadCountByFilter", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "unsubscribeUnreadCountByFilter", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "getConversationReadTime", null);
        __decorate([
            loggerDec$5
        ], ConversationService.prototype, "markConversationRead", null);
        return ConversationService;
    }());

    var TAG_NAME$4 = 'StorageService';
    var loggerDec$4 = index_cjs.createLoggerDecorator(TAG_NAME$4, logger);
    var StorageService = /** @class */ (function () {
        function StorageService(rootService, nim) {
            this.rootService = rootService;
            this.nim = nim;
        }
        StorageService.prototype.destroy = function () {
            //
        };
        StorageService.prototype.addCustomStorageScene = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    try {
                        return [2 /*return*/, successRes(this.nim.V2NIMStorageService.addCustomStorageScene(params.sceneName, params.expireTime))];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        StorageService.prototype.cancelUploadFile = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_1;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMStorageService.cancelUploadFile(params.fileTask)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_1 = _b.sent();
                            throw failRes(error_1);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        StorageService.prototype.createUploadFileTask = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    try {
                        return [2 /*return*/, successRes(this.nim.V2NIMStorageService.createUploadFileTask(__assign(__assign({}, params.fileParams), { fileObj: params.fileObj })))];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        StorageService.prototype.downloadAttachment = function () {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        StorageService.prototype.downloadFile = function () {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        StorageService.prototype.getImageThumbUrl = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_2;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMStorageService.getImageThumbUrl(params.attachment, params.thumbSize)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_2 = _b.sent();
                            throw failRes(error_2);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        StorageService.prototype.getStorageSceneList = function () {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    try {
                        return [2 /*return*/, successRes({
                                sceneList: this.nim.V2NIMStorageService.getStorageSceneList(),
                            })];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        StorageService.prototype.getVideoCoverUrl = function (parmas) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_3;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMStorageService.getVideoCoverUrl(parmas.attachment, parmas.thumbSize)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_3 = _b.sent();
                            throw failRes(error_3);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        StorageService.prototype.shortUrlToLong = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_4;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMStorageService.shortUrlToLong(params.url)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_4 = _b.sent();
                            throw failRes(error_4);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        StorageService.prototype.uploadFile = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_5;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMStorageService.uploadFile(__assign(__assign({}, params.fileTask), { uploadParams: __assign(__assign({}, params.fileTask.uploadParams), { fileObj: params.fileObj }) }), function (progress) {
                                    emit('StorageService', 'onFileUploadProgress', {
                                        taskId: params.fileTask.taskId,
                                        progress: progress,
                                    });
                                })];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_5 = _b.sent();
                            throw failRes(error_5);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        StorageService.prototype.imageThumbUrl = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        StorageService.prototype.videoCoverUrl = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        __decorate([
            loggerDec$4
        ], StorageService.prototype, "addCustomStorageScene", null);
        __decorate([
            loggerDec$4
        ], StorageService.prototype, "cancelUploadFile", null);
        __decorate([
            loggerDec$4
        ], StorageService.prototype, "createUploadFileTask", null);
        __decorate([
            loggerDec$4
        ], StorageService.prototype, "downloadAttachment", null);
        __decorate([
            loggerDec$4
        ], StorageService.prototype, "downloadFile", null);
        __decorate([
            loggerDec$4
        ], StorageService.prototype, "getImageThumbUrl", null);
        __decorate([
            loggerDec$4
        ], StorageService.prototype, "getStorageSceneList", null);
        __decorate([
            loggerDec$4
        ], StorageService.prototype, "getVideoCoverUrl", null);
        __decorate([
            loggerDec$4
        ], StorageService.prototype, "shortUrlToLong", null);
        __decorate([
            loggerDec$4
        ], StorageService.prototype, "uploadFile", null);
        __decorate([
            loggerDec$4
        ], StorageService.prototype, "imageThumbUrl", null);
        __decorate([
            loggerDec$4
        ], StorageService.prototype, "videoCoverUrl", null);
        return StorageService;
    }());

    var TAG_NAME$3 = 'MessageCreatorService';
    var loggerDec$3 = index_cjs.createLoggerDecorator(TAG_NAME$3, logger);
    var MessageCreatorService = /** @class */ (function () {
        function MessageCreatorService(rootService, nim) {
            this.rootService = rootService;
            this.nim = nim;
            this.msgMap = new Map();
        }
        MessageCreatorService.prototype.destroy = function () {
            this.msgMap.clear();
        };
        MessageCreatorService.prototype.createTextMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var msg;
                return __generator(this, function (_a) {
                    try {
                        msg = this.nim.V2NIMMessageCreator.createTextMessage(params.text);
                        this.msgMap.set(msg.messageClientId, msg);
                        return [2 /*return*/, successRes(msg)];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        MessageCreatorService.prototype.createImageMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var msg;
                return __generator(this, function (_a) {
                    try {
                        msg = this.nim.V2NIMMessageCreator.createImageMessage(params.imageObj, params.name, params.sceneName, params.width, params.height);
                        this.msgMap.set(msg.messageClientId, msg);
                        return [2 /*return*/, successRes(msg)];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        MessageCreatorService.prototype.createAudioMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var msg;
                return __generator(this, function (_a) {
                    try {
                        msg = this.nim.V2NIMMessageCreator.createAudioMessage(params.audioObj, params.name, params.sceneName, params.duration);
                        this.msgMap.set(msg.messageClientId, msg);
                        return [2 /*return*/, successRes(msg)];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        MessageCreatorService.prototype.createVideoMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var msg;
                return __generator(this, function (_a) {
                    try {
                        msg = this.nim.V2NIMMessageCreator.createVideoMessage(params.videoObj, params.name, params.sceneName, params.duration, params.width, params.height);
                        this.msgMap.set(msg.messageClientId, msg);
                        return [2 /*return*/, successRes(msg)];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        MessageCreatorService.prototype.createFileMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var msg;
                return __generator(this, function (_a) {
                    try {
                        msg = this.nim.V2NIMMessageCreator.createFileMessage(params.fileObj, params.name, params.sceneName);
                        this.msgMap.set(msg.messageClientId, msg);
                        return [2 /*return*/, successRes(msg)];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        MessageCreatorService.prototype.createLocationMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var msg;
                return __generator(this, function (_a) {
                    try {
                        msg = this.nim.V2NIMMessageCreator.createLocationMessage(params.latitude, params.longitude, params.address);
                        this.msgMap.set(msg.messageClientId, msg);
                        return [2 /*return*/, successRes(msg)];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        MessageCreatorService.prototype.createCustomMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var msg;
                return __generator(this, function (_a) {
                    try {
                        msg = this.nim.V2NIMMessageCreator.createCustomMessage(params.text, params.rawAttachment);
                        this.msgMap.set(msg.messageClientId, msg);
                        return [2 /*return*/, successRes(msg)];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        MessageCreatorService.prototype.createTipsMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var msg;
                return __generator(this, function (_a) {
                    try {
                        msg = this.nim.V2NIMMessageCreator.createTipsMessage(params.text);
                        this.msgMap.set(msg.messageClientId, msg);
                        return [2 /*return*/, successRes(msg)];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        MessageCreatorService.prototype.createForwardMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var res;
                return __generator(this, function (_a) {
                    res = this.nim.V2NIMMessageCreator.createForwardMessage(params.message);
                    if (res) {
                        this.msgMap.set(res.messageClientId, res);
                        return [2 /*return*/, successRes(res)];
                    }
                    throw failRes({
                        code: 1,
                        message: 'createForwardMessage failed',
                        desc: 'createForwardMessage failed',
                        detail: {},
                        name: '',
                    });
                });
            });
        };
        MessageCreatorService.prototype.createCallMessage = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var msg;
                return __generator(this, function (_a) {
                    try {
                        msg = this.nim.V2NIMMessageCreator.createCallMessage(params.type, params.channelId, params.status, params.durations, params.text);
                        this.msgMap.set(msg.messageClientId, msg);
                        return [2 /*return*/, successRes(msg)];
                    }
                    catch (error) {
                        throw failRes(error);
                    }
                    return [2 /*return*/];
                });
            });
        };
        __decorate([
            loggerDec$3
        ], MessageCreatorService.prototype, "createTextMessage", null);
        __decorate([
            loggerDec$3
        ], MessageCreatorService.prototype, "createImageMessage", null);
        __decorate([
            loggerDec$3
        ], MessageCreatorService.prototype, "createAudioMessage", null);
        __decorate([
            loggerDec$3
        ], MessageCreatorService.prototype, "createVideoMessage", null);
        __decorate([
            loggerDec$3
        ], MessageCreatorService.prototype, "createFileMessage", null);
        __decorate([
            loggerDec$3
        ], MessageCreatorService.prototype, "createLocationMessage", null);
        __decorate([
            loggerDec$3
        ], MessageCreatorService.prototype, "createCustomMessage", null);
        __decorate([
            loggerDec$3
        ], MessageCreatorService.prototype, "createTipsMessage", null);
        __decorate([
            loggerDec$3
        ], MessageCreatorService.prototype, "createForwardMessage", null);
        __decorate([
            loggerDec$3
        ], MessageCreatorService.prototype, "createCallMessage", null);
        return MessageCreatorService;
    }());

    var TAG_NAME$2 = 'NotificationService';
    var loggerDec$2 = index_cjs.createLoggerDecorator(TAG_NAME$2, logger);
    var NotificationService = /** @class */ (function () {
        function NotificationService(rootService, nim) {
            this.rootService = rootService;
            this.nim = nim;
            this._onReceiveBroadcastNotifications =
                this._onReceiveBroadcastNotifications.bind(this);
            this._onReceiveCustomNotifications =
                this._onReceiveCustomNotifications.bind(this);
            // 收到广播通知
            nim.V2NIMNotificationService.on('onReceiveBroadcastNotifications', this._onReceiveBroadcastNotifications);
            // 收到自定义通知
            nim.V2NIMNotificationService.on('onReceiveCustomNotifications', this._onReceiveCustomNotifications);
        }
        NotificationService.prototype.destroy = function () {
            this.nim.V2NIMNotificationService.off('onReceiveBroadcastNotifications', this._onReceiveBroadcastNotifications);
            this.nim.V2NIMNotificationService.off('onReceiveCustomNotifications', this._onReceiveCustomNotifications);
        };
        NotificationService.prototype.sendCustomNotification = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_1;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMNotificationService.sendCustomNotification(params.conversationId, params.content, params.params)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_1 = _b.sent();
                            throw failRes(error_1);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        NotificationService.prototype._onReceiveBroadcastNotifications = function (broadcastNotification) {
            logger.log('_onReceiveBroadcastNotifications', broadcastNotification);
            emit('NotificationService', 'onReceiveBroadcastNotifications', {
                broadcastNotifications: broadcastNotification,
            });
        };
        NotificationService.prototype._onReceiveCustomNotifications = function (customNotification) {
            logger.log('_onReceiveCustomNotifications', customNotification);
            emit('NotificationService', 'onReceiveCustomNotifications', {
                customNotifications: customNotification,
            });
        };
        __decorate([
            loggerDec$2
        ], NotificationService.prototype, "sendCustomNotification", null);
        return NotificationService;
    }());

    var TAG_NAME$1 = 'ConversationUtil';
    var loggerDec$1 = index_cjs.createLoggerDecorator(TAG_NAME$1, logger);
    var ConversationUtil = /** @class */ (function () {
        function ConversationUtil(rootService, nim) {
            this.rootService = rootService;
            this.nim = nim;
            //
        }
        ConversationUtil.prototype.destroy = function () {
            //
        };
        ConversationUtil.prototype.conversationId = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        ConversationUtil.prototype.p2pConversationId = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    return [2 /*return*/, successRes(this.nim.V2NIMConversationIdUtil.p2pConversationId(params.accountId))];
                });
            });
        };
        ConversationUtil.prototype.teamConversationId = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    return [2 /*return*/, successRes(this.nim.V2NIMConversationIdUtil.teamConversationId(params.teamId))];
                });
            });
        };
        ConversationUtil.prototype.superTeamConversationId = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    return [2 /*return*/, successRes(this.nim.V2NIMConversationIdUtil.superTeamConversationId(params.teamId))];
                });
            });
        };
        ConversationUtil.prototype.conversationType = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    return [2 /*return*/, successRes({
                            conversationType: this.nim.V2NIMConversationIdUtil.parseConversationType(params.conversationId),
                        })];
                });
            });
        };
        ConversationUtil.prototype.conversationTargetId = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    return [2 /*return*/, successRes(this.nim.V2NIMConversationIdUtil.parseConversationTargetId(params.conversationId))];
                });
            });
        };
        ConversationUtil.prototype.isConversationIdValid = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        ConversationUtil.prototype.sessionTypeV1 = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    throw NOT_IMPLEMENTED_ERROR;
                });
            });
        };
        __decorate([
            loggerDec$1
        ], ConversationUtil.prototype, "conversationId", null);
        __decorate([
            loggerDec$1
        ], ConversationUtil.prototype, "p2pConversationId", null);
        __decorate([
            loggerDec$1
        ], ConversationUtil.prototype, "teamConversationId", null);
        __decorate([
            loggerDec$1
        ], ConversationUtil.prototype, "superTeamConversationId", null);
        __decorate([
            loggerDec$1
        ], ConversationUtil.prototype, "conversationType", null);
        __decorate([
            loggerDec$1
        ], ConversationUtil.prototype, "conversationTargetId", null);
        __decorate([
            loggerDec$1
        ], ConversationUtil.prototype, "isConversationIdValid", null);
        __decorate([
            loggerDec$1
        ], ConversationUtil.prototype, "sessionTypeV1", null);
        return ConversationUtil;
    }());

    var TAG_NAME = 'AIService';
    var loggerDec = index_cjs.createLoggerDecorator(TAG_NAME, logger);
    var AIService = /** @class */ (function () {
        function AIService(rootService, nim) {
            this.rootService = rootService;
            this.nim = nim;
            this._onProxyAIModelCall = this._onProxyAIModelCall.bind(this);
            nim.V2NIMAIService.on('onProxyAIModelCall', this._onProxyAIModelCall);
        }
        AIService.prototype.destroy = function () {
            this.nim.V2NIMAIService.off('onProxyAIModelCall', this._onProxyAIModelCall);
        };
        AIService.prototype.getAIUserList = function () {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_1;
                var _b;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            _c.trys.push([0, 2, , 3]);
                            _a = successRes;
                            _b = {};
                            return [4 /*yield*/, this.nim.V2NIMAIService.getAIUserList()];
                        case 1: return [2 /*return*/, _a.apply(void 0, [(_b.userList = _c.sent(),
                                    _b)])];
                        case 2:
                            error_1 = _c.sent();
                            throw failRes(error_1);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        AIService.prototype.proxyAIModelCall = function (params) {
            return __awaiter(this, void 0, void 0, function () {
                var _a, error_2;
                return __generator(this, function (_b) {
                    switch (_b.label) {
                        case 0:
                            _b.trys.push([0, 2, , 3]);
                            _a = successRes;
                            return [4 /*yield*/, this.nim.V2NIMAIService.proxyAIModelCall(params.params)];
                        case 1: return [2 /*return*/, _a.apply(void 0, [_b.sent()])];
                        case 2:
                            error_2 = _b.sent();
                            throw failRes(error_2);
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        AIService.prototype._onProxyAIModelCall = function (data) {
            logger.log('_onProxyAIModelCall', data);
            emit('AIService', 'onProxyAIModelCall', data);
        };
        __decorate([
            loggerDec
        ], AIService.prototype, "getAIUserList", null);
        __decorate([
            loggerDec
        ], AIService.prototype, "proxyAIModelCall", null);
        return AIService;
    }());

    var RootService = /** @class */ (function () {
        function RootService() {
            this.nim = {};
            this.initializeService = new InitializeService(this, this.nim);
        }
        RootService.prototype.init = function () {
            this.loginService = new LoginService(this, this.nim);
            this.settingsService = new SettingsService(this, this.nim);
            this.messageService = new MessageService(this, this.nim);
            this.userService = new UserService(this, this.nim);
            this.friendService = new FriendService(this, this.nim);
            this.teamService = new TeamService(this, this.nim);
            this.conversationService = new ConversationService(this, this.nim);
            this.storageService = new StorageService(this, this.nim);
            this.messageCreatorService = new MessageCreatorService(this, this.nim);
            this.notificationService = new NotificationService(this, this.nim);
            this.conversationUtil = new ConversationUtil(this, this.nim);
            this.aiService = new AIService(this, this.nim);
        };
        RootService.prototype.destroy = function () {
            var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k, _l, _m;
            this.initializeService.destroy();
            (_a = this.loginService) === null || _a === void 0 ? void 0 : _a.destroy();
            (_b = this.settingsService) === null || _b === void 0 ? void 0 : _b.destroy();
            (_c = this.messageService) === null || _c === void 0 ? void 0 : _c.destroy();
            (_d = this.userService) === null || _d === void 0 ? void 0 : _d.destroy();
            (_e = this.friendService) === null || _e === void 0 ? void 0 : _e.destroy();
            (_f = this.teamService) === null || _f === void 0 ? void 0 : _f.destroy();
            (_g = this.conversationService) === null || _g === void 0 ? void 0 : _g.destroy();
            (_h = this.storageService) === null || _h === void 0 ? void 0 : _h.destroy();
            (_j = this.messageCreatorService) === null || _j === void 0 ? void 0 : _j.destroy();
            (_k = this.notificationService) === null || _k === void 0 ? void 0 : _k.destroy();
            (_l = this.conversationUtil) === null || _l === void 0 ? void 0 : _l.destroy();
            (_m = this.aiService) === null || _m === void 0 ? void 0 : _m.destroy();
        };
        Object.defineProperty(RootService.prototype, "InitializeService", {
            get: function () {
                return this.initializeService;
            },
            enumerable: false,
            configurable: true
        });
        Object.defineProperty(RootService.prototype, "LoginService", {
            get: function () {
                return this.loginService;
            },
            enumerable: false,
            configurable: true
        });
        Object.defineProperty(RootService.prototype, "SettingsService", {
            get: function () {
                return this.settingsService;
            },
            enumerable: false,
            configurable: true
        });
        Object.defineProperty(RootService.prototype, "MessageService", {
            get: function () {
                return this.messageService;
            },
            enumerable: false,
            configurable: true
        });
        Object.defineProperty(RootService.prototype, "UserService", {
            get: function () {
                return this.userService;
            },
            enumerable: false,
            configurable: true
        });
        Object.defineProperty(RootService.prototype, "FriendService", {
            get: function () {
                return this.friendService;
            },
            enumerable: false,
            configurable: true
        });
        Object.defineProperty(RootService.prototype, "TeamService", {
            get: function () {
                return this.teamService;
            },
            enumerable: false,
            configurable: true
        });
        Object.defineProperty(RootService.prototype, "ConversationService", {
            get: function () {
                return this.conversationService;
            },
            enumerable: false,
            configurable: true
        });
        Object.defineProperty(RootService.prototype, "StorageService", {
            get: function () {
                return this.storageService;
            },
            enumerable: false,
            configurable: true
        });
        Object.defineProperty(RootService.prototype, "MessageCreatorService", {
            get: function () {
                return this.messageCreatorService;
            },
            enumerable: false,
            configurable: true
        });
        Object.defineProperty(RootService.prototype, "NotificationService", {
            get: function () {
                return this.notificationService;
            },
            enumerable: false,
            configurable: true
        });
        Object.defineProperty(RootService.prototype, "ConversationIdUtil", {
            get: function () {
                return this.conversationUtil;
            },
            enumerable: false,
            configurable: true
        });
        Object.defineProperty(RootService.prototype, "AIService", {
            get: function () {
                return this.aiService;
            },
            enumerable: false,
            configurable: true
        });
        return RootService;
    }());

    exports["default"] = RootService;

    Object.defineProperty(exports, '__esModule', { value: true });

}));