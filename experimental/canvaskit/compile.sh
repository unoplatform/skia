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

RELEASE_CONF="-Oz --closure 0 --llvm-lto 3 -DSK_RELEASE"
RELEASE_CONF="${RELEASE_CONF} -s EXPORTED_FUNCTIONS=['_sk_colorspace_unref','_sk_colorspace_gamma_close_to_srgb','_sk_colorspace_gamma_is_linear','_sk_colorspace_is_srgb','_sk_colorspace_gamma_get_type','_sk_colorspace_gamma_get_gamma_named','_sk_colorspace_equals','_sk_colorspace_new_srgb','_sk_colorspace_new_srgb_linear','_sk_colorspace_new_icc','_sk_colorspace_new_rgb_with_gamma','_sk_colorspace_new_rgb_with_gamma_and_gamut','_sk_colorspace_new_rgb_with_coeffs','_sk_colorspace_new_rgb_with_coeffs_and_gamut','_sk_colorspace_new_rgb_with_gamma_named','_sk_colorspace_to_xyzd50','_sk_colorspace_as_to_xyzd50','_sk_colorspace_as_from_xyzd50','_sk_colorspace_is_numerical_transfer_fn','_sk_colorspaceprimaries_to_xyzd50','_sk_colorspace_transfer_fn_invert','_sk_colorspace_transfer_fn_transform','_sk_colortype_get_default_8888','_sk_surface_new_null','_sk_surface_unref','_sk_surface_new_raster','_sk_surface_new_raster_direct','_sk_surface_get_canvas','_sk_surface_new_image_snapshot','_sk_surface_new_backend_render_target','_sk_surface_new_backend_texture','_sk_surface_new_backend_texture_as_render_target','_sk_surface_new_render_target','_sk_surface_draw','_sk_surface_peek_pixels','_sk_surface_read_pixels','_sk_surface_get_props','_sk_surfaceprops_new','_sk_surfaceprops_delete','_sk_surfaceprops_get_flags','_sk_surfaceprops_get_pixel_geometry','_sk_canvas_save','_sk_canvas_save_layer','_sk_canvas_restore','_sk_canvas_get_save_count','_sk_canvas_restore_to_count','_sk_canvas_translate','_sk_canvas_scale','_sk_canvas_rotate_degrees','_sk_canvas_rotate_radians','_sk_canvas_skew','_sk_canvas_concat','_sk_canvas_quick_reject','_sk_canvas_draw_paint','_sk_canvas_draw_region','_sk_canvas_draw_rect','_sk_canvas_draw_rrect','_sk_canvas_draw_round_rect','_sk_canvas_draw_oval','_sk_canvas_draw_circle','_sk_canvas_draw_path','_sk_canvas_draw_image','_sk_canvas_draw_image_rect','_sk_canvas_draw_picture','_sk_canvas_draw_drawable','_sk_canvas_draw_color','_sk_canvas_draw_points','_sk_canvas_draw_point','_sk_canvas_draw_line','_sk_canvas_draw_text','_sk_canvas_draw_pos_text','_sk_canvas_draw_text_on_path','_sk_canvas_draw_text_blob','_sk_canvas_draw_bitmap','_sk_canvas_draw_bitmap_rect','_sk_canvas_reset_matrix','_sk_canvas_set_matrix','_sk_canvas_get_total_matrix','_sk_canvas_draw_annotation','_sk_canvas_draw_url_annotation','_sk_canvas_draw_named_destination_annotation','_sk_canvas_draw_link_destination_annotation','_sk_canvas_clip_rrect_with_operation','_sk_canvas_clip_rect_with_operation','_sk_canvas_clip_path_with_operation','_sk_canvas_clip_region','_sk_canvas_get_device_clip_bounds','_sk_canvas_get_local_clip_bounds','_sk_canvas_new_from_bitmap','_sk_canvas_flush','_sk_canvas_draw_bitmap_lattice','_sk_canvas_draw_image_lattice','_sk_canvas_draw_bitmap_nine','_sk_canvas_draw_image_nine','_sk_canvas_destroy','_sk_canvas_draw_vertices','_sk_paint_new','_sk_paint_delete','_sk_paint_reset','_sk_paint_is_antialias','_sk_paint_set_antialias','_sk_paint_is_dither','_sk_paint_set_dither','_sk_paint_is_verticaltext','_sk_paint_set_verticaltext','_sk_paint_get_color','_sk_paint_set_color','_sk_paint_get_style','_sk_paint_set_style','_sk_paint_get_stroke_width','_sk_paint_set_stroke_width','_sk_paint_get_stroke_miter','_sk_paint_set_stroke_miter','_sk_paint_get_stroke_cap','_sk_paint_set_stroke_cap','_sk_paint_get_stroke_join','_sk_paint_set_stroke_join','_sk_paint_set_shader','_sk_paint_get_shader','_sk_paint_set_maskfilter','_sk_paint_get_maskfilter','_sk_paint_set_colorfilter','_sk_paint_get_colorfilter','_sk_paint_set_imagefilter','_sk_paint_get_imagefilter','_sk_paint_set_blendmode','_sk_paint_get_blendmode','_sk_paint_set_filter_quality','_sk_paint_get_filter_quality','_sk_paint_get_typeface','_sk_paint_set_typeface','_sk_paint_get_textsize','_sk_paint_set_textsize','_sk_paint_get_text_align','_sk_paint_set_text_align','_sk_paint_get_text_encoding','_sk_paint_set_text_encoding','_sk_paint_get_text_scale_x','_sk_paint_set_text_scale_x','_sk_paint_get_text_skew_x','_sk_paint_set_text_skew_x','_sk_paint_measure_text','_sk_paint_break_text','_sk_paint_get_text_path','_sk_paint_get_pos_text_path','_sk_paint_get_fontmetrics','_sk_paint_get_path_effect','_sk_paint_set_path_effect','_sk_paint_is_linear_text','_sk_paint_set_linear_text','_sk_paint_is_subpixel_text','_sk_paint_set_subpixel_text','_sk_paint_is_lcd_render_text','_sk_paint_set_lcd_render_text','_sk_paint_is_embedded_bitmap_text','_sk_paint_set_embedded_bitmap_text','_sk_paint_is_autohinted','_sk_paint_set_autohinted','_sk_paint_get_hinting','_sk_paint_set_hinting','_sk_paint_is_fake_bold_text','_sk_paint_set_fake_bold_text','_sk_paint_is_dev_kern_text','_sk_paint_set_dev_kern_text','_sk_paint_get_fill_path','_sk_paint_clone','_sk_paint_text_to_glyphs','_sk_paint_contains_text','_sk_paint_count_text','_sk_paint_get_text_widths','_sk_paint_get_text_intercepts','_sk_paint_get_pos_text_intercepts','_sk_paint_get_pos_text_h_intercepts','_sk_paint_get_pos_text_blob_intercepts','_sk_path_contains','_sk_path_get_last_point','_sk_path_new','_sk_path_delete','_sk_path_move_to','_sk_path_rmove_to','_sk_path_line_to','_sk_path_rline_to','_sk_path_quad_to','_sk_path_rquad_to','_sk_path_conic_to','_sk_path_rconic_to','_sk_path_cubic_to','_sk_path_rcubic_to','_sk_path_close','_sk_path_rewind','_sk_path_reset','_sk_path_add_rect','_sk_path_add_rect_start','_sk_path_add_rrect','_sk_path_add_rrect_start','_sk_path_add_oval','_sk_path_add_arc','_sk_path_add_path_offset','_sk_path_add_path_matrix','_sk_path_add_path','_sk_path_add_path_reverse','_sk_path_get_bounds','_sk_path_compute_tight_bounds','_sk_path_get_filltype','_sk_path_set_filltype','_sk_path_clone','_sk_path_transform','_sk_path_arc_to','_sk_path_rarc_to','_sk_path_arc_to_with_oval','_sk_path_arc_to_with_points','_sk_path_add_rounded_rect','_sk_path_add_circle','_sk_path_count_verbs','_sk_path_count_points','_sk_path_get_point','_sk_path_get_points','_sk_path_get_convexity','_sk_path_set_convexity','_sk_path_parse_svg_string','_sk_path_to_svg_string','_sk_path_convert_conic_to_quads','_sk_path_add_poly','_sk_path_get_segment_masks','_sk_path_is_oval','_sk_path_is_rrect','_sk_path_is_line','_sk_path_is_rect','_sk_pathmeasure_new','_sk_pathmeasure_new_with_path','_sk_pathmeasure_destroy','_sk_pathmeasure_set_path','_sk_pathmeasure_get_length','_sk_pathmeasure_get_pos_tan','_sk_pathmeasure_get_matrix','_sk_pathmeasure_get_segment','_sk_pathmeasure_is_closed','_sk_pathmeasure_next_contour','_sk_pathop_op','_sk_pathop_simplify','_sk_pathop_tight_bounds','_sk_path_create_iter','_sk_path_iter_next','_sk_path_iter_conic_weight','_sk_path_iter_is_close_line','_sk_path_iter_is_closed_contour','_sk_path_iter_destroy','_sk_path_create_rawiter','_sk_path_rawiter_next','_sk_path_rawiter_peek','_sk_path_rawiter_conic_weight','_sk_path_rawiter_destroy','_sk_maskfilter_unref','_sk_maskfilter_new_blur','_sk_maskfilter_new_blur_with_flags','_sk_maskfilter_new_table','_sk_maskfilter_new_gamma','_sk_maskfilter_new_clip','_sk_imagefilter_croprect_new','_sk_imagefilter_croprect_new_with_rect','_sk_imagefilter_croprect_destructor','_sk_imagefilter_croprect_get_rect','_sk_imagefilter_croprect_get_flags','_sk_imagefilter_unref','_sk_imagefilter_new_matrix','_sk_imagefilter_new_alpha_threshold','_sk_imagefilter_new_blur','_sk_imagefilter_new_color_filter','_sk_imagefilter_new_compose','_sk_imagefilter_new_displacement_map_effect','_sk_imagefilter_new_drop_shadow','_sk_imagefilter_new_distant_lit_diffuse','_sk_imagefilter_new_point_lit_diffuse','_sk_imagefilter_new_spot_lit_diffuse','_sk_imagefilter_new_distant_lit_specular','_sk_imagefilter_new_point_lit_specular','_sk_imagefilter_new_spot_lit_specular','_sk_imagefilter_new_magnifier','_sk_imagefilter_new_matrix_convolution','_sk_imagefilter_new_merge','_sk_imagefilter_new_dilate','_sk_imagefilter_new_erode','_sk_imagefilter_new_offset','_sk_imagefilter_new_picture','_sk_imagefilter_new_picture_with_croprect','_sk_imagefilter_new_tile','_sk_imagefilter_new_xfermode','_sk_imagefilter_new_arithmetic','_sk_imagefilter_new_image_source','_sk_imagefilter_new_image_source_default','_sk_imagefilter_new_paint','_sk_colorfilter_unref','_sk_colorfilter_new_mode','_sk_colorfilter_new_lighting','_sk_colorfilter_new_compose','_sk_colorfilter_new_color_matrix','_sk_colorfilter_new_luma_color','_sk_colorfilter_new_table','_sk_colorfilter_new_table_argb','_sk_colorfilter_new_high_contrast','_sk_string_new_empty','_sk_string_new_with_copy','_sk_string_destructor','_sk_string_get_size','_sk_string_get_c_str','_sk_manageddrawable_new','_sk_manageddrawable_destroy','_sk_manageddrawable_set_delegates','_sk_shader_unref','_sk_shader_new_empty','_sk_shader_new_color','_sk_shader_new_local_matrix','_sk_shader_new_color_filter','_sk_shader_new_bitmap','_sk_shader_new_linear_gradient','_sk_shader_new_radial_gradient','_sk_shader_new_sweep_gradient','_sk_shader_new_two_point_conical_gradient','_sk_shader_new_perlin_noise_fractal_noise','_sk_shader_new_perlin_noise_turbulence','_sk_shader_new_compose','_sk_shader_new_compose_with_mode','_sk_typeface_create_default','_sk_typeface_ref_default','_sk_typeface_create_from_name_with_font_style','_sk_typeface_create_from_file','_sk_typeface_create_from_stream','_sk_typeface_unref','_sk_typeface_chars_to_glyphs','_sk_typeface_get_family_name','_sk_typeface_count_tables','_sk_typeface_get_table_tags','_sk_typeface_get_table_size','_sk_typeface_get_table_data','_sk_typeface_get_fontstyle','_sk_typeface_get_font_weight','_sk_typeface_get_font_width','_sk_typeface_get_font_slant','_sk_typeface_open_stream','_sk_typeface_get_units_per_em','_sk_fontmgr_create_default','_sk_fontmgr_ref_default','_sk_fontmgr_unref','_sk_fontmgr_count_families','_sk_fontmgr_get_family_name','_sk_fontmgr_match_family_style_character','_sk_fontmgr_create_styleset','_sk_fontmgr_match_family','_sk_fontmgr_match_family_style','_sk_fontmgr_match_face_style','_sk_fontmgr_create_from_data','_sk_fontmgr_create_from_stream','_sk_fontmgr_create_from_file','_sk_fontstyle_new','_sk_fontstyle_delete','_sk_fontstyle_get_weight','_sk_fontstyle_get_width','_sk_fontstyle_get_slant','_sk_fontstyleset_create_empty','_sk_fontstyleset_unref','_sk_fontstyleset_get_count','_sk_fontstyleset_get_style','_sk_fontstyleset_create_typeface','_sk_fontstyleset_match_style','_sk_memorystream_destroy','_sk_filestream_destroy','_sk_filestream_new','_sk_memorystream_new','_sk_memorystream_new_with_length','_sk_memorystream_new_with_data','_sk_memorystream_new_with_skdata','_sk_memorystream_set_memory','_sk_filestream_is_valid','_sk_managedstream_new','_sk_managedstream_set_delegates','_sk_managedstream_destroy','_sk_managedwstream_new','_sk_managedwstream_destroy','_sk_managedwstream_set_delegates','_sk_codec_min_buffered_bytes_needed','_sk_codec_new_from_stream','_sk_codec_new_from_data','_sk_codec_destroy','_sk_codec_get_info','_sk_codec_get_origin','_sk_codec_get_scaled_dimensions','_sk_codec_get_valid_subset','_sk_codec_get_encoded_format','_sk_codec_get_pixels','_sk_codec_start_incremental_decode','_sk_codec_incremental_decode','_sk_codec_get_repetition_count','_sk_codec_get_frame_count','_sk_codec_get_frame_info','_sk_codec_get_frame_info_for_index','_sk_codec_start_scanline_decode','_sk_codec_get_scanlines','_sk_codec_skip_scanlines','_sk_codec_get_scanline_order','_sk_codec_next_scanline','_sk_codec_output_scanline','_sk_bitmap_new','_sk_bitmap_destructor','_sk_bitmap_get_info','_sk_bitmap_get_pixels','_sk_bitmap_get_pixel_colors','_sk_bitmap_set_pixel_colors','_sk_bitmap_reset','_sk_bitmap_get_row_bytes','_sk_bitmap_get_byte_count','_sk_bitmap_is_null','_sk_bitmap_is_immutable','_sk_bitmap_set_immutable','_sk_bitmap_is_volatile','_sk_bitmap_set_volatile','_sk_bitmap_erase','_sk_bitmap_erase_rect','_sk_bitmap_get_addr_8','_sk_bitmap_get_addr_16','_sk_bitmap_get_addr_32','_sk_bitmap_get_addr','_sk_bitmap_get_pixel_color','_sk_bitmap_set_pixel_color','_sk_bitmap_ready_to_draw','_sk_bitmap_install_pixels','_sk_bitmap_install_pixels_with_pixmap','_sk_bitmap_install_mask_pixels','_sk_bitmap_try_alloc_pixels','_sk_bitmap_try_alloc_pixels_with_flags','_sk_bitmap_set_pixels','_sk_bitmap_peek_pixels','_sk_bitmap_extract_subset','_sk_bitmap_extract_alpha','_sk_bitmap_notify_pixels_changed','_sk_bitmap_swap','_sk_color_unpremultiply','_sk_color_premultiply','_sk_color_unpremultiply_array','_sk_color_premultiply_array','_sk_color_get_bit_shift','_sk_matrix_try_invert','_sk_matrix_concat','_sk_matrix_pre_concat','_sk_matrix_post_concat','_sk_matrix_map_rect','_sk_matrix_map_points','_sk_matrix_map_vectors','_sk_matrix_map_xy','_sk_matrix_map_vector','_sk_matrix_map_radius','_sk_3dview_new','_sk_3dview_destroy','_sk_3dview_save','_sk_3dview_restore','_sk_3dview_translate','_sk_3dview_rotate_x_degrees','_sk_3dview_rotate_y_degrees','_sk_3dview_rotate_z_degrees','_sk_3dview_rotate_x_radians','_sk_3dview_rotate_y_radians','_sk_3dview_rotate_z_radians','_sk_3dview_get_matrix','_sk_3dview_apply_to_canvas','_sk_3dview_dot_with_normal','_sk_matrix44_destroy','_sk_matrix44_new','_sk_matrix44_new_identity','_sk_matrix44_new_copy','_sk_matrix44_new_concat','_sk_matrix44_new_matrix','_sk_matrix44_equals','_sk_matrix44_to_matrix','_sk_matrix44_get_type','_sk_matrix44_set_identity','_sk_matrix44_get','_sk_matrix44_set','_sk_matrix44_as_col_major','_sk_matrix44_as_row_major','_sk_matrix44_set_col_major','_sk_matrix44_set_row_major','_sk_matrix44_set_translate','_sk_matrix44_pre_translate','_sk_matrix44_post_translate','_sk_matrix44_set_scale','_sk_matrix44_pre_scale','_sk_matrix44_post_scale','_sk_matrix44_set_rotate_about_degrees','_sk_matrix44_set_rotate_about_radians','_sk_matrix44_set_rotate_about_radians_unit','_sk_matrix44_set_concat','_sk_matrix44_pre_concat','_sk_matrix44_post_concat','_sk_matrix44_invert','_sk_matrix44_transpose','_sk_matrix44_map_scalars','_sk_matrix44_map2','_sk_matrix44_preserves_2d_axis_alignment','_sk_matrix44_determinant','_sk_path_effect_unref','_sk_path_effect_create_compose','_sk_path_effect_create_sum','_sk_path_effect_create_discrete','_sk_path_effect_create_corner','_sk_path_effect_create_1d_path','_sk_path_effect_create_2d_line','_sk_path_effect_create_2d_path','_sk_path_effect_create_dash','_sk_path_effect_create_trim','_sk_colortable_unref','_sk_colortable_new','_sk_colortable_count','_sk_colortable_read_colors','_sk_vertices_unref','_sk_vertices_make_copy''_FT_Activate_Size','_FT_Add_Default_Modules','_FT_Bitmap_Embolden','_FT_Done_Face','_FT_Done_Library','_FT_Done_Size','_FT_Get_Advance','_FT_Get_Char_Index','_FT_Get_FSType_Flags','_FT_Get_First_Char','_FT_Get_Glyph_Name','_FT_Get_Kerning','_FT_Get_MM_Var','_FT_Get_Next_Char','_FT_Get_PS_Font_Info','_FT_Get_Postscript_Name','_FT_Get_Sfnt_Table','_FT_Get_X11_Font_Format','_FT_GlyphSlot_Own_Bitmap','_FT_Library_SetLcdFilter','_FT_Library_Version','_FT_Load_Glyph','_FT_Load_Sfnt_Table','_FT_MulFix','_FT_New_Library','_FT_New_Size','_FT_Open_Face','_FT_Outline_Decompose','_FT_Outline_Embolden','_FT_Outline_Get_Bitmap','_FT_Outline_Get_CBox','_FT_Outline_Translate','_FT_Render_Glyph','_FT_Select_Charmap','_FT_Select_Size','_FT_Set_Char_Size','_FT_Set_Transform','_FT_Set_Var_Design_Coordinates','_FT_Sfnt_Table_Info','_FT_Vector_Transform','_gr_backendrendertarget_delete','_gr_backendrendertarget_get_backend','_gr_backendrendertarget_get_gl_framebufferinfo','_gr_backendrendertarget_get_height','_gr_backendrendertarget_get_samples','_gr_backendrendertarget_get_stencils','_gr_backendrendertarget_get_width','_gr_backendrendertarget_is_valid','_gr_backendrendertarget_new_gl','_gr_backendtexture_delete','_gr_backendtexture_get_backend','_gr_backendtexture_get_gl_textureinfo','_gr_backendtexture_get_height','_gr_backendtexture_get_width','_gr_backendtexture_has_mipmaps','_gr_backendtexture_is_valid','_gr_backendtexture_new_gl','_gr_context_abandon_context','_gr_context_flush','_gr_context_get_backend','_gr_context_get_max_surface_sample_count_for_color_type','_gr_context_get_resource_cache_limits','_gr_context_get_resource_cache_usage','_gr_context_make_gl','_gr_context_release_resources_and_abandon_context','_gr_context_reset_context','_gr_context_set_resource_cache_limits','_gr_context_unref','_gr_glinterface_assemble_gl_interface','_gr_glinterface_assemble_gles_interface','_gr_glinterface_assemble_interface','_gr_glinterface_create_native_interface','_gr_glinterface_has_extension','_gr_glinterface_unref','_gr_glinterface_validate','_sk_data_get_data','_sk_data_get_size','_sk_data_new_empty','_sk_data_new_from_file','_sk_data_new_from_stream','_sk_data_new_subset','_sk_data_new_uninitialized','_sk_data_new_with_copy','_sk_data_new_with_proc','_sk_data_unref','_sk_document_abort','_sk_document_begin_page','_sk_document_close','_sk_document_create_pdf_from_stream','_sk_document_create_pdf_from_stream_with_metadata','_sk_document_create_xps_from_stream','_sk_document_end_page','_sk_document_unref','_sk_drawable_draw','_sk_drawable_get_bounds','_sk_drawable_get_generation_id','_sk_drawable_new_picture_snapshot','_sk_drawable_notify_drawing_changed','_sk_image_encode','_sk_image_encode_specific','_sk_image_get_alpha_type','_sk_image_get_color_type','_sk_image_get_colorspace','_sk_image_get_height','_sk_image_get_unique_id','_sk_image_get_width','_sk_image_is_alpha_only','_sk_image_is_lazy_generated','_sk_image_is_texture_backed','_sk_image_make_non_texture_image','_sk_image_make_shader','_sk_image_make_subset','_sk_image_make_with_filter','_sk_image_new_from_adopted_texture','_sk_image_new_from_bitmap','_sk_image_new_from_encoded','_sk_image_new_from_picture','_sk_image_new_from_texture','_sk_image_new_raster','_sk_image_new_raster_copy','_sk_image_new_raster_copy_with_pixmap','_sk_image_new_raster_data','_sk_image_peek_pixels','_sk_image_read_pixels','_sk_image_read_pixels_into_pixmap','_sk_image_ref','_sk_image_ref_encoded','_sk_image_scale_pixels','_sk_image_unref','_sk_mask_alloc_image','_sk_mask_compute_image_size','_sk_mask_compute_total_image_size','_sk_mask_free_image','_sk_mask_get_addr','_sk_mask_get_addr_1','_sk_mask_get_addr_32','_sk_mask_get_addr_8','_sk_mask_get_addr_lcd_16','_sk_mask_is_empty','_sk_picture_get_cull_rect','_sk_picture_get_recording_canvas','_sk_picture_get_unique_id','_sk_picture_recorder_begin_recording','_sk_picture_recorder_delete','_sk_picture_recorder_end_recording','_sk_picture_recorder_end_recording_as_drawable','_sk_picture_recorder_new','_sk_picture_unref','_sk_region_contains','_sk_region_contains2','_sk_region_get_bounds','_sk_region_intersects','_sk_region_intersects_rect','_sk_region_new','_sk_region_new2','_sk_region_op','_sk_region_op2','_sk_region_set_path','_sk_region_set_rect','_sk_region_set_region','_sk_rrect_contains','_sk_rrect_delete','_sk_rrect_get_height','_sk_rrect_get_radii','_sk_rrect_get_rect','_sk_rrect_get_type','_sk_rrect_get_width','_sk_rrect_inset','_sk_rrect_is_valid','_sk_rrect_new','_sk_rrect_new_copy','_sk_rrect_offset','_sk_rrect_outset','_sk_rrect_set_empty','_sk_rrect_set_nine_patch','_sk_rrect_set_oval','_sk_rrect_set_rect','_sk_rrect_set_rect_radii','_sk_rrect_set_rect_xy','_sk_rrect_transform','_sk_svgcanvas_create','_sk_textblob_builder_alloc_run_text','_sk_textblob_builder_alloc_run_text_pos','_sk_textblob_builder_alloc_run_text_pos_h','_sk_textblob_builder_delete','_sk_textblob_builder_make','_sk_textblob_builder_new','_sk_textblob_builder_runbuffer_set_clusters','_sk_textblob_builder_runbuffer_set_glyphs','_sk_textblob_builder_runbuffer_set_pos','_sk_textblob_builder_runbuffer_set_pos_points','_sk_textblob_builder_runbuffer_set_utf8_text','_sk_textblob_get_bounds','_sk_textblob_get_unique_id','_sk_textblob_ref','_sk_textblob_unref','_sk_xmlstreamwriter_delete','_sk_xmlstreamwriter_new','_sk_refcnt_safe_unref','_sk_managedstream_set_procs']"
RELEASE_CONF="${RELEASE_CONF} -s RESERVED_FUNCTION_POINTERS=20 -s EXTRA_EXPORTED_RUNTIME_METHODS=['ccall','cwrap','setValue','getValue','lengthBytesUTF8','UTF8ToString','stringToUTF8','lengthBytesUTF16','UTF16ToString','stringToUTF16','addFunction','removeFunction'] "
EXTRA_CFLAGS="\"-DSK_RELEASE\""
if [[ $@ == *debug* ]]; then
  echo "Building a Debug build"
  EXTRA_CFLAGS="\"-DSK_DEBUG\""
  RELEASE_CONF="-O0 --js-opts 0 -s SAFE_HEAP=1 -s ASSERTIONS=1 -s GL_ASSERTIONS=1 -g3 -DPATHKIT_TESTING -DSK_DEBUG"
