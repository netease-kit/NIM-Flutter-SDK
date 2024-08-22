// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef BASE_STRINGHASH_H_
#define BASE_STRINGHASH_H_

namespace utils {
typedef std::uint64_t hash_t;

constexpr hash_t prime = 0x100000001B3ull;
constexpr hash_t basis = 0xCBF29CE484222325ull;

inline hash_t hash_(char const* str) {
    hash_t ret{basis};
    while (*str) {
        ret ^= *str;
        ret *= prime;
        str++;
    }

    return ret;
}

constexpr hash_t hash_compile_time(char const* str, hash_t last_value = basis) {
    return *str ? hash_compile_time(str + 1, (*str ^ last_value) * prime) : last_value;
}

}  // namespace utils

constexpr unsigned long long operator"" _hash(char const* p, size_t) {
    return utils::hash_compile_time(p);
}

#endif  // BASE_STRINGHASH_H_
