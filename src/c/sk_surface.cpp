/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkCanvas.h"
#include "SkData.h"
#include "SkImage.h"
#include "SkMaskFilter.h"
#include "SkMatrix.h"
#include "SkPaint.h"
#include "SkPath.h"
#include "SkPictureRecorder.h"
#include "SkSurface.h"

#include "sk_canvas.h"
#include "sk_data.h"
#include "sk_image.h"
#include "sk_paint.h"
#include "sk_path.h"
#include "sk_picture.h"
#include "sk_surface.h"

#include "sk_types_priv.h"

const struct {
    sk_pixelgeometry_t fC;
    SkPixelGeometry    fSK;
} gPixelGeometryMap[] = {
    { UNKNOWN_SK_PIXELGEOMETRY, kUnknown_SkPixelGeometry },
    { RGB_H_SK_PIXELGEOMETRY,   kRGB_H_SkPixelGeometry   },
    { BGR_H_SK_PIXELGEOMETRY,   kBGR_H_SkPixelGeometry   },
    { RGB_V_SK_PIXELGEOMETRY,   kRGB_V_SkPixelGeometry   },
    { BGR_V_SK_PIXELGEOMETRY,   kBGR_V_SkPixelGeometry   },
};


static bool from_c_pixelgeometry(sk_pixelgeometry_t cGeom, SkPixelGeometry* skGeom) {
    for (size_t i = 0; i < SK_ARRAY_COUNT(gPixelGeometryMap); ++i) {
        if (gPixelGeometryMap[i].fC == cGeom) {
            if (skGeom) {
                *skGeom = gPixelGeometryMap[i].fSK;
            }
            return true;
        }
    }
    return false;
}

static void from_c_matrix(const sk_matrix_t* cmatrix, SkMatrix* matrix) {
    matrix->setAll(cmatrix->mat[0], cmatrix->mat[1], cmatrix->mat[2],
                   cmatrix->mat[3], cmatrix->mat[4], cmatrix->mat[5],
                   cmatrix->mat[6], cmatrix->mat[7], cmatrix->mat[8]);
}

const struct {
    sk_path_direction_t fC;
    SkPath::Direction   fSk;
} gPathDirMap[] = {
    { CW_SK_PATH_DIRECTION,  SkPath::kCW_Direction },
    { CCW_SK_PATH_DIRECTION, SkPath::kCCW_Direction },
};

static bool from_c_path_direction(sk_path_direction_t cdir, SkPath::Direction* dir) {
    for (size_t i = 0; i < SK_ARRAY_COUNT(gPathDirMap); ++i) {
        if (gPathDirMap[i].fC == cdir) {
            if (dir) {
                *dir = gPathDirMap[i].fSk;
            }
            return true;
        }
    }
    return false;
}

//static SkData* AsData(const sk_data_t* cdata) {
//    return reinterpret_cast<SkData*>(const_cast<sk_data_t*>(cdata));
//}
//
//static sk_data_t* ToData(SkData* data) {
//    return reinterpret_cast<sk_data_t*>(data);
//}

//static sk_rect_t ToRect(const SkRect& rect) {
//    return reinterpret_cast<const sk_rect_t&>(rect);
//}

//static const SkRect& AsRect(const sk_rect_t& crect) {
//    return reinterpret_cast<const SkRect&>(crect);
//}

//static const SkPath& AsPath(const sk_path_t& cpath) {
//    return reinterpret_cast<const SkPath&>(cpath);
//}

static SkPath* as_path(sk_path_t* cpath) {
    return reinterpret_cast<SkPath*>(cpath);
}

//static const SkImage* AsImage(const sk_image_t* cimage) {
//    return reinterpret_cast<const SkImage*>(cimage);
//}
//
//static sk_image_t* ToImage(SkImage* cimage) {
//    return reinterpret_cast<sk_image_t*>(cimage);
//}

//static sk_canvas_t* ToCanvas(SkCanvas* canvas) {
//    return reinterpret_cast<sk_canvas_t*>(canvas);
//}

//static sk_surface_t* ToSurface(SkSurface* surface) {
//    return reinterpret_cast<sk_surface_t*>(surface);
//}