fi

BUILTIN_FONT="$BASE_DIR/fonts/NotoMono-Regular.ttf.cpp"
if [[ $@ == *no_font* ]]; then
  echo "Omitting the built-in font(s)"
  BUILTIN_FONT=""
else
  # Generate the font's binary file (which is covered by .gitignore)
  python tools/embed_resources.py \
      --name SK_EMBEDDED_FONTS \
      --input $BASE_DIR/fonts/NotoMono-Regular.ttf \
      --output $BASE_DIR/fonts/NotoMono-Regular.ttf.cpp \
      --align 4
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
  SkiaSharp=true \
  \
  skia_use_angle = false \
  skia_use_dng_sdk=false \
  skia_use_egl=true \
  skia_use_expat=false \
  skia_use_fontconfig=false \
  skia_use_freetype=true \
  skia_use_icu=false \
  skia_use_libheif=false \
  skia_use_libjpeg_turbo=true \
  skia_use_libpng=true \
  skia_use_libwebp=false \
  skia_use_lua=false \
  skia_use_piex=false \
  skia_use_system_libpng=true \
  skia_use_vulkan=false \
  skia_use_zlib=true \
  skia_use_xml=true \
  skia_use_system_freetype2=true \
  skia_use_system_libjpeg_turbo = false \
  skia_enable_ccpr=false \
  skia_enable_gpu=true \
  skia_enable_fontmgr_empty=false \
  skia_enable_pdf=false"

