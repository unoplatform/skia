#!/bin/bash
# Copyright 2018 Google LLC
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

set -ex

BASE_DIR=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
# This expects the environment variable EMSDK to be set
if [[ ! -d $EMSDK ]]; then
  echo "Be sure to set the EMSDK environment variable."
  exit 1
fi

BUILD_DIR=${BUILD_DIR:="out/canvaskit_wasm"}
mkdir -p $BUILD_DIR
# Navigate to SKIA_HOME from where this file is located.
pushd $BASE_DIR/../..

source $EMSDK/emsdk_env.sh
EMCC=`which emcc`
EMCXX=`which em++`

RELEASE_CONF="-Oz --closure 1 --llvm-lto 3 -DSK_RELEASE "
RELEASE_CONF="${RELEASE_CONF} -s EXPORTED_FUNCTIONS=['_sk_colorspace_unref','_sk_colorspace_gamma_close_to_srgb','_sk_colorspace_gamma_is_linear','_sk_colorspace_is_srgb','_sk_colorspace_gamma_get_type','_sk_colorspace_gamma_get_gamma_named','_sk_colorspace_equals','_sk_colorspace_new_srgb','_sk_colorspace_new_srgb_linear','_sk_colorspace_new_icc','_sk_colorspace_new_rgb_with_gamma','_sk_colorspace_new_rgb_with_gamma_and_gamut','_sk_colorspace_new_rgb_with_coeffs','_sk_colorspace_new_rgb_with_coeffs_and_gamut','_sk_colorspace_new_rgb_with_gamma_named','_sk_colorspace_to_xyzd50','_sk_colorspace_as_to_xyzd50','_sk_colorspace_as_from_xyzd50','_sk_colorspace_is_numerical_transfer_fn','_sk_colorspaceprimaries_to_xyzd50','_sk_colorspace_transfer_fn_invert','_sk_colorspace_transfer_fn_transform','_sk_colortype_get_default_8888','_sk_surface_new_null','_sk_surface_unref','_sk_surface_new_raster','_sk_surface_new_raster_direct','_sk_surface_get_canvas','_sk_surface_new_image_snapshot','_sk_surface_new_backend_render_target','_sk_surface_new_backend_texture','_sk_surface_new_backend_texture_as_render_target','_sk_surface_new_render_target','_sk_surface_draw','_sk_surface_peek_pixels','_sk_surface_read_pixels','_sk_surface_get_props','_sk_surfaceprops_new','_sk_surfaceprops_delete','_sk_surfaceprops_get_flags','_sk_surfaceprops_get_pixel_geometry','_sk_canvas_save','_sk_canvas_save_layer','_sk_canvas_restore','_sk_canvas_get_save_count','_sk_canvas_restore_to_count','_sk_canvas_translate','_sk_canvas_scale','_sk_canvas_rotate_degrees','_sk_canvas_rotate_radians','_sk_canvas_skew','_sk_canvas_concat','_sk_canvas_quick_reject','_sk_canvas_draw_paint','_sk_canvas_draw_region','_sk_canvas_draw_rect','_sk_canvas_draw_rrect','_sk_canvas_draw_round_rect','_sk_canvas_draw_oval','_sk_canvas_draw_circle','_sk_canvas_draw_path','_sk_canvas_draw_image','_sk_canvas_draw_image_rect','_sk_canvas_draw_picture','_sk_canvas_draw_drawable','_sk_canvas_draw_color','_sk_canvas_draw_points','_sk_canvas_draw_point','_sk_canvas_draw_line','_sk_canvas_draw_text','_sk_canvas_draw_pos_text','_sk_canvas_draw_text_on_path','_sk_canvas_draw_text_blob','_sk_canvas_draw_bitmap','_sk_canvas_draw_bitmap_rect','_sk_canvas_reset_matrix','_sk_canvas_set_matrix','_sk_canvas_get_total_matrix','_sk_canvas_draw_annotation','_sk_canvas_draw_url_annotation','_sk_canvas_draw_named_destination_annotation','_sk_canvas_draw_link_destination_annotation','_sk_canvas_clip_rrect_with_operation','_sk_canvas_clip_rect_with_operation','_sk_canvas_clip_path_with_operation','_sk_canvas_clip_region','_sk_canvas_get_device_clip_bounds','_sk_canvas_get_local_clip_bounds','_sk_canvas_new_from_bitmap','_sk_canvas_flush','_sk_canvas_draw_bitmap_lattice','_sk_canvas_draw_image_lattice','_sk_canvas_draw_bitmap_nine','_sk_canvas_draw_image_nine','_sk_canvas_destroy','_sk_canvas_draw_vertices','_sk_colorfilter_unref','_sk_colorfilter_new_mode','_sk_colorfilter_new_lighting','_sk_colorfilter_new_compose','_sk_colorfilter_new_color_matrix','_sk_colorfilter_new_luma_color','_sk_colorfilter_new_table','_sk_colorfilter_new_table_argb','_sk_colorfilter_new_high_contrast','_sk_color_unpremultiply','_sk_color_premultiply','_sk_color_unpremultiply_array','_sk_color_premultiply_array','_sk_color_get_bit_shift','_sk_colortable_unref','_sk_colortable_new','_sk_colortable_count','_sk_colortable_read_colors'] "
RELEASE_CONF="${RELEASE_CONF} -s EXTRA_EXPORTED_RUNTIME_METHODS=['ccall','cwrap','setValue','getValue','UTF8ToString'] "
EXTRA_CFLAGS="\"-DSK_RELEASE\""
if [[ $@ == *debug* ]]; then
  echo "Building a Debug build"
  EXTRA_CFLAGS="\"-DSK_DEBUG\""
  RELEASE_CONF="-O0 --js-opts 0 -s SAFE_HEAP=1 -s ASSERTIONS=1 -s GL_ASSERTIONS=1 -g3 -DPATHKIT_TESTING -DSK_DEBUG"