//static SkCanvas* AsCanvas(sk_canvas_t* ccanvas) {
//    return reinterpret_cast<SkCanvas*>(ccanvas);
//}

//static const SkPaint* AsPaint(const sk_paint_t* cpaint) {
//    return reinterpret_cast<const SkPaint*>(cpaint);
//}
//
//static SkSurface* AsSurface(sk_surface_t* csurface) {
//    return reinterpret_cast<SkSurface*>(csurface);
//}
//
//static const SkImageInfo* AsImageInfo(const sk_imageinfo_t* cimageinfo) {
//    return reinterpret_cast<const SkImageInfo*>(cimageinfo);
//}
//
//static const SkSurfaceProps* AsSurfaceProps(const sk_surfaceprops_t* csurfaceprops) {
//    return reinterpret_cast<const SkSurfaceProps*>(csurfaceprops);
//}

//static SkPictureRecorder* AsPictureRecorder(sk_picture_recorder_t* crec) {
//    return reinterpret_cast<SkPictureRecorder*>(crec);
//}
//
//static sk_picture_recorder_t* ToPictureRecorder(SkPictureRecorder* rec) {
//    return reinterpret_cast<sk_picture_recorder_t*>(rec);
//}
//
//static const SkPicture* AsPicture(const sk_picture_t* cpic) {
//    return reinterpret_cast<const SkPicture*>(cpic);
//}
//
//static SkPicture* AsPicture(sk_picture_t* cpic) {
//    return reinterpret_cast<SkPicture*>(cpic);
//}
//
//static sk_picture_t* ToPicture(SkPicture* pic) {
//    return reinterpret_cast<sk_picture_t*>(pic);
//}

///////////////////////////////////////////////////////////////////////////////////////////

//sk_image_t* sk_image_new_raster_copy(const sk_imageinfo_t* cinfo, const void* pixels,
//                                     size_t rowBytes) {
//    const SkImageInfo* info = reinterpret_cast<const SkImageInfo*>(cinfo);
//    return (sk_image_t*)SkImage::MakeRasterCopy(SkPixmap(*info, pixels, rowBytes)).release();
//}
//
//sk_image_t* sk_image_new_from_encoded(const sk_data_t* cdata, const sk_irect_t* subset) {
//    return ToImage(SkImage::MakeFromEncoded(sk_ref_sp(AsData(cdata)),
//                                           reinterpret_cast<const SkIRect*>(subset)).release());
//}
//
//sk_data_t* sk_image_encode(const sk_image_t* cimage) {
//    return ToData(AsImage(cimage)->encodeToData().release());
//}
//
//void sk_image_ref(const sk_image_t* cimage) {
//    AsImage(cimage)->ref();
//}
//
//void sk_image_unref(const sk_image_t* cimage) {
//    AsImage(cimage)->unref();
//}
//
//int sk_image_get_width(const sk_image_t* cimage) {
//    return AsImage(cimage)->width();
//}
//
//int sk_image_get_height(const sk_image_t* cimage) {
//    return AsImage(cimage)->height();
//}
//
//uint32_t sk_image_get_unique_id(const sk_image_t* cimage) {
//    return AsImage(cimage)->uniqueID();
//}

sk_colortype_t sk_colortype_get_default_8888() {
    return (sk_colortype_t)SkColorType::kN32_SkColorType;
}

// surface

sk_surface_t* sk_surface_new_null(int width, int height) {
    return ToSurface(SkSurface::MakeNull(width, height).release());
}

sk_surface_t* sk_surface_new_raster(const sk_imageinfo_t* cinfo, size_t rowBytes, const sk_surfaceprops_t* props) {
    return ToSurface(SkSurface::MakeRaster(AsImageInfo(cinfo), rowBytes, AsSurfaceProps(props)).release());
}

