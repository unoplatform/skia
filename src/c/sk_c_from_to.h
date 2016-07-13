/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

static inline bool find_sk(CType from, SKType* to) {
    for (size_t i = 0; i < SK_ARRAY_COUNT(CTypeSkTypeMap); ++i) {
        if (CTypeSkTypeMap[i].fC == from) {
            if (to) {
                *to = CTypeSkTypeMap[i].fSK;
            }
            return true;
        }
    }
    return false;
}

static inline bool find_c(SKType from, CType* to) {
    for (size_t i = 0; i < SK_ARRAY_COUNT(CTypeSkTypeMap); ++i) {
        if (CTypeSkTypeMap[i].fSK == from) {
            if (to) {
                *to = CTypeSkTypeMap[i].fC;
            }
            return true;
        }
    }
    return false;
}

static inline SKType find_sk_default(CType from, SKType def) {
    for (size_t i = 0; i < SK_ARRAY_COUNT(CTypeSkTypeMap); ++i) {
        if (CTypeSkTypeMap[i].fC == from) {
            return CTypeSkTypeMap[i].fSK;
        }
    }
    return def;
}

static inline CType find_c_default(SKType from, CType def) {
    for (size_t i = 0; i < SK_ARRAY_COUNT(CTypeSkTypeMap); ++i) {
        if (CTypeSkTypeMap[i].fSK == from) {
            return CTypeSkTypeMap[i].fC;
        }
    }
    return def;
}

#undef CType
#undef SKType
#undef CTypeSkTypeMap