fi

# Turn off exiting while we check for ninja (which may not be on PATH)
set +e
NINJA=`which ninja`
if [[ -z $NINJA ]]; then
  git clone "https://chromium.googlesource.com/chromium/tools/depot_tools.git" --depth 1 $BUILD_DIR/depot_tools
  NINJA=$BUILD_DIR/depot_tools/ninja
fi
# Re-enable error checking
set -e

echo "Compiling bitcode"

# Inspired by https://github.com/Zubnix/skia-wasm-port/blob/master/build_bindings.sh
./bin/gn gen ${BUILD_DIR} \
  --args="cc=\"${EMCC}\" \
  cxx=\"${EMCXX}\" \
  extra_cflags_cc=[\"-frtti\",\"-Wno-ignored-attributes\"] \
  extra_cflags=[\"-s\",\"USE_FREETYPE=1\",\"-s\",\"USE_LIBPNG=1\", \"-s\", \"WARN_UNALIGNED=1\",
    \"-DIS_WEBGL=1\", \"-DSKNX_NO_SIMD\",
    ${EXTRA_CFLAGS}
  ] \
  is_debug=false \
  is_official_build=true \
  is_component_build=false \
  target_cpu=\"wasm\" \
  \
  skia_use_angle = false \
  skia_use_dng_sdk=false \
  skia_use_egl=true \
  skia_use_expat=false \
  skia_use_fontconfig=false \
  skia_use_freetype=true \
  skia_use_icu=false \
  skia_use_libheif=false \
  skia_use_libjpeg_turbo=false \
  skia_use_libpng=true \
  skia_use_libwebp=false \
  skia_use_lua=false \
  skia_use_piex=false \
  skia_use_vulkan=false \
  skia_use_zlib=true \
  \
  skia_enable_ccpr=false \
  skia_enable_gpu=true \
  skia_enable_fontmgr_empty=false \
  skia_enable_pdf=false"

${NINJA} -C ${BUILD_DIR} libskia.a

export EMCC_CLOSURE_ARGS="--externs $BASE_DIR/externs.js "

echo "Generating final wasm"

# Skottie doesn't end up in libskia and is currently not its own library
# so we just hack in the .cpp files we need for now.
${EMCXX} \
    $RELEASE_CONF \
    -Iinclude/c \
    -Iinclude/codec \
    -Iinclude/config \
    -Iinclude/core \
    -Iinclude/effects \
    -Iinclude/gpu \
    -Iinclude/gpu/gl \
    -Iinclude/pathops \
    -Iinclude/private \
    -Iinclude/utils/ \
    -Imodules/skottie/include \
    -Imodules/sksg/include \
    -Isrc/core/ \
    -Isrc/utils/ \
    -Isrc/sfnt/ \
    -Itools/fonts \
    -Itools \
    -lEGL \
    -lGLESv2 \
    -std=c++14 \
    --bind \
    --pre-js $BASE_DIR/helper.js \
    --pre-js $BASE_DIR/interface.js \
    $BASE_DIR/canvaskit_bindings.cpp \
    $BUILD_DIR/libskia.a \
    modules/skottie/src/Skottie.cpp \
    modules/skottie/src/SkottieAdapter.cpp \
    modules/skottie/src/SkottieAnimator.cpp \
    modules/skottie/src/SkottieJson.cpp \
    modules/skottie/src/SkottieLayer.cpp \
    modules/skottie/src/SkottieLayerEffect.cpp \
    modules/skottie/src/SkottiePrecompLayer.cpp \
    modules/skottie/src/SkottieProperty.cpp \
    modules/skottie/src/SkottieShapeLayer.cpp \
    modules/skottie/src/SkottieTextLayer.cpp \
    modules/skottie/src/SkottieValue.cpp \
    modules/sksg/src/*.cpp \
    src/core/SkCubicMap.cpp \
    src/core/SkTime.cpp \
    src/pathops/SkOpBuilder.cpp \
    tools/fonts/SkTestFontMgr.cpp \
    tools/fonts/SkTestTypeface.cpp \
    src/utils/SkJSON.cpp \
    src/utils/SkParse.cpp \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s EXPORT_NAME="CanvasKitInit" \
    -s FORCE_FILESYSTEM=0 \
    -s MODULARIZE=1 \
    -s NO_EXIT_RUNTIME=1 \
    -s STRICT=1 \
    -s TOTAL_MEMORY=32MB \
    -s USE_FREETYPE=1 \
    -s USE_LIBPNG=1 \
    -s WARN_UNALIGNED=1 \
    -s WASM=1 \
    -o $BUILD_DIR/canvaskit.js