${NINJA} -C ${BUILD_DIR} libskia.a

export EMCC_CLOSURE_ARGS="--externs $BASE_DIR/externs.js "

echo "Generating final wasm"

# In the context of dynamic linking, the inclusion of libpng and libfreetype
# is forced, so that emscripten does not rely on its presence in the main module.
# This makes the wasm file larger, but works for most scenarios.

# Skottie doesn't end up in libskia and is currently not its own library
# so we just hack in the .cpp files we need for now.

# Build the wasm output for dynamic linking
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
    --pre-js $BASE_DIR/helper.js \
    --pre-js $BASE_DIR/interface.js \
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
	~/.emscripten_cache/asmjs/ports-builds/libpng/*.o \
	~/.emscripten_cache/asmjs/ports-builds/freetype/libfreetype.a \
    modules/sksg/src/*.cpp \
    $BUILTIN_FONT \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s EXPORT_NAME="CanvasKitInit" \
    -s FORCE_FILESYSTEM=0 \
	-s ALLOW_TABLE_GROWTH=1 \
    -s MODULARIZE=1 \
    -s NO_EXIT_RUNTIME=1 \
    -s STRICT=1 \
    -s USE_FREETYPE=1 \
    -s WARN_UNALIGNED=0 \
    -s WASM=1 \
	-s SIDE_MODULE=1 \
    -s LEGALIZE_JS_FFI=0 \
    -o $BUILD_DIR/libSkiaSharp.wasm


# Build the LLVM bitcode output
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
	-Iinclude/svg \
	-Isrc/xml \
	-Isrc/svg \
	-Isrc/codec \
    -Isrc/core/ \
    -Isrc/utils/ \
    -Isrc/sfnt/ \
    -Itools/fonts \
    -Itools \
    -lEGL \
    -lGLESv2 \
    -std=c++14 \
    --pre-js $BASE_DIR/helper.js \
    --pre-js $BASE_DIR/interface.js \
	~/.emscripten_cache/asmjs/ports-builds/libpng/*.o \
	~/.emscripten_cache/asmjs/ports-builds/freetype/libfreetype.a \
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
	src/utils/SkBase64.cpp \
	src/xml/SkXMLWriter.cpp \
	src/svg/*.cpp \
    modules/sksg/src/*.cpp \
	--bind \
    $BUILTIN_FONT \
	-s LINKABLE=1 \
	-s ALLOW_MEMORY_GROWTH=1 \
	-s ALLOW_TABLE_GROWTH=1 \
    -s FORCE_FILESYSTEM=0 \
    -s NO_EXIT_RUNTIME=1 \
    -s STRICT=1 \
    -s USE_FREETYPE=1 \
    -s USE_LIBPNG=1 \
    -s WARN_UNALIGNED=0 \
    -s WASM=1 \
    -s LEGALIZE_JS_FFI=0 \
 	-s EXPORT_ALL=1 \
    -o $BUILD_DIR/libSkiaSharp.bc