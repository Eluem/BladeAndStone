class_name LicenseHelper

static func InitLicenseInfo() -> void:
	var dirPath:String
	var filePath:String
	var file:FileAccess

	if(OS.has_feature("android")):
		dirPath = "user://BladeAndStone/"
		if(!DirAccess.dir_exists_absolute("user://BladeAndStone/")):
			DirAccess.make_dir_absolute("user://BladeAndStone/")
	else:
		dirPath = "./License/"
		#dirPath = "res://License/"

	if(!DirAccess.dir_exists_absolute(dirPath)):
		DirAccess.make_dir_absolute(dirPath)

	filePath = dirPath + "GODOT_MIT_LICENSE.txt"
	if(!FileAccess.file_exists(filePath)):
		file = FileAccess.open(filePath, FileAccess.WRITE)
		file.store_string("GODOT MIT LICENSE:
This game uses Godot Engine, available under the following license:

Copyright (c) 2014-present Godot Engine contributors.
Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the \"Software\"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.")
	
	filePath = dirPath + "GODOT_COPYRIGHT.txt"
	if(!FileAccess.file_exists(filePath)):
		file = FileAccess.open(filePath, FileAccess.WRITE)
		file.store_string("GODOT COPYRIGHT:
# Exhaustive licensing information for files in the Godot Engine repository
# =========================================================================
#
# This file aims at documenting the copyright and license for every source
# file in the Godot Engine repository, and especially outline the files
# whose license differs from the MIT/Expat license used by Godot Engine.
#
# It is written as a machine-readable format following the debian/copyright
# specification. Globbing patterns (e.g. \"Files: *\") mean that they affect
# all corresponding files (also recursively in subfolders), apart from those
# with a more explicit copyright statement.
#
# Licenses are given with their debian/copyright short name (or SPDX identifier
# if no standard short name exists) and are all included in plain text at the
# end of this file (in alphabetical order).
#
# Disclaimer for thirdparty libraries:
# ------------------------------------
#
# Licensing details for thirdparty libraries in the 'thirdparty/' directory
# are given in summarized form, i.e. with only the \"main\" license described
# in the library's license statement. Different licenses of single files or
# code snippets in thirdparty libraries are not documented here.
# For example:
#   Files: ./thirdparty/zlib/
#   Copyright: 1995-2017, Jean-loup Gailly and Mark Adler
#   License: Zlib
# The exact copyright for each file in that library *may* differ, and some
# files or code snippets might be distributed under other compatible licenses
# (e.g. a public domain dedication), but as far as Godot Engine is concerned
# the library is considered as a whole under the Zlib license.
#
# Note: When linking dynamically against thirdparty libraries instead of
# building them into the Godot binary, you may remove the corresponding
# license details from this file.

-----------------------------------------------------------------------

Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: Godot Engine
Upstream-Contact: Rémi Verschelde <contact@godotengine.org>
Source: https://github.com/godotengine/godot

Files: *
Comment: Godot Engine
Copyright: 2014-present, Godot Engine contributors
 2007-2014, Juan Linietsky, Ariel Manzur
License: Expat

Files: ./icon.png
 ./icon.svg
 ./logo.png
 ./logo.svg
Comment: Godot Engine logo
Copyright: 2017, Andrea Calabró
License: CC-BY-4.0

Files: ./core/math/convex_hull.cpp
 ./core/math/convex_hull.h
Comment: Bullet Continuous Collision Detection and Physics Library
Copyright: 2011, Ole Kniemeyer, MAXON, www.maxon.net
 2014-present, Godot Engine contributors
 2007-2014, Juan Linietsky, Ariel Manzur
License: Expat and Zlib

Files: ./modules/godot_physics_2d/godot_joints_2d.cpp
Comment: Chipmunk2D Joint Constraints
Copyright: 2007, Scott Lembcke
License: Expat

Files: ./modules/godot_physics_3d/gjk_epa.cpp
 ./modules/godot_physics_3d/joints/godot_generic_6dof_joint_3d.cpp
 ./modules/godot_physics_3d/joints/godot_generic_6dof_joint_3d.h
 ./modules/godot_physics_3d/joints/godot_hinge_joint_3d.cpp
 ./modules/godot_physics_3d/joints/godot_hinge_joint_3d_sw.h
 ./modules/godot_physics_3d/joints/godot_jacobian_entry_3d_sw.h
 ./modules/godot_physics_3d/joints/godot_pin_joint_3d.cpp
 ./modules/godot_physics_3d/joints/godot_pin_joint_3d.h
 ./modules/godot_physics_3d/joints/godot_slider_joint_3d.cpp
 ./modules/godot_physics_3d/joints/godot_slider_joint_3d.h
 ./modules/godot_physics_3d/godot_soft_body_3d.cpp
 ./modules/godot_physics_3d/godot_soft_body_3d.h
 ./modules/godot_physics_3d/godot_shape_3d.cpp
 ./modules/godot_physics_3d/godot_shape_3d.h
Comment: Bullet Continuous Collision Detection and Physics Library
Copyright: 2003-2008, Erwin Coumans
 2014-present, Godot Engine contributors
 2007-2014, Juan Linietsky, Ariel Manzur
License: Expat and Zlib

Files: ./modules/godot_physics_3d/godot_collision_solver_3d_sat.cpp
Comment: Open Dynamics Engine
Copyright: 2001-2003, Russell L. Smith, Alen Ladavac, Nguyen Binh
License: BSD-3-clause

Files: ./modules/godot_physics_3d/joints/godot_cone_twist_joint_3d.cpp
 ./modules/godot_physics_3d/joints/godot_cone_twist_joint_3d.h
Comment: Bullet Continuous Collision Detection and Physics Library
Copyright: 2007, Starbreeze Studios
 2014-present, Godot Engine contributors
 2007-2014, Juan Linietsky, Ariel Manzur
License: Expat and Zlib

Files: ./modules/jolt_physics/spaces/jolt_temp_allocator.cpp
Comment: Jolt Physics
Copyright: 2021, Jorrit Rouwe
 2014-present, Godot Engine contributors
 2007-2014, Juan Linietsky, Ariel Manzur
License: Expat

Files: ./modules/lightmapper_rd/lm_compute.glsl
Comment: Joint Non-Local Means (JNLM) denoiser
Copyright: 2020, Manuel Prandini
 2014-present, Godot Engine contributors
 2007-2014, Juan Linietsky, Ariel Manzur
License: Expat

Files: ./platform/android/java/editor/src/main/java/com/android/*
 ./platform/android/java/lib/aidl/com/android/*
 ./platform/android/java/lib/res/layout/status_bar_ongoing_event_progress_bar.xml
 ./platform/android/java/lib/src/com/google/android/*
 ./platform/android/java/lib/src/org/godotengine/godot/input/InputManagerCompat.java
 ./platform/android/java/lib/src/org/godotengine/godot/input/InputManagerV16.java
Comment: The Android Open Source Project
Copyright: 2008-2016, The Android Open Source Project
 2002, Google, Inc.
License: Apache-2.0

Files: ./platform/android/java/lib/src/org/godotengine/godot/utils/ProcessPhoenix.java
Comment: ProcessPhoenix
Copyright: 2015, Jake Wharton
License: Apache-2.0

Files: ./scene/animation/easing_equations.h
Comment: Robert Penner's Easing Functions
Copyright: 2001, Robert Penner
 2014-present, Godot Engine contributors
 2007-2014, Juan Linietsky, Ariel Manzur
License: Expat

Files: ./servers/rendering/renderer_rd/shaders/ss_effects_downsample.glsl
 ./servers/rendering/renderer_rd/shaders/ssao_blur.glsl
 ./servers/rendering/renderer_rd/shaders/ssao_importance_map.glsl
 ./servers/rendering/renderer_rd/shaders/ssao_interleave.glsl
 ./servers/rendering/renderer_rd/shaders/ssao.glsl
 ./servers/rendering/renderer_rd/shaders/ssil_blur.glsl
 ./servers/rendering/renderer_rd/shaders/ssil_importance_map.glsl
 ./servers/rendering/renderer_rd/shaders/ssil_interleave.glsl
 ./servers/rendering/renderer_rd/shaders/ssil.glsl
Comment: Intel ASSAO and related files
Copyright: 2016, Intel Corporation
License: Expat

Files: ./servers/rendering/renderer_rd/shaders/effects/taa_resolve.glsl
Comment: Temporal Anti-Aliasing resolve implementation
Copyright: 2016, Panos Karabelas
License: Expat

Files: ./thirdparty/amd-fsr/
Comment: AMD FidelityFX Super Resolution
Copyright: 2021, Advanced Micro Devices, Inc.
License: Expat

Files: ./thirdparty/amd-fsr2/
Comment: AMD FidelityFX Super Resolution 2
Copyright: 2022-2023, Advanced Micro Devices, Inc.
License: Expat

Files: ./thirdparty/angle/
Comment: ANGLE
Copyright: 2018, The ANGLE Project Authors.
License: BSD-3-clause

Files: ./thirdparty/astcenc/
Comment: Arm ASTC Encoder
Copyright: 2011-2024, Arm Limited
License: Apache-2.0

Files: ./thirdparty/basis_universal/
Comment: Basis Universal
Copyright: 2022, Binomial LLC.
License: Apache-2.0

Files: ./thirdparty/brotli/
Comment: Brotli
Copyright: 2009, 2010, 2013-2016 by the Brotli Authors.
License: Expat

Files: ./thirdparty/certs/ca-certificates.crt
Comment: CA certificates
Copyright: Mozilla Contributors
License: MPL-2.0

Files: ./thirdparty/clipper2/
Comment: Clipper2
Copyright: 2010-2024, Angus Johnson
License: BSL-1.0

Files: ./thirdparty/cvtt/
Comment: Convection Texture Tools Stand-Alone Kernels
Copyright: 2018, Eric Lasota
 2018, Microsoft Corp.
License: Expat

Files: ./thirdparty/d3d12ma/
Comment: D3D12 Memory Allocator
Copyright: 2019-2022 Advanced Micro Devices, Inc.
License: Expat

Files: ./thirdparty/directx_headers/
Comment: DirectX Headers
Copyright: Microsoft Corporation
License: Expat

Files: ./thirdparty/doctest/
Comment: doctest
Copyright: 2016-2023, Viktor Kirilov
License: Expat

Files: ./thirdparty/embree/
Comment: Embree
Copyright: 2009-2021 Intel Corporation
License: Apache-2.0

Files: ./thirdparty/enet/
Comment: ENet
Copyright: 2002-2024, Lee Salzman
License: Expat

Files: ./thirdparty/etcpak/
Comment: etcpak
Copyright: 2013-2022, Bartosz Taudul
License: BSD-3-clause

Files: ./thirdparty/fonts/DroidSans*.woff2
Comment: DroidSans font
Copyright: 2008, The Android Open Source Project
License: Apache-2.0

Files: ./thirdparty/fonts/JetBrainsMono_Regular.woff2
Comment: JetBrains Mono font
Copyright: 2020, JetBrains s.r.o.
License: OFL-1.1

Files: ./thirdparty/fonts/NotoSans*.woff2
Comment: Noto Sans font
Copyright: 2012, Google Inc.
License: OFL-1.1

Files: ./thirdparty/fonts/Vazirmatn*.woff2
Comment: Vazirmatn font
Copyright: 2015, The Vazirmatn Project Authors.
License: OFL-1.1

Files: ./thirdparty/freetype/
Comment: The FreeType Project
Copyright: 1996-2023, David Turner, Robert Wilhelm, and Werner Lemberg.
License: FTL

Files: ./thirdparty/glad/
Comment: glad
Copyright: 2013-2022, David Herberth
 2013-2020, The Khronos Group Inc.
License: CC0-1.0 and Apache-2.0

Files: ./thirdparty/glslang/
Comment: glslang
Copyright: 2015-2020, Google, Inc.
  2014-2020, The Khronos Group Inc
  2002, NVIDIA Corporation.
License: glslang

Files: ./thirdparty/graphite/
Comment: Graphite engine
Copyright: 2010, SIL International
License: Expat

Files: ./thirdparty/harfbuzz/
Comment: HarfBuzz text shaping library
Copyright: 2010-2022, Google, Inc.
 2015-2020, Ebrahim Byagowi
 2019,2020, Facebook, Inc.
 2012, 2015, Mozilla Foundation
 2011, Codethink Limited
 2008, 2010, Nokia Corporation and/or its subsidiary(-ies)
 2009, Keith Stribley
 2011, Martin Hosken and SIL International
 2007, Chris Wilson
 2005-2006, 2020-2023, Behdad Esfahbod
 2004, 2007-2010, 2013, 2021-2023, Red Hat, Inc.
 1998-2005, David Turner and Werner Lemberg
 2016, Igalia, S.L.
 2022, Matthias Clasen
 2018, 2021, Khaled Hosny
 2018-2020, Adobe, Inc.
 2013-2015, Alexei Podtelezhnikov
License: HarfBuzz

Files: ./thirdparty/icu4c/
Comment: International Components for Unicode
Copyright: 2016-2024, Unicode, Inc.
License: Unicode

Files: ./thirdparty/jolt_physics/
Comment: Jolt Physics
Copyright: 2021, Jorrit Rouwe
License: Expat

Files: ./thirdparty/jpeg-compressor/
Comment: jpeg-compressor
Copyright: 2012, Rich Geldreich
License: public-domain or Apache-2.0

Files: ./thirdparty/libbacktrace/
Comment: libbacktrace
Copyright: 2012-2021, Free Software Foundation, Inc.
License: BSD-3-clause

Files: ./thirdparty/libktx/
Comment: KTX
Copyright: 2013-2020, Mark Callow
 2010-2020 The Khronos Group, Inc.
License: Apache-2.0

Files: ./thirdparty/libogg/
Comment: OggVorbis
Copyright: 2002, Xiph.org Foundation
License: BSD-3-clause

Files: ./thirdparty/libpng/
Comment: libpng
Copyright: 1995-2024, The PNG Reference Library Authors.
 2018-2024, Cosmin Truta.
 2000-2002, 2004, 2006-2018 Glenn Randers-Pehrson.
 1996-1997, Andreas Dilger.
 1995-1996, Guy Eric Schalnat, Group 42, Inc.
License: Zlib

Files: ./thirdparty/libtheora/
Comment: OggTheora
Copyright: 2002-2009, Xiph.org Foundation
License: BSD-3-clause

Files: ./thirdparty/libvorbis/
Comment: OggVorbis
Copyright: 2002-2015, Xiph.org Foundation
License: BSD-3-clause

Files: ./thirdparty/libwebp/
Comment: WebP codec
Copyright: 2010, Google Inc.
License: BSD-3-clause

Files: ./thirdparty/manifold/
Comment: Manifold
Copyright: 2020-2024, The Manifold Authors
License: Apache-2.0

Files: ./thirdparty/mbedtls/
Comment: Mbed TLS
Copyright: The Mbed TLS Contributors
License: Apache-2.0

Files: ./thirdparty/meshoptimizer/
Comment: meshoptimizer
Copyright: 2016-2024, Arseny Kapoulkine
License: Expat

Files: ./thirdparty/mingw-std-threads/
Comment: mingw-std-threads
Copyright: 2016, Mega Limited
License: BSD-2-clause

Files: ./thirdparty/minimp3/
Comment: MiniMP3
Copyright: lieff
License: CC0-1.0

Files: ./thirdparty/miniupnpc/
Comment: MiniUPnP Project
Copyright: 2005-2024, Thomas Bernard
License: BSD-3-clause

Files: ./thirdparty/minizip/
Comment: MiniZip
Copyright: 1998-2010, Gilles Vollant
 2007-2008, Even Rouault
 2009-2010, Mathias Svensson
License: Zlib

Files: ./thirdparty/misc/cubemap_coeffs.h
Comment: Fast Filtering of Reflection Probes
Copyright: 2016, Activision Publishing, Inc.
License: Expat

Files: ./thirdparty/misc/fastlz.c
 ./thirdparty/misc/fastlz.h
Comment: FastLZ
Copyright: 2005-2020, Ariya Hidayat
License: Expat

Files: ./thirdparty/misc/ifaddrs-android.cc
 ./thirdparty/misc/ifaddrs-android.h
Comment: libjingle
Copyright: 2012-2013, Google Inc.
License: BSD-3-clause

Files: ./thirdparty/misc/mikktspace.c
 ./thirdparty/misc/mikktspace.h
Comment: Tangent Space Normal Maps implementation
Copyright: 2011, Morten S. Mikkelsen
License: Zlib

Files: ./thirdparty/misc/ok_color.h
 ./thirdparty/misc/ok_color_shader.h
Comment: OK Lab color space
Copyright: 2021, Björn Ottosson
License: Expat

Files: ./thirdparty/noise/FastNoiseLite.h
Comment: FastNoise Lite
Copyright: 2023, Jordan Peck and contributors
License: Expat

Files: ./thirdparty/misc/pcg.cpp
 ./thirdparty/misc/pcg.h
Comment: Minimal PCG32 implementation
Copyright: 2014, M.E. O'Neill
License: Apache-2.0

Files: ./thirdparty/misc/polypartition.cpp
 ./thirdparty/misc/polypartition.h
Comment: PolyPartition / Triangulator
Copyright: 2011-2021, Ivan Fratric and contributors
License: Expat

Files: ./thirdparty/misc/qoa.h
Comment: Quite OK Audio Format
Copyright: 2023, Dominic Szablewski
License: Expat

Files: ./thirdparty/misc/r128.c
 ./thirdparty/misc/r128.h
Comment: r128 library
Copyright: Alan Hickman
License: public-domain or Unlicense

Files: ./thirdparty/misc/smaz.c
 ./thirdparty/misc/smaz.h
Comment: SMAZ
Copyright: 2006-2009, Salvatore Sanfilippo
License: BSD-3-clause

Files: ./thirdparty/misc/smolv.cpp
 ./thirdparty/misc/smolv.h
Comment: SMOL-V
Copyright: 2016-2024, Aras Pranckevicius
License: public-domain or Unlicense or Expat

Files: ./thirdparty/misc/stb_rect_pack.h
Comment: stb libraries
Copyright: Sean Barrett
License: public-domain or Unlicense or Expat

Files: ./thirdparty/misc/yuv2rgb.h
Comment: YUV2RGB
Copyright: 2008-2011, Robin Watts
License: BSD-2-clause

Files: ./thirdparty/msdfgen/
Comment: Multi-channel signed distance field generator
Copyright: 2016-2022, Viktor Chlumsky
License: Expat

Files: ./thirdparty/nvapi/nvapi_minimal.h
Comment: Stripped down version of \"nvapi.h\" from the NVIDIA NVAPI SDK
Copyright: 2019-2022, NVIDIA Corporation
License: Expat

Files: ./thirdparty/openxr/
Comment: OpenXR Loader
Copyright: 2020-2023, The Khronos Group Inc.
License: Apache-2.0

Files: ./thirdparty/pcre2/
Comment: PCRE2
Copyright: 1997-2024, University of Cambridge
 2009-2024, Zoltan Herczeg
License: BSD-3-clause

Files: ./thirdparty/recastnavigation/
Comment: Recast
Copyright: 2009, Mikko Mononen
License: Zlib

Files: ./thirdparty/rvo2/
Comment: RVO2
Copyright: 2016, University of North Carolina at Chapel Hill
License: Apache-2.0

Files: ./thirdparty/spirv-cross/
Comment: SPIRV-Cross
Copyright: 2015-2021, Arm Limited
License: Apache-2.0 or Expat

Files: ./thirdparty/spirv-reflect/
Comment: SPIRV-Reflect
Copyright: 2017-2022, Google Inc.
License: Apache-2.0

Files: ./thirdparty/squish/
Comment: libSquish
Copyright: 2006, Simon Brown
License: Expat

Files: ./thirdparty/thorvg/
Comment: ThorVG
Copyright: 2020-2024, The ThorVG Project
License: Expat

Files: ./thirdparty/tinyexr/
Comment: TinyEXR
Copyright: 2014-2021, Syoyo Fujita
  2002, Industrial Light & Magic, a division of Lucas Digital Ltd. LLC
License: BSD-3-clause

Files: ./thirdparty/ufbx/
Comment: ufbx
Copyright: 2020, Samuli Raivio
License: Expat

Files: ./thirdparty/vhacd/
Comment: V-HACD
Copyright: 2011, Khaled Mamou
  2003-2009, Erwin Coumans
License: BSD-3-clause

Files: ./thirdparty/volk/
Comment: volk
Copyright: 2018-2024, Arseny Kapoulkine
License: Expat

Files: ./thirdparty/vulkan/
Comment: Vulkan Headers
Copyright: 2014-2024, The Khronos Group Inc.
  2014-2024, Valve Corporation
  2014-2024, LunarG, Inc.
License: Apache-2.0

Files: ./thirdparty/vulkan/vk_mem_alloc.h
Comment: Vulkan Memory Allocator
Copyright: 2017-2024, Advanced Micro Devices, Inc.
License: Expat

Files: ./thirdparty/wayland/
Comment: Wayland core protocol
Copyright: 2008-2012, Kristian Høgsberg
  2010-2012, Intel Corporation
  2011, Benjamin Franzke
  2012, Collabora, Ltd.
License: Expat

Files: ./thirdparty/wayland-protocols/
Comment: Wayland protocols that add functionality not available in the core protocol
Copyright: 2008-2013, Kristian Høgsberg
  2010-2013, Intel Corporation
  2013,      Rafael Antognolli
  2013,      Jasper St. Pierre
  2014,      Jonas Ådahl
  2014,      Jason Ekstrand
  2014-2015, Collabora, Ltd.
  2015,      Red Hat Inc.
License: Expat

Files: ./thirdparty/wslay/
Comment: Wslay
Copyright: 2011, 2012, 2015, Tatsuhiro Tsujikawa
License: Expat

Files: ./thirdparty/xatlas/
Comment: xatlas
Copyright: 2018-2020, Jonathan Young
  2013, Thekla, Inc
  2006, NVIDIA Corporation, Ignacio Castano
License: Expat

Files: ./thirdparty/zlib/
Comment: zlib
Copyright: 1995-2024, Jean-loup Gailly and Mark Adler
License: Zlib

Files: ./thirdparty/zstd/
Comment: Zstandard
Copyright: Meta Platforms, Inc. and affiliates.
License: BSD-3-clause



License: Apache-2.0
							   Apache License
						 Version 2.0, January 2004
					  http://www.apache.org/licenses/
 .
 TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION
 .
 1. Definitions.
 .
	\"License\" shall mean the terms and conditions for use, reproduction,
	and distribution as defined by Sections 1 through 9 of this document.
 .
	\"Licensor\" shall mean the copyright owner or entity authorized by
	the copyright owner that is granting the License.
 .
	\"Legal Entity\" shall mean the union of the acting entity and all
	other entities that control, are controlled by, or are under common
	control with that entity. For the purposes of this definition,
	\"control\" means (i) the power, direct or indirect, to cause the
	direction or management of such entity, whether by contract or
	otherwise, or (ii) ownership of fifty percent (50%) or more of the
	outstanding shares, or (iii) beneficial ownership of such entity.
 .
	\"You\" (or \"Your\") shall mean an individual or Legal Entity
	exercising permissions granted by this License.
 .
	\"Source\" form shall mean the preferred form for making modifications,
	including but not limited to software source code, documentation
	source, and configuration files.
 .
	\"Object\" form shall mean any form resulting from mechanical
	transformation or translation of a Source form, including but
	not limited to compiled object code, generated documentation,
	and conversions to other media types.
 .
	\"Work\" shall mean the work of authorship, whether in Source or
	Object form, made available under the License, as indicated by a
	copyright notice that is included in or attached to the work
	(an example is provided in the Appendix below).
 .
	\"Derivative Works\" shall mean any work, whether in Source or Object
	form, that is based on (or derived from) the Work and for which the
	editorial revisions, annotations, elaborations, or other modifications
	represent, as a whole, an original work of authorship. For the purposes
	of this License, Derivative Works shall not include works that remain
	separable from, or merely link (or bind by name) to the interfaces of,
	the Work and Derivative Works thereof.
 .
	\"Contribution\" shall mean any work of authorship, including
	the original version of the Work and any modifications or additions
	to that Work or Derivative Works thereof, that is intentionally
	submitted to Licensor for inclusion in the Work by the copyright owner
	or by an individual or Legal Entity authorized to submit on behalf of
	the copyright owner. For the purposes of this definition, \"submitted\"
	means any form of electronic, verbal, or written communication sent
	to the Licensor or its representatives, including but not limited to
	communication on electronic mailing lists, source code control systems,
	and issue tracking systems that are managed by, or on behalf of, the
	Licensor for the purpose of discussing and improving the Work, but
	excluding communication that is conspicuously marked or otherwise
	designated in writing by the copyright owner as \"Not a Contribution.\"
 .
	\"Contributor\" shall mean Licensor and any individual or Legal Entity
	on behalf of whom a Contribution has been received by Licensor and
	subsequently incorporated within the Work.
 .
 2. Grant of Copyright License. Subject to the terms and conditions of
	this License, each Contributor hereby grants to You a perpetual,
	worldwide, non-exclusive, no-charge, royalty-free, irrevocable
	copyright license to reproduce, prepare Derivative Works of,
	publicly display, publicly perform, sublicense, and distribute the
	Work and such Derivative Works in Source or Object form.
 .
 3. Grant of Patent License. Subject to the terms and conditions of
	this License, each Contributor hereby grants to You a perpetual,
	worldwide, non-exclusive, no-charge, royalty-free, irrevocable
	(except as stated in this section) patent license to make, have made,
	use, offer to sell, sell, import, and otherwise transfer the Work,
	where such license applies only to those patent claims licensable
	by such Contributor that are necessarily infringed by their
	Contribution(s) alone or by combination of their Contribution(s)
	with the Work to which such Contribution(s) was submitted. If You
	institute patent litigation against any entity (including a
	cross-claim or counterclaim in a lawsuit) alleging that the Work
	or a Contribution incorporated within the Work constitutes direct
	or contributory patent infringement, then any patent licenses
	granted to You under this License for that Work shall terminate
	as of the date such litigation is filed.
 .
 4. Redistribution. You may reproduce and distribute copies of the
	Work or Derivative Works thereof in any medium, with or without
	modifications, and in Source or Object form, provided that You
	meet the following conditions:
 .
 (a) You must give any other recipients of the Work or
	 Derivative Works a copy of this License; and
 .
 (b) You must cause any modified files to carry prominent notices
	 stating that You changed the files; and
 .
 (c) You must retain, in the Source form of any Derivative Works
	 that You distribute, all copyright, patent, trademark, and
	 attribution notices from the Source form of the Work,
	 excluding those notices that do not pertain to any part of
	 the Derivative Works; and
 .
 (d) If the Work includes a \"NOTICE\" text file as part of its
	 distribution, then any Derivative Works that You distribute must
	 include a readable copy of the attribution notices contained
	 within such NOTICE file, excluding those notices that do not
	 pertain to any part of the Derivative Works, in at least one
	 of the following places: within a NOTICE text file distributed
	 as part of the Derivative Works; within the Source form or
	 documentation, if provided along with the Derivative Works; or,
	 within a display generated by the Derivative Works, if and
	 wherever such third-party notices normally appear. The contents
	 of the NOTICE file are for informational purposes only and
	 do not modify the License. You may add Your own attribution
	 notices within Derivative Works that You distribute, alongside
	 or as an addendum to the NOTICE text from the Work, provided
	 that such additional attribution notices cannot be construed
	 as modifying the License.
 .
 You may add Your own copyright statement to Your modifications and
 may provide additional or different license terms and conditions
 for use, reproduction, or distribution of Your modifications, or
 for any such Derivative Works as a whole, provided Your use,
 reproduction, and distribution of the Work otherwise complies with
 the conditions stated in this License.
 .
 5. Submission of Contributions. Unless You explicitly state otherwise,
	any Contribution intentionally submitted for inclusion in the Work
	by You to the Licensor shall be under the terms and conditions of
	this License, without any additional terms or conditions.
	Notwithstanding the above, nothing herein shall supersede or modify
	the terms of any separate license agreement you may have executed
	with Licensor regarding such Contributions.
 .
 6. Trademarks. This License does not grant permission to use the trade
	names, trademarks, service marks, or product names of the Licensor,
	except as required for reasonable and customary use in describing the
	origin of the Work and reproducing the content of the NOTICE file.
 .
 7. Disclaimer of Warranty. Unless required by applicable law or
	agreed to in writing, Licensor provides the Work (and each
	Contributor provides its Contributions) on an \"AS IS\" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
	implied, including, without limitation, any warranties or conditions
	of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
	PARTICULAR PURPOSE. You are solely responsible for determining the
	appropriateness of using or redistributing the Work and assume any
	risks associated with Your exercise of permissions under this License.
 .
 8. Limitation of Liability. In no event and under no legal theory,
	whether in tort (including negligence), contract, or otherwise,
	unless required by applicable law (such as deliberate and grossly
	negligent acts) or agreed to in writing, shall any Contributor be
	liable to You for damages, including any direct, indirect, special,
	incidental, or consequential damages of any character arising as a
	result of this License or out of the use or inability to use the
	Work (including but not limited to damages for loss of goodwill,
	work stoppage, computer failure or malfunction, or any and all
	other commercial damages or losses), even if such Contributor
	has been advised of the possibility of such damages.
 .
 9. Accepting Warranty or Additional Liability. While redistributing
	the Work or Derivative Works thereof, You may choose to offer,
	and charge a fee for, acceptance of support, warranty, indemnity,
	or other liability obligations and/or rights consistent with this
	License. However, in accepting such obligations, You may act only
	on Your own behalf and on Your sole responsibility, not on behalf
	of any other Contributor, and only if You agree to indemnify,
	defend, and hold each Contributor harmless for any liability
	incurred by, or claims asserted against, such Contributor by reason
	of your accepting any such warranty or additional liability.
 .
 END OF TERMS AND CONDITIONS
 .
 APPENDIX: How to apply the Apache License to your work.
 .
	To apply the Apache License to your work, attach the following
	boilerplate notice, with the fields enclosed by brackets \"[]\"
	replaced with your own identifying information. (Don't include
	the brackets!)  The text should be enclosed in the appropriate
	comment syntax for the file format. We also recommend that a
	file or class name and description of purpose be included on the
	same \"printed page\" as the copyright notice for easier
	identification within third-party archives.
 .
 Copyright [yyyy] [name of copyright owner]
 .
 Licensed under the Apache License, Version 2.0 (the \"License\");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 .
	 http://www.apache.org/licenses/LICENSE-2.0
 .
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an \"AS IS\" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

License: BSD-2-clause
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 .
 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 .
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 .
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

License: BSD-3-clause
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 .
 1. Redistributions of source code must retain the above copyright
	notice, this list of conditions and the following disclaimer.
 .
 2. Redistributions in binary form must reproduce the above copyright
	notice, this list of conditions and the following disclaimer in the
	documentation and/or other materials provided with the distribution.
 .
 3. Neither the name of the copyright holder nor the names of its
	contributors may be used to endorse or promote products derived from
	this software without specific prior written permission.
 .
 THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.

License: BSL-1.0
 Boost Software License - Version 1.0 - August 17th, 2003
 .
 Permission is hereby granted, free of charge, to any person or organization
 obtaining a copy of the software and accompanying documentation covered by
 this license (the \"Software\") to use, reproduce, display, distribute,
 execute, and transmit the Software, and to prepare derivative works of the
 Software, and to permit third-parties to whom the Software is furnished to
 do so, all subject to the following:
 .
 The copyright notices in the Software and this entire statement, including
 the above license grant, this restriction and the following disclaimer,
 must be included in all copies of the Software, in whole or in part, and
 all derivative works of the Software, unless such copies or derivative
 works are solely in the form of machine-executable object code generated by
 a source language processor.
 .
 THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
 SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
 FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
 ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 DEALINGS IN THE SOFTWARE.

License: CC0-1.0
 CC0 1.0 Universal
 .
 Statement of Purpose
 .
 The laws of most jurisdictions throughout the world automatically confer
 exclusive Copyright and Related Rights (defined below) upon the creator and
 subsequent owner(s) (each and all, an \"owner\") of an original work of
 authorship and/or a database (each, a \"Work\").
 .
 Certain owners wish to permanently relinquish those rights to a Work for the
 purpose of contributing to a commons of creative, cultural and scientific
 works (\"Commons\") that the public can reliably and without fear of later
 claims of infringement build upon, modify, incorporate in other works, reuse
 and redistribute as freely as possible in any form whatsoever and for any
 purposes, including without limitation commercial purposes. These owners may
 contribute to the Commons to promote the ideal of a free culture and the
 further production of creative, cultural and scientific works, or to gain
 reputation or greater distribution for their Work in part through the use and
 efforts of others.
 .
 For these and/or other purposes and motivations, and without any expectation
 of additional consideration or compensation, the person associating CC0 with a
 Work (the \"Affirmer\"), to the extent that he or she is an owner of Copyright
 and Related Rights in the Work, voluntarily elects to apply CC0 to the Work
 and publicly distribute the Work under its terms, with knowledge of his or her
 Copyright and Related Rights in the Work and the meaning and intended legal
 effect of CC0 on those rights.
 .
 1. Copyright and Related Rights. A Work made available under CC0 may be
 protected by copyright and related or neighboring rights (\"Copyright and
 Related Rights\"). Copyright and Related Rights include, but are not limited
 to, the following:
 .
 i. the right to reproduce, adapt, distribute, perform, display, communicate,
 and translate a Work;
 .
 ii. moral rights retained by the original author(s) and/or performer(s);
 .
 iii. publicity and privacy rights pertaining to a person's image or likeness
 depicted in a Work;
 .
 iv. rights protecting against unfair competition in regards to a Work,
 subject to the limitations in paragraph 4(a), below;
 .
 v. rights protecting the extraction, dissemination, use and reuse of data in
 a Work;
 .
 vi. database rights (such as those arising under Directive 96/9/EC of the
 European Parliament and of the Council of 11 March 1996 on the legal
 protection of databases, and under any national implementation thereof,
 including any amended or successor version of such directive); and
 .
 vii. other similar, equivalent or corresponding rights throughout the world
 based on applicable law or treaty, and any national implementations thereof.
 .
 2. Waiver. To the greatest extent permitted by, but not in contravention of,
 applicable law, Affirmer hereby overtly, fully, permanently, irrevocably and
 unconditionally waives, abandons, and surrenders all of Affirmer's Copyright
 and Related Rights and associated claims and causes of action, whether now
 known or unknown (including existing as well as future claims and causes of
 action), in the Work (i) in all territories worldwide, (ii) for the maximum
 duration provided by applicable law or treaty (including future time
 extensions), (iii) in any current or future medium and for any number of
 copies, and (iv) for any purpose whatsoever, including without limitation
 commercial, advertising or promotional purposes (the \"Waiver\"). Affirmer makes
 the Waiver for the benefit of each member of the public at large and to the
 detriment of Affirmer's heirs and successors, fully intending that such Waiver
 shall not be subject to revocation, rescission, cancellation, termination, or
 any other legal or equitable action to disrupt the quiet enjoyment of the Work
 by the public as contemplated by Affirmer's express Statement of Purpose.
 .
 3. Public License Fallback. Should any part of the Waiver for any reason be
 judged legally invalid or ineffective under applicable law, then the Waiver
 shall be preserved to the maximum extent permitted taking into account
 Affirmer's express Statement of Purpose. In addition, to the extent the Waiver
 is so judged Affirmer hereby grants to each affected person a royalty-free,
 non transferable, non sublicensable, non exclusive, irrevocable and
 unconditional license to exercise Affirmer's Copyright and Related Rights in
 the Work (i) in all territories worldwide, (ii) for the maximum duration
 provided by applicable law or treaty (including future time extensions), (iii)
 in any current or future medium and for any number of copies, and (iv) for any
 purpose whatsoever, including without limitation commercial, advertising or
 promotional purposes (the \"License\"). The License shall be deemed effective as
 of the date CC0 was applied by Affirmer to the Work. Should any part of the
 License for any reason be judged legally invalid or ineffective under
 applicable law, such partial invalidity or ineffectiveness shall not
 invalidate the remainder of the License, and in such case Affirmer hereby
 affirms that he or she will not (i) exercise any of his or her remaining
 Copyright and Related Rights in the Work or (ii) assert any associated claims
 and causes of action with respect to the Work, in either case contrary to
 Affirmer's express Statement of Purpose.
 .
 4. Limitations and Disclaimers.
 .
 a. No trademark or patent rights held by Affirmer are waived, abandoned,
 surrendered, licensed or otherwise affected by this document.
 .
 b. Affirmer offers the Work as-is and makes no representations or warranties
 of any kind concerning the Work, express, implied, statutory or otherwise,
 including without limitation warranties of title, merchantability, fitness
 for a particular purpose, non infringement, or the absence of latent or
 other defects, accuracy, or the present or absence of errors, whether or not
 discoverable, all to the greatest extent permissible under applicable law.
 .
 c. Affirmer disclaims responsibility for clearing rights of other persons
 that may apply to the Work or any use thereof, including without limitation
 any person's Copyright and Related Rights in the Work. Further, Affirmer
 disclaims responsibility for obtaining any necessary consents, permissions
 or other rights required for any use of the Work.
 .
 d. Affirmer understands and acknowledges that Creative Commons is not a
 party to this document and has no duty or obligation with respect to this
 CC0 or use of the Work.

License: CC-BY-4.0
 Creative Commons Attribution 4.0 International Public License
 .
 By exercising the Licensed Rights (defined below), You accept and agree
 to be bound by the terms and conditions of this Creative Commons
 Attribution 4.0 International Public License (\"Public
 License\"). To the extent this Public License may be interpreted as a
 contract, You are granted the Licensed Rights in consideration of Your
 acceptance of these terms and conditions, and the Licensor grants You
 such rights in consideration of benefits the Licensor receives from
 making the Licensed Material available under these terms and
 conditions.
 .
 Section 1 -- Definitions.
 .
 a. Adapted Material means material subject to Copyright and Similar
 Rights that is derived from or based upon the Licensed Material
 and in which the Licensed Material is translated, altered,
 arranged, transformed, or otherwise modified in a manner requiring
 permission under the Copyright and Similar Rights held by the
 Licensor. For purposes of this Public License, where the Licensed
 Material is a musical work, performance, or sound recording,
 Adapted Material is always produced where the Licensed Material is
 synched in timed relation with a moving image.
 .
 b. Adapter's License means the license You apply to Your Copyright
 and Similar Rights in Your contributions to Adapted Material in
 accordance with the terms and conditions of this Public License.
 .
 c. Copyright and Similar Rights means copyright and/or similar rights
 closely related to copyright including, without limitation,
 performance, broadcast, sound recording, and Sui Generis Database
 Rights, without regard to how the rights are labeled or
 categorized. For purposes of this Public License, the rights
 specified in Section 2(b)(1)-(2) are not Copyright and Similar
 Rights.
 .
 d. Effective Technological Measures means those measures that, in the
 absence of proper authority, may not be circumvented under laws
 fulfilling obligations under Article 11 of the WIPO Copyright
 Treaty adopted on December 20, 1996, and/or similar international
 agreements.
 .
 e. Exceptions and Limitations means fair use, fair dealing, and/or
 any other exception or limitation to Copyright and Similar Rights
 that applies to Your use of the Licensed Material.
 .
 f. Licensed Material means the artistic or literary work, database,
 or other material to which the Licensor applied this Public
 License.
 .
 g. Licensed Rights means the rights granted to You subject to the
 terms and conditions of this Public License, which are limited to
 all Copyright and Similar Rights that apply to Your use of the
 Licensed Material and that the Licensor has authority to license.
 .
 h. Licensor means the individual(s) or entity(ies) granting rights
 under this Public License.
 .
 i. Share means to provide material to the public by any means or
 process that requires permission under the Licensed Rights, such
 as reproduction, public display, public performance, distribution,
 dissemination, communication, or importation, and to make material
 available to the public including in ways that members of the
 public may access the material from a place and at a time
 individually chosen by them.
 .
 j. Sui Generis Database Rights means rights other than copyright
 resulting from Directive 96/9/EC of the European Parliament and of
 the Council of 11 March 1996 on the legal protection of databases,
 as amended and/or succeeded, as well as other essentially
 equivalent rights anywhere in the world.
 .
 k. You means the individual or entity exercising the Licensed Rights
 under this Public License. Your has a corresponding meaning.
 .
 Section 2 -- Scope.
 .
 a. License grant.
 .
 1. Subject to the terms and conditions of this Public License,
 the Licensor hereby grants You a worldwide, royalty-free,
 non-sublicensable, non-exclusive, irrevocable license to
 exercise the Licensed Rights in the Licensed Material to:
 .
 a. reproduce and Share the Licensed Material, in whole or
 in part; and
 .
 b. produce, reproduce, and Share Adapted Material.
 .
 2. Exceptions and Limitations. For the avoidance of doubt, where
 Exceptions and Limitations apply to Your use, this Public
 License does not apply, and You do not need to comply with
 its terms and conditions.
 .
 3. Term. The term of this Public License is specified in Section
 6(a).
 .
 4. Media and formats; technical modifications allowed. The
 Licensor authorizes You to exercise the Licensed Rights in
 all media and formats whether now known or hereafter created,
 and to make technical modifications necessary to do so. The
 Licensor waives and/or agrees not to assert any right or
 authority to forbid You from making technical modifications
 necessary to exercise the Licensed Rights, including
 technical modifications necessary to circumvent Effective
 Technological Measures. For purposes of this Public License,
 simply making modifications authorized by this Section 2(a)
 (4) never produces Adapted Material.
 .
 5. Downstream recipients.
 .
 a. Offer from the Licensor -- Licensed Material. Every
 recipient of the Licensed Material automatically
 receives an offer from the Licensor to exercise the
 Licensed Rights under the terms and conditions of this
 Public License.
 .
 b. No downstream restrictions. You may not offer or impose
 any additional or different terms or conditions on, or
 apply any Effective Technological Measures to, the
 Licensed Material if doing so restricts exercise of the
 Licensed Rights by any recipient of the Licensed
 Material.
 .
 6. No endorsement. Nothing in this Public License constitutes or
 may be construed as permission to assert or imply that You
 are, or that Your use of the Licensed Material is, connected
 with, or sponsored, endorsed, or granted official status by,
 the Licensor or others designated to receive attribution as
 provided in Section 3(a)(1)(A)(i).
 .
 b. Other rights.
 .
 1. Moral rights, such as the right of integrity, are not
 licensed under this Public License, nor are publicity,
 privacy, and/or other similar personality rights; however, to
 the extent possible, the Licensor waives and/or agrees not to
 assert any such rights held by the Licensor to the limited
 extent necessary to allow You to exercise the Licensed
 Rights, but not otherwise.
 .
 2. Patent and trademark rights are not licensed under this
 Public License.
 .
 3. To the extent possible, the Licensor waives any right to
 collect royalties from You for the exercise of the Licensed
 Rights, whether directly or through a collecting society
 under any voluntary or waivable statutory or compulsory
 licensing scheme. In all other cases the Licensor expressly
 reserves any right to collect such royalties.
 .
 Section 3 -- License Conditions.
 .
 Your exercise of the Licensed Rights is expressly made subject to the
 following conditions.
 .
 a. Attribution.
 .
 1. If You Share the Licensed Material (including in modified
 form), You must:
 .
 a. retain the following if it is supplied by the Licensor
 with the Licensed Material:
 .
 i. identification of the creator(s) of the Licensed
 Material and any others designated to receive
 attribution, in any reasonable manner requested by
 the Licensor (including by pseudonym if
 designated);
 .
 ii. a copyright notice;
 .
 iii. a notice that refers to this Public License;
 .
 iv. a notice that refers to the disclaimer of
 warranties;
 .
 v. a URI or hyperlink to the Licensed Material to the
 extent reasonably practicable;
 .
 b. indicate if You modified the Licensed Material and
 retain an indication of any previous modifications; and
 .
 c. indicate the Licensed Material is licensed under this
 Public License, and include the text of, or the URI or
 hyperlink to, this Public License.
 .
 2. You may satisfy the conditions in Section 3(a)(1) in any
 reasonable manner based on the medium, means, and context in
 which You Share the Licensed Material. For example, it may be
 reasonable to satisfy the conditions by providing a URI or
 hyperlink to a resource that includes the required
 information.
 .
 3. If requested by the Licensor, You must remove any of the
 information required by Section 3(a)(1)(A) to the extent
 reasonably practicable.
 .
 4. If You Share Adapted Material You produce, the Adapter's
 License You apply must not prevent recipients of the Adapted
 Material from complying with this Public License.
 .
 Section 4 -- Sui Generis Database Rights.
 .
 Where the Licensed Rights include Sui Generis Database Rights that
 apply to Your use of the Licensed Material:
 .
 a. for the avoidance of doubt, Section 2(a)(1) grants You the right
 to extract, reuse, reproduce, and Share all or a substantial
 portion of the contents of the database;
 .
 b. if You include all or a substantial portion of the database
 contents in a database in which You have Sui Generis Database
 Rights, then the database in which You have Sui Generis Database
 Rights (but not its individual contents) is Adapted Material; and
 .
 c. You must comply with the conditions in Section 3(a) if You Share
 all or a substantial portion of the contents of the database.
 .
 For the avoidance of doubt, this Section 4 supplements and does not
 replace Your obligations under this Public License where the Licensed
 Rights include other Copyright and Similar Rights.
 .
 Section 5 -- Disclaimer of Warranties and Limitation of Liability.
 .
 a. UNLESS OTHERWISE SEPARATELY UNDERTAKEN BY THE LICENSOR, TO THE
 EXTENT POSSIBLE, THE LICENSOR OFFERS THE LICENSED MATERIAL AS-IS
 AND AS-AVAILABLE, AND MAKES NO REPRESENTATIONS OR WARRANTIES OF
 ANY KIND CONCERNING THE LICENSED MATERIAL, WHETHER EXPRESS,
 IMPLIED, STATUTORY, OR OTHER. THIS INCLUDES, WITHOUT LIMITATION,
 WARRANTIES OF TITLE, MERCHANTABILITY, FITNESS FOR A PARTICULAR
 PURPOSE, NON-INFRINGEMENT, ABSENCE OF LATENT OR OTHER DEFECTS,
 ACCURACY, OR THE PRESENCE OR ABSENCE OF ERRORS, WHETHER OR NOT
 KNOWN OR DISCOVERABLE. WHERE DISCLAIMERS OF WARRANTIES ARE NOT
 ALLOWED IN FULL OR IN PART, THIS DISCLAIMER MAY NOT APPLY TO YOU.
 .
 b. TO THE EXTENT POSSIBLE, IN NO EVENT WILL THE LICENSOR BE LIABLE
 TO YOU ON ANY LEGAL THEORY (INCLUDING, WITHOUT LIMITATION,
 NEGLIGENCE) OR OTHERWISE FOR ANY DIRECT, SPECIAL, INDIRECT,
 INCIDENTAL, CONSEQUENTIAL, PUNITIVE, EXEMPLARY, OR OTHER LOSSES,
 COSTS, EXPENSES, OR DAMAGES ARISING OUT OF THIS PUBLIC LICENSE OR
 USE OF THE LICENSED MATERIAL, EVEN IF THE LICENSOR HAS BEEN
 ADVISED OF THE POSSIBILITY OF SUCH LOSSES, COSTS, EXPENSES, OR
 DAMAGES. WHERE A LIMITATION OF LIABILITY IS NOT ALLOWED IN FULL OR
 IN PART, THIS LIMITATION MAY NOT APPLY TO YOU.
 .
 c. The disclaimer of warranties and limitation of liability provided
 above shall be interpreted in a manner that, to the extent
 possible, most closely approximates an absolute disclaimer and
 waiver of all liability.
 .
 Section 6 -- Term and Termination.
 .
 a. This Public License applies for the term of the Copyright and
 Similar Rights licensed here. However, if You fail to comply with
 this Public License, then Your rights under this Public License
 terminate automatically.
 .
 b. Where Your right to use the Licensed Material has terminated under
 Section 6(a), it reinstates:
 .
 1. automatically as of the date the violation is cured, provided
 it is cured within 30 days of Your discovery of the
 violation; or
 .
 2. upon express reinstatement by the Licensor.
 .
 For the avoidance of doubt, this Section 6(b) does not affect any
 right the Licensor may have to seek remedies for Your violations
 of this Public License.
 .
 c. For the avoidance of doubt, the Licensor may also offer the
 Licensed Material under separate terms or conditions or stop
 distributing the Licensed Material at any time; however, doing so
 will not terminate this Public License.
 .
 d. Sections 1, 5, 6, 7, and 8 survive termination of this Public
 License.
 .
 Section 7 -- Other Terms and Conditions.
 .
 a. The Licensor shall not be bound by any additional or different
 terms or conditions communicated by You unless expressly agreed.
 .
 b. Any arrangements, understandings, or agreements regarding the
 Licensed Material not stated herein are separate from and
 independent of the terms and conditions of this Public License.
 .
 Section 8 -- Interpretation.
 .
 a. For the avoidance of doubt, this Public License does not, and
 shall not be interpreted to, reduce, limit, restrict, or impose
 conditions on any use of the Licensed Material that could lawfully
 be made without permission under this Public License.
 .
 b. To the extent possible, if any provision of this Public License is
 deemed unenforceable, it shall be automatically reformed to the
 minimum extent necessary to make it enforceable. If the provision
 cannot be reformed, it shall be severed from this Public License
 without affecting the enforceability of the remaining terms and
 conditions.
 .
 c. No term or condition of this Public License will be waived and no
 failure to comply consented to unless expressly agreed to by the
 Licensor.
 .
 d. Nothing in this Public License constitutes or may be interpreted
 as a limitation upon, or waiver of, any privileges and immunities
 that apply to the Licensor or You, including from the legal
 processes of any jurisdiction or authority.

License: Expat
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 \"Software\"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 .
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 .
 THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

License: glslang
 Here, glslang proper means core GLSL parsing, HLSL parsing, and SPIR-V code
 generation. Glslang proper requires use of a number of licenses, one that covers
 preprocessing and others that covers non-preprocessing.
 .
 Bison was removed long ago. You can build glslang from the source grammar,
 using tools of your choice, without using bison or any bison files.
 .
 Other parts, outside of glslang proper, include:
 .
 - gl_types.h, only needed for OpenGL-like reflection, and can be left out of
   a parse and codegen project.  See it for its license.
 .
 - update_glslang_sources.py, which is not part of the project proper and does
   not need to be used.
 .
 - the SPIR-V \"remapper\", which is optional, but has the same license as
   glslang proper
 .
 - Google tests and SPIR-V tools, and anything in the external subdirectory
   are external and optional; see them for their respective licenses.
 .
 --------------------------------------------------------------------------------
 .
 The core of glslang-proper, minus the preprocessor is licenced as follows:
 .
 --------------------------------------------------------------------------------
 3-Clause BSD License
 --------------------------------------------------------------------------------
 .
 Copyright (C) 2015-2018 Google, Inc.
 Copyright (C) <various other dates and companies>
 .
 All rights reserved.
 .
 See: <License: BSD-3-clause>.
 .
 --------------------------------------------------------------------------------
 2-Clause BSD License
 --------------------------------------------------------------------------------
 .
 Copyright 2020 The Khronos Group Inc
 .
 See: <License: BSD-2-clause>.
 .
 --------------------------------------------------------------------------------
 The MIT License
 --------------------------------------------------------------------------------
 .
 Copyright 2020 The Khronos Group Inc
 .
 See: <License: Expat>.
 .
 --------------------------------------------------------------------------------
 APACHE LICENSE, VERSION 2.0
 --------------------------------------------------------------------------------
 .
 See: <License: Apache-2.0>.
 .
 --------------------------------------------------------------------------------
 GPL 3 with special bison exception
 --------------------------------------------------------------------------------
 .
 Bison implementation for Yacc-like parsers in C
 .
 Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.
 .
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 .
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 .
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.
 .
 As a special exception, you may create a larger work that contains
 part or all of the Bison parser skeleton and distribute that work
 under terms of your choice, so long as that work isn't itself a
 parser generator using the skeleton or a modified version thereof
 as a parser skeleton.  Alternatively, if you modify or redistribute
 the parser skeleton itself, you may (at your option) remove this
 special exception, which will cause the skeleton and the resulting
 Bison output files to be licensed under the GNU General Public
 License without this special exception.
 .
 This special exception was added by the Free Software Foundation in
 version 2.2 of Bison.
 .
 --------------------------------------------------------------------------------
 ================================================================================
 --------------------------------------------------------------------------------
 .
 The preprocessor has the core licenses stated above, plus an additional licence:
 .
 Copyright (c) 2002, NVIDIA Corporation.
 .
 NVIDIA Corporation(\"NVIDIA\") supplies this software to you in
 consideration of your agreement to the following terms, and your use,
 installation, modification or redistribution of this NVIDIA software
 constitutes acceptance of these terms.  If you do not agree with these
 terms, please do not use, install, modify or redistribute this NVIDIA
 software.
 .
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, NVIDIA grants you a personal, non-exclusive
 license, under NVIDIA's copyrights in this original NVIDIA software (the
 \"NVIDIA Software\"), to use, reproduce, modify and redistribute the
 NVIDIA Software, with or without modifications, in source and/or binary
 forms; provided that if you redistribute the NVIDIA Software, you must
 retain the copyright notice of NVIDIA, this notice and the following
 text and disclaimers in all such redistributions of the NVIDIA Software.
 Neither the name, trademarks, service marks nor logos of NVIDIA
 Corporation may be used to endorse or promote products derived from the
 NVIDIA Software without specific prior written permission from NVIDIA.
 Except as expressly stated in this notice, no other rights or licenses
 express or implied, are granted by NVIDIA herein, including but not
 limited to any patent rights that may be infringed by your derivative
 works or by other works in which the NVIDIA Software may be
 incorporated. No hardware is licensed hereunder.
 .
 THE NVIDIA SOFTWARE IS BEING PROVIDED ON AN \"AS IS\" BASIS, WITHOUT
 WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED,
 INCLUDING WITHOUT LIMITATION, WARRANTIES OR CONDITIONS OF TITLE,
 NON-INFRINGEMENT, MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
 ITS USE AND OPERATION EITHER ALONE OR IN COMBINATION WITH OTHER
 PRODUCTS.
 .
 IN NO EVENT SHALL NVIDIA BE LIABLE FOR ANY SPECIAL, INDIRECT,
 INCIDENTAL, EXEMPLARY, CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, LOST PROFITS; PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) OR ARISING IN ANY WAY
 OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE
 NVIDIA SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT,
 TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 NVIDIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

License: FTL
					The FreeType Project LICENSE
					----------------------------
 .
							2000-Feb-08
 .
					   Copyright 1996-2000 by
		  David Turner, Robert Wilhelm, and Werner Lemberg
 .
 .
 .
 Introduction
 ============
 .
 The FreeType  Project is distributed in  several archive packages;
 some of them may contain, in addition to the FreeType font engine,
 various tools and  contributions which rely on, or  relate to, the
 FreeType Project.
 .
 This  license applies  to all  files found  in such  packages, and
 which do not  fall under their own explicit  license.  The license
 affects  thus  the  FreeType   font  engine,  the  test  programs,
 documentation and makefiles, at the very least.
 .
 This  license   was  inspired  by  the  BSD,   Artistic,  and  IJG
 (Independent JPEG  Group) licenses, which  all encourage inclusion
 and  use of  free  software in  commercial  and freeware  products
 alike.  As a consequence, its main points are that:
 .
   o We don't promise that this software works. However, we will be
	 interested in any kind of bug reports. (`as is' distribution)
 .
   o You can  use this software for whatever you  want, in parts or
	 full form, without having to pay us. (`royalty-free' usage)
 .
   o You may not pretend that  you wrote this software.  If you use
	 it, or  only parts of it,  in a program,  you must acknowledge
	 somewhere  in  your  documentation  that  you  have  used  the
	 FreeType code. (`credits')
 .
 We  specifically  permit  and  encourage  the  inclusion  of  this
 software, with  or without modifications,  in commercial products.
 We  disclaim  all warranties  covering  The  FreeType Project  and
 assume no liability related to The FreeType Project.
 .
 .
 Legal Terms
 ===========
 .
 0. Definitions
 --------------
 .
 Throughout this license,  the terms `package', `FreeType Project',
 and  `FreeType  archive' refer  to  the  set  of files  originally
 distributed  by the  authors  (David Turner,  Robert Wilhelm,  and
 Werner Lemberg) as the `FreeType Project', be they named as alpha,
 beta or final release.
 .
 `You' refers to  the licensee, or person using  the project, where
 `using' is a generic term including compiling the project's source
 code as  well as linking it  to form a  `program' or `executable'.
 This  program is  referred to  as  `a program  using the  FreeType
 engine'.
 .
 This  license applies  to all  files distributed  in  the original
 FreeType  Project,   including  all  source   code,  binaries  and
 documentation,  unless  otherwise  stated   in  the  file  in  its
 original, unmodified form as  distributed in the original archive.
 If you are  unsure whether or not a particular  file is covered by
 this license, you must contact us to verify this.
 .
 The FreeType  Project is copyright (C) 1996-2000  by David Turner,
 Robert Wilhelm, and Werner Lemberg.  All rights reserved except as
 specified below.
 .
 1. No Warranty
 --------------
 .
 THE FREETYPE PROJECT  IS PROVIDED `AS IS' WITHOUT  WARRANTY OF ANY
 KIND, EITHER  EXPRESS OR IMPLIED,  INCLUDING, BUT NOT  LIMITED TO,
 WARRANTIES  OF  MERCHANTABILITY   AND  FITNESS  FOR  A  PARTICULAR
 PURPOSE.  IN NO EVENT WILL ANY OF THE AUTHORS OR COPYRIGHT HOLDERS
 BE LIABLE  FOR ANY DAMAGES CAUSED  BY THE USE OR  THE INABILITY TO
 USE, OF THE FREETYPE PROJECT.
 .
 2. Redistribution
 -----------------
 .
 This  license  grants  a  worldwide, royalty-free,  perpetual  and
 irrevocable right  and license to use,  execute, perform, compile,
 display,  copy,   create  derivative  works   of,  distribute  and
 sublicense the  FreeType Project (in  both source and  object code
 forms)  and  derivative works  thereof  for  any  purpose; and  to
 authorize others  to exercise  some or all  of the  rights granted
 herein, subject to the following conditions:
 .
   o Redistribution  of source code  must retain this  license file
	 (`LICENSE.TXT') unaltered; any additions, deletions or changes
	 to   the  original   files  must   be  clearly   indicated  in
	 accompanying  documentation.   The  copyright notices  of  the
	 unaltered, original  files must be preserved in  all copies of
	 source files.
 .
   o Redistribution in binary form must provide a  disclaimer  that
	 states  that  the software is based in part of the work of the
	 FreeType Team,  in  the  distribution  documentation.  We also
	 encourage you to put an URL to the FreeType web page  in  your
	 documentation, though this isn't mandatory.
 .
 These conditions  apply to any  software derived from or  based on
 the FreeType Project,  not just the unmodified files.   If you use
 our work, you  must acknowledge us.  However, no  fee need be paid
 to us.
 .
 3. Advertising
 --------------
 .
 Neither the  FreeType authors and  contributors nor you  shall use
 the name of the  other for commercial, advertising, or promotional
 purposes without specific prior written permission.
 .
 We suggest,  but do not require, that  you use one or  more of the
 following phrases to refer  to this software in your documentation
 or advertising  materials: `FreeType Project',  `FreeType Engine',
 `FreeType library', or `FreeType Distribution'.
 .
 As  you have  not signed  this license,  you are  not  required to
 accept  it.   However,  as  the FreeType  Project  is  copyrighted
 material, only  this license, or  another one contracted  with the
 authors, grants you  the right to use, distribute,  and modify it.
 Therefore,  by  using,  distributing,  or modifying  the  FreeType
 Project, you indicate that you understand and accept all the terms
 of this license.
 .
 4. Contacts
 -----------
 .
 There are two mailing lists related to FreeType:
 .
   o freetype@freetype.org
 .
	 Discusses general use and applications of FreeType, as well as
	 future and  wanted additions to the  library and distribution.
	 If  you are looking  for support,  start in  this list  if you
	 haven't found anything to help you in the documentation.
 .
   o devel@freetype.org
 .
	 Discusses bugs,  as well  as engine internals,  design issues,
	 specific licenses, porting, etc.
 .
   o http://www.freetype.org
 .
	 Holds the current  FreeType web page, which will  allow you to
	 download  our  latest  development  version  and  read  online
	 documentation.
 .
 You can also contact us individually at:
 .
   David Turner      <david.turner@freetype.org>
   Robert Wilhelm    <robert.wilhelm@freetype.org>
   Werner Lemberg    <werner.lemberg@freetype.org>

License: HarfBuzz
 HarfBuzz is licensed under the so-called \"Old MIT\" license.  Details follow.
 For parts of HarfBuzz that are licensed under different licenses see individual
 files names COPYING in subdirectories where applicable.
 .
 Copyright (C) 2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020  Google, Inc.
 Copyright (C) 2018,2019,2020  Ebrahim Byagowi
 Copyright (C) 2019,2020  Facebook, Inc.
 Copyright (C) 2012  Mozilla Foundation
 Copyright (C) 2011  Codethink Limited
 Copyright (C) 2008,2010  Nokia Corporation and/or its subsidiary(-ies)
 Copyright (C) 2009  Keith Stribley
 Copyright (C) 2009  Martin Hosken and SIL International
 Copyright (C) 2007  Chris Wilson
 Copyright (C) 2005,2006,2020,2021  Behdad Esfahbod
 Copyright (C) 2005  David Turner
 Copyright (C) 2004,2007,2008,2009,2010  Red Hat, Inc.
 Copyright (C) 1998-2004  David Turner and Werner Lemberg
 .
 For full copyright notices consult the individual files in the package.
 .
 .
 Permission is hereby granted, without written agreement and without
 license or royalty fees, to use, copy, modify, and distribute this
 software and its documentation for any purpose, provided that the
 above copyright notice and the following two paragraphs appear in
 all copies of this software.
 .
 IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE TO ANY PARTY FOR
 DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 IF THE COPYRIGHT HOLDER HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 DAMAGE.
 .
 THE COPYRIGHT HOLDER SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING,
 BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 ON AN \"AS IS\" BASIS, AND THE COPYRIGHT HOLDER HAS NO OBLIGATION TO
 PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

License: MPL-2.0
 Mozilla Public License Version 2.0
 ==================================
 .
 1. Definitions
 --------------
 .
 1.1. \"Contributor\"
	 means each individual or legal entity that creates, contributes to
	 the creation of, or owns Covered Software.
 .
 1.2. \"Contributor Version\"
	 means the combination of the Contributions of others (if any) used
	 by a Contributor and that particular Contributor's Contribution.
 .
 1.3. \"Contribution\"
	 means Covered Software of a particular Contributor.
 .
 1.4. \"Covered Software\"
	 means Source Code Form to which the initial Contributor has attached
	 the notice in Exhibit A, the Executable Form of such Source Code
	 Form, and Modifications of such Source Code Form, in each case
	 including portions thereof.
 .
 1.5. \"Incompatible With Secondary Licenses\"
	 means
 .
	 (a) that the initial Contributor has attached the notice described
		 in Exhibit B to the Covered Software; or
 .
	 (b) that the Covered Software was made available under the terms of
		 version 1.1 or earlier of the License, but not also under the
		 terms of a Secondary License.
 .
 1.6. \"Executable Form\"
	 means any form of the work other than Source Code Form.
 .
 1.7. \"Larger Work\"
	 means a work that combines Covered Software with other material, in
	 a separate file or files, that is not Covered Software.
 .
 1.8. \"License\"
	 means this document.
 .
 1.9. \"Licensable\"
	 means having the right to grant, to the maximum extent possible,
	 whether at the time of the initial grant or subsequently, any and
	 all of the rights conveyed by this License.
 .
 1.10. \"Modifications\"
	 means any of the following:
 .
	 (a) any file in Source Code Form that results from an addition to,
		 deletion from, or modification of the contents of Covered
		 Software; or
 .
	 (b) any new file in Source Code Form that contains any Covered
		 Software.
 .
 1.11. \"Patent Claims\" of a Contributor
	 means any patent claim(s), including without limitation, method,
	 process, and apparatus claims, in any patent Licensable by such
	 Contributor that would be infringed, but for the grant of the
	 License, by the making, using, selling, offering for sale, having
	 made, import, or transfer of either its Contributions or its
	 Contributor Version.
 .
 1.12. \"Secondary License\"
	 means either the GNU General Public License, Version 2.0, the GNU
	 Lesser General Public License, Version 2.1, the GNU Affero General
	 Public License, Version 3.0, or any later versions of those
	 licenses.
 .
 1.13. \"Source Code Form\"
	 means the form of the work preferred for making modifications.
 .
 1.14. \"You\" (or \"Your\")
	 means an individual or a legal entity exercising rights under this
	 License. For legal entities, \"You\" includes any entity that
	 controls, is controlled by, or is under common control with You. For
	 purposes of this definition, \"control\" means (a) the power, direct
	 or indirect, to cause the direction or management of such entity,
	 whether by contract or otherwise, or (b) ownership of more than
	 fifty percent (50%) of the outstanding shares or beneficial
	 ownership of such entity.
 .
 2. License Grants and Conditions
 --------------------------------
 .
 2.1. Grants
 .
 Each Contributor hereby grants You a world-wide, royalty-free,
 non-exclusive license:
 .
 (a) under intellectual property rights (other than patent or trademark)
	 Licensable by such Contributor to use, reproduce, make available,
	 modify, display, perform, distribute, and otherwise exploit its
	 Contributions, either on an unmodified basis, with Modifications, or
	 as part of a Larger Work; and
 .
 (b) under Patent Claims of such Contributor to make, use, sell, offer
	 for sale, have made, import, and otherwise transfer either its
	 Contributions or its Contributor Version.
 .
 2.2. Effective Date
 .
 The licenses granted in Section 2.1 with respect to any Contribution
 become effective for each Contribution on the date the Contributor first
 distributes such Contribution.
 .
 2.3. Limitations on Grant Scope
 .
 The licenses granted in this Section 2 are the only rights granted under
 this License. No additional rights or licenses will be implied from the
 distribution or licensing of Covered Software under this License.
 Notwithstanding Section 2.1(b) above, no patent license is granted by a
 Contributor:
 .
 (a) for any code that a Contributor has removed from Covered Software;
	 or
 .
 (b) for infringements caused by: (i) Your and any other third party's
	 modifications of Covered Software, or (ii) the combination of its
	 Contributions with other software (except as part of its Contributor
	 Version); or
 .
 (c) under Patent Claims infringed by Covered Software in the absence of
	 its Contributions.
 .
 This License does not grant any rights in the trademarks, service marks,
 or logos of any Contributor (except as may be necessary to comply with
 the notice requirements in Section 3.4).
 .
 2.4. Subsequent Licenses
 .
 No Contributor makes additional grants as a result of Your choice to
 distribute the Covered Software under a subsequent version of this
 License (see Section 10.2) or under the terms of a Secondary License (if
 permitted under the terms of Section 3.3).
 .
 2.5. Representation
 .
 Each Contributor represents that the Contributor believes its
 Contributions are its original creation(s) or it has sufficient rights
 to grant the rights to its Contributions conveyed by this License.
 .
 2.6. Fair Use
 .
 This License is not intended to limit any rights You have under
 applicable copyright doctrines of fair use, fair dealing, or other
 equivalents.
 .
 2.7. Conditions
 .
 Sections 3.1, 3.2, 3.3, and 3.4 are conditions of the licenses granted
 in Section 2.1.
 .
 3. Responsibilities
 -------------------
 .
 3.1. Distribution of Source Form
 .
 All distribution of Covered Software in Source Code Form, including any
 Modifications that You create or to which You contribute, must be under
 the terms of this License. You must inform recipients that the Source
 Code Form of the Covered Software is governed by the terms of this
 License, and how they can obtain a copy of this License. You may not
 attempt to alter or restrict the recipients' rights in the Source Code
 Form.
 .
 3.2. Distribution of Executable Form
 .
 If You distribute Covered Software in Executable Form then:
 .
 (a) such Covered Software must also be made available in Source Code
	 Form, as described in Section 3.1, and You must inform recipients of
	 the Executable Form how they can obtain a copy of such Source Code
	 Form by reasonable means in a timely manner, at a charge no more
	 than the cost of distribution to the recipient; and
 .
 (b) You may distribute such Executable Form under the terms of this
	 License, or sublicense it under different terms, provided that the
	 license for the Executable Form does not attempt to limit or alter
	 the recipients' rights in the Source Code Form under this License.
 .
 3.3. Distribution of a Larger Work
 .
 You may create and distribute a Larger Work under terms of Your choice,
 provided that You also comply with the requirements of this License for
 the Covered Software. If the Larger Work is a combination of Covered
 Software with a work governed by one or more Secondary Licenses, and the
 Covered Software is not Incompatible With Secondary Licenses, this
 License permits You to additionally distribute such Covered Software
 under the terms of such Secondary License(s), so that the recipient of
 the Larger Work may, at their option, further distribute the Covered
 Software under the terms of either this License or such Secondary
 License(s).
 .
 3.4. Notices
 .
 You may not remove or alter the substance of any license notices
 (including copyright notices, patent notices, disclaimers of warranty,
 or limitations of liability) contained within the Source Code Form of
 the Covered Software, except that You may alter any license notices to
 the extent required to remedy known factual inaccuracies.
 .
 3.5. Application of Additional Terms
 .
 You may choose to offer, and to charge a fee for, warranty, support,
 indemnity or liability obligations to one or more recipients of Covered
 Software. However, You may do so only on Your own behalf, and not on
 behalf of any Contributor. You must make it absolutely clear that any
 such warranty, support, indemnity, or liability obligation is offered by
 You alone, and You hereby agree to indemnify every Contributor for any
 liability incurred by such Contributor as a result of warranty, support,
 indemnity or liability terms You offer. You may include additional
 disclaimers of warranty and limitations of liability specific to any
 jurisdiction.
 .
 4. Inability to Comply Due to Statute or Regulation
 ---------------------------------------------------
 .
 If it is impossible for You to comply with any of the terms of this
 License with respect to some or all of the Covered Software due to
 statute, judicial order, or regulation then You must: (a) comply with
 the terms of this License to the maximum extent possible; and (b)
 describe the limitations and the code they affect. Such description must
 be placed in a text file included with all distributions of the Covered
 Software under this License. Except to the extent prohibited by statute
 or regulation, such description must be sufficiently detailed for a
 recipient of ordinary skill to be able to understand it.
 .
 5. Termination
 --------------
 .
 5.1. The rights granted under this License will terminate automatically
 if You fail to comply with any of its terms. However, if You become
 compliant, then the rights granted under this License from a particular
 Contributor are reinstated (a) provisionally, unless and until such
 Contributor explicitly and finally terminates Your grants, and (b) on an
 ongoing basis, if such Contributor fails to notify You of the
 non-compliance by some reasonable means prior to 60 days after You have
 come back into compliance. Moreover, Your grants from a particular
 Contributor are reinstated on an ongoing basis if such Contributor
 notifies You of the non-compliance by some reasonable means, this is the
 first time You have received notice of non-compliance with this License
 from such Contributor, and You become compliant prior to 30 days after
 Your receipt of the notice.
 .
 5.2. If You initiate litigation against any entity by asserting a patent
 infringement claim (excluding declaratory judgment actions,
 counter-claims, and cross-claims) alleging that a Contributor Version
 directly or indirectly infringes any patent, then the rights granted to
 You by any and all Contributors for the Covered Software under Section
 2.1 of this License shall terminate.
 .
 5.3. In the event of termination under Sections 5.1 or 5.2 above, all
 end user license agreements (excluding distributors and resellers) which
 have been validly granted by You or Your distributors under this License
 prior to termination shall survive termination.
 .
 ************************************************************************
 *                                                                      *
 *  6. Disclaimer of Warranty                                           *
 *  -------------------------                                           *
 *                                                                      *
 *  Covered Software is provided under this License on an \"as is\"       *
 *  basis, without warranty of any kind, either expressed, implied, or  *
 *  statutory, including, without limitation, warranties that the       *
 *  Covered Software is free of defects, merchantable, fit for a        *
 *  particular purpose or non-infringing. The entire risk as to the     *
 *  quality and performance of the Covered Software is with You.        *
 *  Should any Covered Software prove defective in any respect, You     *
 *  (not any Contributor) assume the cost of any necessary servicing,   *
 *  repair, or correction. This disclaimer of warranty constitutes an   *
 *  essential part of this License. No use of any Covered Software is   *
 *  authorized under this License except under this disclaimer.         *
 *                                                                      *
 ************************************************************************
 .
 ************************************************************************
 *                                                                      *
 *  7. Limitation of Liability                                          *
 *  --------------------------                                          *
 *                                                                      *
 *  Under no circumstances and under no legal theory, whether tort      *
 *  (including negligence), contract, or otherwise, shall any           *
 *  Contributor, or anyone who distributes Covered Software as          *
 *  permitted above, be liable to You for any direct, indirect,         *
 *  special, incidental, or consequential damages of any character      *
 *  including, without limitation, damages for lost profits, loss of    *
 *  goodwill, work stoppage, computer failure or malfunction, or any    *
 *  and all other commercial damages or losses, even if such party      *
 *  shall have been informed of the possibility of such damages. This   *
 *  limitation of liability shall not apply to liability for death or   *
 *  personal injury resulting from such party's negligence to the       *
 *  extent applicable law prohibits such limitation. Some               *
 *  jurisdictions do not allow the exclusion or limitation of           *
 *  incidental or consequential damages, so this exclusion and          *
 *  limitation may not apply to You.                                    *
 *                                                                      *
 ************************************************************************
 .
 8. Litigation
 -------------
 .
 Any litigation relating to this License may be brought only in the
 courts of a jurisdiction where the defendant maintains its principal
 place of business and such litigation shall be governed by laws of that
 jurisdiction, without reference to its conflict-of-law provisions.
 Nothing in this Section shall prevent a party's ability to bring
 cross-claims or counter-claims.
 .
 9. Miscellaneous
 ----------------
 .
 This License represents the complete agreement concerning the subject
 matter hereof. If any provision of this License is held to be
 unenforceable, such provision shall be reformed only to the extent
 necessary to make it enforceable. Any law or regulation which provides
 that the language of a contract shall be construed against the drafter
 shall not be used to construe this License against a Contributor.
 .
 10. Versions of the License
 ---------------------------
 .
 10.1. New Versions
 .
 Mozilla Foundation is the license steward. Except as provided in Section
 10.3, no one other than the license steward has the right to modify or
 publish new versions of this License. Each version will be given a
 distinguishing version number.
 .
 10.2. Effect of New Versions
 .
 You may distribute the Covered Software under the terms of the version
 of the License under which You originally received the Covered Software,
 or under the terms of any subsequent version published by the license
 steward.
 .
 10.3. Modified Versions
 .
 If you create software not governed by this License, and you want to
 create a new license for such software, you may create and use a
 modified version of this License if you rename the license and remove
 any references to the name of the license steward (except to note that
 such modified license differs from this License).
 .
 10.4. Distributing Source Code Form that is Incompatible With Secondary
 Licenses
 .
 If You choose to distribute Source Code Form that is Incompatible With
 Secondary Licenses under the terms of this version of the License, the
 notice described in Exhibit B of this License must be attached.
 .
 Exhibit A - Source Code Form License Notice
 -------------------------------------------
 .
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at https://mozilla.org/MPL/2.0/.
 .
 If it is not possible or desirable to put the notice in a particular
 file, then You may include the notice in a location (such as a LICENSE
 file in a relevant directory) where a recipient would be likely to look
 for such a notice.
 .
 You may add additional accurate notices of copyright ownership.
 .
 Exhibit B - \"Incompatible With Secondary Licenses\" Notice
 ---------------------------------------------------------
 .
   This Source Code Form is \"Incompatible With Secondary Licenses\", as
   defined by the Mozilla Public License, v. 2.0.

License: OFL-1.1
 PREAMBLE
 The goals of the Open Font License (OFL) are to stimulate worldwide
 development of collaborative font projects, to support the font creation
 efforts of academic and linguistic communities, and to provide a free and
 open framework in which fonts may be shared and improved in partnership
 with others.
 .
 The OFL allows the licensed fonts to be used, studied, modified and
 redistributed freely as long as they are not sold by themselves. The
 fonts, including any derivative works, can be bundled, embedded,
 redistributed and/or sold with any software provided that any reserved
 names are not used by derivative works. The fonts and derivatives,
 however, cannot be released under any other type of license. The
 requirement for fonts to remain under this license does not apply
 to any document created using the fonts or their derivatives.
 .
 DEFINITIONS
 \"Font Software\" refers to the set of files released by the Copyright
 Holder(s) under this license and clearly marked as such. This may
 include source files, build scripts and documentation.
 .
 \"Reserved Font Name\" refers to any names specified as such after the
 copyright statement(s).
 .
 \"Original Version\" refers to the collection of Font Software components as
 distributed by the Copyright Holder(s).
 .
 \"Modified Version\" refers to any derivative made by adding to, deleting,
 or substituting -- in part or in whole -- any of the components of the
 Original Version, by changing formats or by porting the Font Software to a
 new environment.
 .
 \"Author\" refers to any designer, engineer, programmer, technical
 writer or other person who contributed to the Font Software.
 .
 PERMISSION & CONDITIONS
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of the Font Software, to use, study, copy, merge, embed, modify,
 redistribute, and sell modified and unmodified copies of the Font
 Software, subject to the following conditions:
 .
 1) Neither the Font Software nor any of its individual components,
 in Original or Modified Versions, may be sold by itself.
 .
 2) Original or Modified Versions of the Font Software may be bundled,
 redistributed and/or sold with any software, provided that each copy
 contains the above copyright notice and this license. These can be
 included either as stand-alone text files, human-readable headers or
 in the appropriate machine-readable metadata fields within text or
 binary files as long as those fields can be easily viewed by the user.
 .
 3) No Modified Version of the Font Software may use the Reserved Font
 Name(s) unless explicit written permission is granted by the corresponding
 Copyright Holder. This restriction only applies to the primary font name as
 presented to the users.
 .
 4) The name(s) of the Copyright Holder(s) or the Author(s) of the Font
 Software shall not be used to promote, endorse or advertise any
 Modified Version, except to acknowledge the contribution(s) of the
 Copyright Holder(s) and the Author(s) or with their explicit written
 permission.
 .
 5) The Font Software, modified or unmodified, in part or in whole,
 must be distributed entirely under this license, and must not be
 distributed under any other license. The requirement for fonts to
 remain under this license does not apply to any document created
 using the Font Software.
 .
 TERMINATION
 This license becomes null and void if any of the above conditions are
 not met.
 .
 DISCLAIMER
 THE FONT SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT
 OF COPYRIGHT, PATENT, TRADEMARK, OR OTHER RIGHT. IN NO EVENT SHALL THE
 COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 INCLUDING ANY GENERAL, SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL
 DAMAGES, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF THE USE OR INABILITY TO USE THE FONT SOFTWARE.

License: Unicode
 COPYRIGHT AND PERMISSION NOTICE (ICU 58 and later)
 .
 Copyright (C) 1991-2020 Unicode, Inc. All rights reserved.
 Distributed under the Terms of Use in https://www.unicode.org/copyright.html.
 .
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of the Unicode data files and any associated documentation
 (the \"Data Files\") or Unicode software and any associated documentation
 (the \"Software\") to deal in the Data Files or Software
 without restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, and/or sell copies of
 the Data Files or Software, and to permit persons to whom the Data Files
 or Software are furnished to do so, provided that either
 (a) this copyright and permission notice appear with all copies
 of the Data Files or Software, or
 (b) this copyright and permission notice appear in associated
 Documentation.
 .
 THE DATA FILES AND SOFTWARE ARE PROVIDED \"AS IS\", WITHOUT WARRANTY OF
 ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT OF THIRD PARTY RIGHTS.
 IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS INCLUDED IN THIS
 NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL
 DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
 DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
 TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 PERFORMANCE OF THE DATA FILES OR SOFTWARE.
 .
 Except as contained in this notice, the name of a copyright holder
 shall not be used in advertising or otherwise to promote the sale,
 use or other dealings in these Data Files or Software without prior
 written authorization of the copyright holder.

License: Unlicense
 This is free and unencumbered software released into the public domain.
 .
 Anyone is free to copy, modify, publish, use, compile, sell, or
 distribute this software, either in source code form or as a compiled
 binary, for any purpose, commercial or non-commercial, and by any
 means.
 .
 In jurisdictions that recognize copyright laws, the author or authors
 of this software dedicate any and all copyright interest in the
 software to the public domain. We make this dedication for the benefit
 of the public at large and to the detriment of our heirs and
 successors. We intend this dedication to be an overt act of
 relinquishment in perpetuity of all present and future rights to this
 software under copyright law.
 .
 THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 .
 For more information, please refer to <https://unlicense.org/>

License: Zlib
 This software is provided 'as-is', without any express or implied
 warranty.  In no event will the authors be held liable for any damages
 arising from the use of this software.
 .
 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:
 .
 1. The origin of this software must not be misrepresented; you must not
	claim that you wrote the original software. If you use this software
	in a product, an acknowledgment in the product documentation would be
	appreciated but is not required.
 2. Altered source versions must be plainly marked as such, and must not be
	misrepresented as being the original software.
 3. This notice may not be removed or altered from any source distribution.")