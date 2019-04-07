/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef sk_string_DEFINED
#define sk_string_DEFINED

#include "sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

SK_API sk_string_t* sk_string_new_empty(void);
SK_API sk_string_t* sk_string_new_with_copy(const char* src, size_t length);
SK_API void sk_string_destructor(const sk_string_t*);
SK_API size_t sk_string_get_size(const sk_string_t*);
SK_API const char* sk_string_get_c_str(const sk_string_t*);

SK_C_PLUS_PLUS_END_GUARD

#endif