sk_surface_t* sk_surface_new_raster_direct(const sk_imageinfo_t* cinfo, void* pixels, size_t rowBytes, const sk_surface_raster_release_proc releaseProc, void* context, const sk_surfaceprops_t* props) {
    return ToSurface(SkSurface::MakeRasterDirectReleaseProc(AsImageInfo(cinfo), pixels, rowBytes, releaseProc, context, AsSurfaceProps(props)).release());
}
//
//void sk_path_conic_to(sk_path_t* cpath, float x0, float y0, float x1, float y1, float w) {
//    as_path(cpath)->conicTo(x0, y0, x1, y1, w);
//}
//
//void sk_path_cubic_to(sk_path_t* cpath, float x0, float y0, float x1, float y1, float x2, float y2) {
//    as_path(cpath)->cubicTo(x0, y0, x1, y1, x2, y2);
//}
//
//void sk_path_close(sk_path_t* cpath) {
//    as_path(cpath)->close();
//}
//
//void sk_path_add_rect(sk_path_t* cpath, const sk_rect_t* crect, sk_path_direction_t cdir) {
//    SkPath::Direction dir;
//    if (!from_c_path_direction(cdir, &dir)) {
//        return;
//    }
//    as_path(cpath)->addRect(AsRect(*crect), dir);
//}
//
//void sk_path_add_oval(sk_path_t* cpath, const sk_rect_t* crect, sk_path_direction_t cdir) {
//    SkPath::Direction dir;
//    if (!from_c_path_direction(cdir, &dir)) {
//        return;
//    }
//    as_path(cpath)->addOval(AsRect(*crect), dir);
//}
//
//bool sk_path_get_bounds(const sk_path_t* cpath, sk_rect_t* crect) {
//    const SkPath& path = AsPath(*cpath);
//
//    if (path.isEmpty()) {
//        if (crect) {
//            *crect = ToRect(SkRect::MakeEmpty());
//        }
//        return false;
//    }
//
//    if (crect) {
//        *crect = ToRect(path.getBounds());
//    }
//    return true;
//}

///////////////////////////////////////////////////////////////////////////////////////////

