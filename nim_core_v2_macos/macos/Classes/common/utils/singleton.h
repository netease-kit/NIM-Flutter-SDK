// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef BASE_SINGLETON_H_
#define BASE_SINGLETON_H_

#include <memory>
#include <mutex>
namespace utils {
template <typename T>
class Singleton {
 public:
  static T* getInstance();

  Singleton(const Singleton& other) = delete;
  Singleton<T>& operator=(const Singleton& other) = delete;

 private:
  static std::mutex mutex;
  static T* instance;
};

template <typename T>
std::mutex Singleton<T>::mutex;
template <typename T>
T* Singleton<T>::instance;
template <typename T>
T* Singleton<T>::getInstance() {
  if (instance == nullptr) {
    std::lock_guard<std::mutex> locker(mutex);
    if (instance == nullptr) {
      instance = new T();
    }
  }
  return instance;
}

#define SINGLETONG(Class)               \
 private:                               \
  friend class utils::Singleton<Class>; \
                                        \
 public:                                \
  static Class* getInstance() { return utils::Singleton<Class>::getInstance(); }

#define HIDE_CONSTRUCTOR(Class)                  \
 private:                                        \
  Class() = default;                             \
  Class(const Class& other) = delete;            \
  Class& operator=(const Class& other) = delete; \
  }

}
#endif  // BASE_SINGLETON_H_
