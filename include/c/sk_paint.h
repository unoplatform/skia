/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef sk_paint_DEFINED
#define sk_paint_DEFINED

#include "sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

/*
Custom parameter structure to work around the limited set of available
parameters in the m2n generation.
*/
typedef struct {
    const sk_paint_t* cpaint;
    const void* text;
    size_t length;
    sk_rect_t* cbounds;
} sk_paint_measure_text_params;

typedef struct {
    sk_paint_t* cpaint;
    sk_fontmetrics_t* cfontmetrics;
    float scale;
} sk_paint_get_fontmetrics_params;

SK_API sk_paint_t* sk_paint_new(void);
SK_API sk_paint_t* sk_paint_clone(sk_paint_t*);
SK_API void sk_paint_delete(sk_paint_t*);
SK_API void sk_paint_reset(sk_paint_t*);
SK_API bool sk_paint_is_antialias(const sk_paint_t*);
SK_API void sk_paint_set_antialias(sk_paint_t*, bool);
SK_API sk_color_t sk_paint_get_color(const sk_paint_t*);
SK_API void sk_paint_set_color(sk_paint_t*, sk_color_t);
SK_API sk_paint_style_t sk_paint_get_style(const sk_paint_t*);
SK_API void sk_paint_set_style(sk_paint_t*, sk_paint_style_t);
SK_API float sk_paint_get_stroke_width(const sk_paint_t*);
SK_API void sk_paint_set_stroke_width(sk_paint_t*, float width);
SK_API float sk_paint_get_stroke_miter(const sk_paint_t*);
SK_API void sk_paint_set_stroke_miter(sk_paint_t*, float miter);
SK_API sk_stroke_cap_t sk_paint_get_stroke_cap(const sk_paint_t*);
SK_API void sk_paint_set_stroke_cap(sk_paint_t*, sk_stroke_cap_t);
SK_API sk_stroke_join_t sk_paint_get_stroke_join(const sk_paint_t*);
SK_API void sk_paint_set_stroke_join(sk_paint_t*, sk_stroke_join_t);
SK_API void sk_paint_set_shader(sk_paint_t*, sk_shader_t*);
SK_API void sk_paint_set_maskfilter(sk_paint_t*, sk_maskfilter_t*);
SK_API void sk_paint_set_blendmode(sk_paint_t*, sk_blendmode_t);
SK_API bool sk_paint_is_dither(const sk_paint_t*);
SK_API void sk_paint_set_dither(sk_paint_t*, bool);
SK_API bool sk_paint_is_verticaltext(const sk_paint_t*);
SK_API void sk_paint_set_verticaltext(sk_paint_t*, bool);
SK_API sk_shader_t* sk_paint_get_shader(sk_paint_t*);
SK_API sk_maskfilter_t* sk_paint_get_maskfilter(sk_paint_t*);
SK_API void sk_paint_set_colorfilter(sk_paint_t*, sk_colorfilter_t*);
SK_API sk_colorfilter_t* sk_paint_get_colorfilter(sk_paint_t*);
SK_API void sk_paint_set_imagefilter(sk_paint_t*, sk_imagefilter_t*);
SK_API sk_imagefilter_t* sk_paint_get_imagefilter(sk_paint_t*);
SK_API sk_blendmode_t sk_paint_get_blendmode(sk_paint_t*);
SK_API void sk_paint_set_filter_quality(sk_paint_t*, sk_filter_quality_t);
SK_API sk_filter_quality_t sk_paint_get_filter_quality(sk_paint_t *);
SK_API sk_typeface_t* sk_paint_get_typeface(sk_paint_t*);
SK_API void sk_paint_set_typeface(sk_paint_t*, sk_typeface_t*);
SK_API float sk_paint_get_textsize(sk_paint_t*);
SK_API void sk_paint_set_textsize(sk_paint_t*, float);
SK_API sk_text_align_t sk_paint_get_text_align(const sk_paint_t*);
SK_API void sk_paint_set_text_align(sk_paint_t*, sk_text_align_t);
SK_API sk_text_encoding_t sk_paint_get_text_encoding(const sk_paint_t*);
SK_API void sk_paint_set_text_encoding(sk_paint_t*, sk_text_encoding_t);
SK_API float sk_paint_get_text_scale_x(const sk_paint_t* cpaint);
SK_API void sk_paint_set_text_scale_x(sk_paint_t* cpaint, float scale);
SK_API float sk_paint_get_text_skew_x(const sk_paint_t* cpaint);
SK_API void sk_paint_set_text_skew_x(sk_paint_t* cpaint, float skew);
SK_API size_t sk_paint_break_text(const sk_paint_t* cpaint, const void* text, size_t length, float maxWidth, float* measuredWidth);
SK_API float sk_paint_measure_text(const sk_paint_measure_text_params* parms);
SK_API sk_path_t* sk_paint_get_text_path(float x, float y, sk_paint_t* cpaint, const void* text, size_t length);
SK_API sk_path_t* sk_paint_get_pos_text_path(sk_paint_t* cpaint, const void* text, size_t length, const sk_point_t pos[]);
SK_API float sk_paint_get_fontmetrics(const sk_paint_get_fontmetrics_params* p);
SK_API sk_path_effect_t* sk_paint_get_path_effect(sk_paint_t* cpaint);
SK_API void sk_paint_set_path_effect(sk_paint_t* cpaint, sk_path_effect_t* effect);
SK_API bool sk_paint_is_linear_text(const sk_paint_t*);
SK_API void sk_paint_set_linear_text(sk_paint_t*, bool);
SK_API bool sk_paint_is_subpixel_text(const sk_paint_t*);
SK_API void sk_paint_set_subpixel_text(sk_paint_t*, bool);
SK_API bool sk_paint_is_lcd_render_text(const sk_paint_t*);
SK_API void sk_paint_set_lcd_render_text(sk_paint_t*, bool);
SK_API bool sk_paint_is_embedded_bitmap_text(const sk_paint_t*);
SK_API void sk_paint_set_embedded_bitmap_text(sk_paint_t*, bool);
SK_API sk_paint_hinting_t sk_paint_get_hinting(const sk_paint_t*);
SK_API void sk_paint_set_hinting(sk_paint_t*, sk_paint_hinting_t);
SK_API bool sk_paint_is_autohinted(const sk_paint_t*);
SK_API void sk_paint_set_autohinted(sk_paint_t*, bool);
SK_API bool sk_paint_is_fake_bold_text(const sk_paint_t*);
SK_API void sk_paint_set_fake_bold_text(sk_paint_t*, bool);
SK_API bool sk_paint_is_dev_kern_text(const sk_paint_t*);
SK_API void sk_paint_set_dev_kern_text(sk_paint_t*, bool);
SK_API bool sk_paint_get_fill_path(const sk_paint_t*, const sk_path_t* src, sk_path_t* dst, float resScale, const sk_rect_t* cullRect);
SK_API int sk_paint_text_to_glyphs(const sk_paint_t* cpaint, const void* text, size_t byteLength, uint16_t* glyphs);
SK_API bool sk_paint_contains_text(const sk_paint_t* cpaint, const void* text, size_t byteLength);
SK_API int sk_paint_count_text(const sk_paint_t* cpaint, const void* text, size_t byteLength);
SK_API int sk_paint_get_text_widths(const sk_paint_t* cpaint, const void* text, size_t byteLength, float* widths, sk_rect_t* bounds);
SK_API int sk_paint_get_text_intercepts(const sk_paint_t* cpaint, const void* text, size_t byteLength, const float bounds[2], float* intervals, float x, float y);
SK_API int sk_paint_get_pos_text_intercepts(const sk_paint_t* cpaint, const void* text, size_t byteLength, sk_point_t* pos, const float bounds[2], float* intervals);
SK_API int sk_paint_get_pos_text_h_intercepts(const sk_paint_t* cpaint, const void* text, size_t byteLength, float* xpos, const float bounds[2], float* intervals, float y);
SK_API int sk_paint_get_pos_text_blob_intercepts(const sk_paint_t* cpaint, sk_textblob_t* blob, const float bounds[2], float* intervals);

SK_C_PLUS_PLUS_END_GUARD

#endif