//void sk_canvas_save(sk_canvas_t* ccanvas) {
//    AsCanvas(ccanvas)->save();
//}
//
//void sk_canvas_save_layer(sk_canvas_t* ccanvas, const sk_rect_t* crect, const sk_paint_t* cpaint) {
//    AsCanvas(ccanvas)->drawRect(AsRect(*crect), AsPaint(*cpaint));
//}
//
//void sk_canvas_restore(sk_canvas_t* ccanvas) {
//    AsCanvas(ccanvas)->restore();
//}
//
//void sk_canvas_translate(sk_canvas_t* ccanvas, float dx, float dy) {
//    AsCanvas(ccanvas)->translate(dx, dy);
//}
//
//void sk_canvas_scale(sk_canvas_t* ccanvas, float sx, float sy) {
//    AsCanvas(ccanvas)->scale(sx, sy);
//}
//
//void sk_canvas_rotate_degress(sk_canvas_t* ccanvas, float degrees) {
//    AsCanvas(ccanvas)->rotate(degrees);
//}
//
//void sk_canvas_rotate_radians(sk_canvas_t* ccanvas, float radians) {
//    AsCanvas(ccanvas)->rotate(SkRadiansToDegrees(radians));
//}
//
//void sk_canvas_skew(sk_canvas_t* ccanvas, float sx, float sy) {
//    AsCanvas(ccanvas)->skew(sx, sy);
//}
//
//void sk_canvas_concat(sk_canvas_t* ccanvas, const sk_matrix_t* cmatrix) {
//    SkASSERT(cmatrix);
//    SkMatrix matrix;
//    from_c_matrix(cmatrix, &matrix);
//    AsCanvas(ccanvas)->concat(matrix);
//}
//
//void sk_canvas_clip_rect(sk_canvas_t* ccanvas, const sk_rect_t* crect) {
//    AsCanvas(ccanvas)->clipRect(AsRect(*crect));
//}
//
//void sk_canvas_clip_path(sk_canvas_t* ccanvas, const sk_path_t* cpath) {
//    AsCanvas(ccanvas)->clipPath(AsPath(*cpath));
//}
//
//void sk_canvas_draw_paint(sk_canvas_t* ccanvas, const sk_paint_t* cpaint) {
//    AsCanvas(ccanvas)->drawPaint(AsPaint(*cpaint));
//}
//
//void sk_canvas_draw_rect(sk_canvas_t* ccanvas, const sk_rect_t* crect, const sk_paint_t* cpaint) {
//    AsCanvas(ccanvas)->drawRect(AsRect(*crect), AsPaint(*cpaint));
//}
//
//void sk_canvas_draw_circle(sk_canvas_t* ccanvas, float cx, float cy, float rad,
//                           const sk_paint_t* cpaint) {
//    AsCanvas(ccanvas)->drawCircle(cx, cy, rad, AsPaint(*cpaint));
//}
//
//void sk_canvas_draw_oval(sk_canvas_t* ccanvas, const sk_rect_t* crect, const sk_paint_t* cpaint) {
//    AsCanvas(ccanvas)->drawOval(AsRect(*crect), AsPaint(*cpaint));
//}
//
//void sk_canvas_draw_path(sk_canvas_t* ccanvas, const sk_path_t* cpath, const sk_paint_t* cpaint) {
//    AsCanvas(ccanvas)->drawPath(AsPath(*cpath), AsPaint(*cpaint));
//}
//
//void sk_canvas_draw_image(sk_canvas_t* ccanvas, const sk_image_t* cimage, float x, float y,
//                          const sk_paint_t* cpaint) {
//    AsCanvas(ccanvas)->drawImage(AsImage(cimage), x, y, AsPaint(cpaint));
//}
//
//void sk_canvas_draw_image_rect(sk_canvas_t* ccanvas, const sk_image_t* cimage,
//                               const sk_rect_t* csrcR, const sk_rect_t* cdstR,
//                               const sk_paint_t* cpaint) {
//    SkCanvas* canvas = AsCanvas(ccanvas);
//    const SkImage* image = AsImage(cimage);
//    const SkRect& dst = AsRect(*cdstR);
//    const SkPaint* paint = AsPaint(cpaint);
//
//    if (csrcR) {
//        canvas->drawImageRect(image, AsRect(*csrcR), dst, paint);
//    } else {
//        canvas->drawImageRect(image, dst, paint);
//    }
//}
//
//void sk_canvas_draw_picture(sk_canvas_t* ccanvas, const sk_picture_t* cpicture,
//                            const sk_matrix_t* cmatrix, const sk_paint_t* cpaint) {
//    const SkMatrix* matrixPtr = NULL;
//    SkMatrix matrix;
//    if (cmatrix) {
//        from_c_matrix(cmatrix, &matrix);
//        matrixPtr = &matrix;
//    }
//    AsCanvas(ccanvas)->drawPicture(AsPicture(cpicture), matrixPtr, AsPaint(cpaint));
//}
//
/////////////////////////////////////////////////////////////////////////////////////////////

sk_surface_t* sk_surface_new_raster(const sk_imageinfo_t* cinfo,
                                    const sk_surfaceprops_t* props) {
    const SkImageInfo* info = reinterpret_cast<const SkImageInfo*>(cinfo);
    SkPixelGeometry geo = kUnknown_SkPixelGeometry;
    if (props && !from_c_pixelgeometry(props->pixelGeometry, &geo)) {
        return NULL;
    }

    SkSurfaceProps surfProps(0, geo);
    return (sk_surface_t*)SkSurface::MakeRaster(*info, &surfProps).release();
}

sk_surface_t* sk_surface_new_raster_direct(const sk_imageinfo_t* cinfo, void* pixels,
                                           size_t rowBytes,
                                           const sk_surfaceprops_t* props) {
    const SkImageInfo* info = reinterpret_cast<const SkImageInfo*>(cinfo);
    SkPixelGeometry geo = kUnknown_SkPixelGeometry;
    if (props && !from_c_pixelgeometry(props->pixelGeometry, &geo)) {
        return NULL;
    }

    SkSurfaceProps surfProps(0, geo);
    return (sk_surface_t*)SkSurface::MakeRasterDirect(*info, pixels, rowBytes, &surfProps).release();
}

void sk_surface_unref(sk_surface_t* csurf) {
    SkSafeUnref(AsSurface(csurf));
}

sk_canvas_t* sk_surface_get_canvas(sk_surface_t* csurf) {
    return ToCanvas(AsSurface(csurf)->getCanvas());
}

