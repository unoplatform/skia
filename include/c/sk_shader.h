/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef sk_shader_DEFINED
#define sk_shader_DEFINED

#include "sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

/* 
Custom parameter structure to work around the limited set of available 
parameters in the m2n generation.
*/
typedef struct {
    const sk_point_t* start;
    float startRadius;
    const sk_point_t* end;
    float endRadius;
    const sk_color_t* colors; 
	const float* colorPos;
    int colorCount;
    sk_shader_tilemode_t cmode; 
	const sk_matrix_t* cmatrix;
} sk_shader_new_two_point_conical_gradient_params;

SK_API void sk_shader_ref(sk_shader_t*);
SK_API void sk_shader_unref(sk_shader_t*);
SK_API sk_shader_t* sk_shader_new_linear_gradient(const sk_point_t points[2],
                                           const sk_color_t colors[],
                                           const float colorPos[],
                                           int colorCount,
                                           sk_shader_tilemode_t tileMode,
                                           const sk_matrix_t* localMatrix);
SK_API sk_shader_t* sk_shader_new_radial_gradient(const sk_point_t* center,
                                           const sk_color_t colors[],
                                           const float colorPos[],
                                           int colorCount,
                                           sk_shader_tilemode_t tileMode,
                                           const sk_matrix_t* localMatrix,
                                           float radius);
SK_API sk_shader_t* sk_shader_new_sweep_gradient(const sk_point_t* center,
                                          const sk_color_t colors[],
                                          const float colorPos[],
                                          int colorCount,
                                          sk_shader_tilemode_t tileMode,
                                          const sk_matrix_t* localMatrix, 
                                          float startAngle,
                                          float endAngle);
SK_API sk_shader_t* sk_shader_new_two_point_conical_gradient(sk_shader_new_two_point_conical_gradient_params *pParams);
SK_API sk_shader_t* sk_shader_new_empty(void);
SK_API sk_shader_t* sk_shader_new_color(sk_color_t color);
SK_API sk_shader_t* sk_shader_new_bitmap(const sk_bitmap_t* src,
                                         sk_shader_tilemode_t tmx,
                                         sk_shader_tilemode_t tmy,
                                         const sk_matrix_t* localMatrix);
SK_API sk_shader_t* sk_shader_new_picture(sk_picture_t* src,
                                         sk_shader_tilemode_t tmx,
                                         sk_shader_tilemode_t tmy,
                                         const sk_matrix_t* localMatrix,
                                         const sk_rect_t* tile);
SK_API sk_shader_t* sk_shader_new_local_matrix(sk_shader_t* proxy, const sk_matrix_t* localMatrix);
SK_API sk_shader_t* sk_shader_new_color_filter(sk_shader_t* proxy, sk_colorfilter_t* filter);
SK_API sk_shader_t* sk_shader_new_perlin_noise_fractal_noise(
    int numOctaves,
    float baseFrequencyX,
    float baseFrequencyY,
    float seed,
    const sk_isize_t* tileSize);
SK_API sk_shader_t* sk_shader_new_perlin_noise_turbulence(
    int numOctaves,
    float seed,
    float baseFrequencyX,
    float baseFrequencyY,
    const sk_isize_t* tileSize);
SK_API sk_shader_t* sk_shader_new_compose(
    sk_shader_t* shaderA,
    sk_shader_t* shaderB);
SK_API sk_shader_t* sk_shader_new_compose_with_mode(
    sk_shader_t* shaderA,
    sk_shader_t* shaderB,
    sk_blendmode_t mode);

SK_C_PLUS_PLUS_END_GUARD

#endif