sk_image_t* sk_surface_new_image_snapshot(sk_surface_t* csurf) {
    return ToImage(AsSurface(csurf)->makeImageSnapshot().release());
}

sk_surface_t* sk_surface_new_backend_render_target(gr_context_t* context, const gr_backendrendertarget_t* target, gr_surfaceorigin_t origin, sk_colortype_t colorType, sk_colorspace_t* colorspace, const sk_surfaceprops_t* props) {
    return ToSurface(SkSurface::MakeFromBackendRenderTarget(AsGrContext(context), *AsGrBackendRenderTarget(target), (GrSurfaceOrigin)origin, (SkColorType)colorType, sk_ref_sp(AsColorSpace(colorspace)), AsSurfaceProps(props)).release());
}

sk_surface_t* sk_surface_new_backend_texture(gr_context_t* context, const gr_backendtexture_t* texture, gr_surfaceorigin_t origin, int samples, sk_colortype_t colorType, sk_colorspace_t* colorspace, const sk_surfaceprops_t* props) {
    return ToSurface(SkSurface::MakeFromBackendTexture(AsGrContext(context), *AsGrBackendTexture(texture), (GrSurfaceOrigin)origin, samples, (SkColorType)colorType, sk_ref_sp(AsColorSpace(colorspace)), AsSurfaceProps(props)).release());
}

sk_surface_t* sk_surface_new_backend_texture_as_render_target(gr_context_t* context, const gr_backendtexture_t* texture, gr_surfaceorigin_t origin, int samples, sk_colortype_t colorType, sk_colorspace_t* colorspace, const sk_surfaceprops_t* props) {
    return ToSurface(SkSurface::MakeFromBackendTextureAsRenderTarget(AsGrContext(context), *AsGrBackendTexture(texture), (GrSurfaceOrigin)origin, samples, (SkColorType)colorType, sk_ref_sp(AsColorSpace(colorspace)), AsSurfaceProps(props)).release());
}

sk_surface_t* sk_surface_new_render_target(gr_context_t* context, bool budgeted, const sk_imageinfo_t* cinfo, int sampleCount, gr_surfaceorigin_t origin, const sk_surfaceprops_t* props, bool shouldCreateWithMips) {
    return ToSurface(SkSurface::MakeRenderTarget(AsGrContext(context), (SkBudgeted)budgeted, AsImageInfo(cinfo), sampleCount, (GrSurfaceOrigin)origin, AsSurfaceProps(props), shouldCreateWithMips).release());
}

void sk_surface_draw(sk_surface_t* surface, sk_canvas_t* canvas, float x, float y, const sk_paint_t* paint) {
    AsSurface(surface)->draw(AsCanvas(canvas), x, y, AsPaint(paint));
}

bool sk_surface_peek_pixels(sk_surface_t* surface, sk_pixmap_t* pixmap) {
    return AsSurface(surface)->peekPixels(AsPixmap(pixmap));
}

bool sk_surface_read_pixels(sk_surface_t* surface, sk_imageinfo_t* dstInfo, void* dstPixels, size_t dstRowBytes, int srcX, int srcY) {
    return AsSurface(surface)->readPixels(AsImageInfo(dstInfo), dstPixels, dstRowBytes, srcX, srcY);
}

const sk_surfaceprops_t* sk_surface_get_props(sk_surface_t* surface) {
    return ToSurfaceProps(&AsSurface(surface)->props());
}

// surface props

sk_surfaceprops_t* sk_surfaceprops_new(uint32_t flags, sk_pixelgeometry_t geometry) {
    return ToSurfaceProps(new SkSurfaceProps(flags, (SkPixelGeometry)geometry));
}

void sk_surfaceprops_delete(sk_surfaceprops_t* props) {
    delete AsSurfaceProps(props);
}

uint32_t sk_surfaceprops_get_flags(sk_surfaceprops_t* props) {
    return AsSurfaceProps(props)->flags();
}

sk_pixelgeometry_t sk_surfaceprops_get_pixel_geometry(sk_surfaceprops_t* props) {
    return (sk_pixelgeometry_t)AsSurfaceProps(props)->pixelGeometry();
}
