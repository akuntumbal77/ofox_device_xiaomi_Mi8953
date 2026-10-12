#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2021-2026 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#
# ----------------------------------------------------------------------------
# vendorsetup.sh - OrangeFox build vars untuk Xiaomi Mi8953 (MSM8953)
# Device serumpun: mido / vince / ysl (unified tree)
#
# Pola guard disalin dari device tree resmi OrangeFox device/vayu
# (branch fox_12.1). File ini di-source otomatis oleh build/envsetup.sh
# (source_vendorsetup) saat ". build/envsetup.sh" dijalankan.
#
# PENTING (wiki resmi OrangeFox): var yang prefix-nya FOX_ TIDAK BOLEH
# ditaruh di BoardConfig.mk / file .mk mana pun - harus di script ini
# atau di-export dari command line.
# ----------------------------------------------------------------------------
FDEVICE="Mi8953"

fox_get_target_device() {
  if echo "$BASH_SOURCE" | grep -q "/$FDEVICE/"; then
      FOX_BUILD_DEVICE="$FDEVICE";
  elif set | grep BASH_ARGV | grep -w \"$FDEVICE\"; then
      FOX_BUILD_DEVICE="$FDEVICE";
  elif echo "${BASH_SOURCE[0]}" | grep -q "/$FDEVICE/"; then
      FOX_BUILD_DEVICE="$FDEVICE";
  elif echo "$0" | grep -q "$FDEVICE"; then
      FOX_BUILD_DEVICE="$FDEVICE";
  fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then

	# ---- Identitas build ----
	# Nilai default saja: kalau sudah di-export dari luar (mis. input
	# workflow GitHub Actions / env shell lokal), nilai luar yang dipakai.
	export OF_MAINTAINER="${OF_MAINTAINER:-RenzAlt}"
	export FOX_BUILD_TYPE="${FOX_BUILD_TYPE:-Unofficial-CI}"

	# ---- Device-check zip installer OrangeFox ----
	# Installer zip cuma nge-assert TARGET_DEVICE (= "Mi8953", nama produk
	# tree ini) kalau gak ada alias. Padahal di recovery, ro.product.device
	# diisi codename ASLI (vince/mido/ysl) oleh set-device-props.sh, jadi
	# zip nolak flash. Daftarkan semua codename keluarga mi8953 di sini.
	export TARGET_DEVICE_ALT="mi8953,vince,mido,ysl"
	export FOX_TARGET_DEVICES="Mi8953,mi8953,vince,mido,ysl"

	# ---- Device Xiaomi A-only dengan MIUI: cegah recovery stok MIUI
	# menimpa OrangeFox saat boot ke ROM (Building Tip D resmi) ----
	export OF_PATCH_AVB20=1

	# ---- Dynamic partition RETROFIT (super menumpang di partisi fisik
	# lama cust+system, lihat BOARD_SUPER_PARTITION_* di BoardConfig.mk):
	# arahkan tooling OrangeFox ke logical partition ----
	export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
	export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"

	# Butuh PRODUCT_USE_DYNAMIC_PARTITIONS := true (sudah ada di device.mk)
	# supaya orangefox.mk tidak menolak flag ini. Otomatis menyalakan
	# OF_ENABLE_LPTOOLS juga.
	export OF_ENABLE_ALL_PARTITION_TOOLS=1

	# Kernel prebuilt (prebuilt/Image.gz-dtb, TARGET_KERNEL_VERSION 4.9) -
	# cegah error "NO KERNEL CONFIG" (Building Tip H resmi)
	export OF_FORCE_PREBUILT_KERNEL=1

	# ---- TODO (jangan ditebak): isi setelah versi keymaster ROM target
	# dipastikan. Device tree ini membawa binary keymaster@3.0, tapi nilai
	# yang salah bisa bikin decrypt gagal, jadi sengaja dikosongkan dulu.
	# (Building Tip J resmi: "strongly recommended to always do this")
	# export OF_DEFAULT_KEYMASTER_VERSION="3.0"

	if [ -n "$FOX_BUILD_LOG_FILE" ] && [ -f "$FOX_BUILD_LOG_FILE" ]; then
		export | grep "FOX" >> "$FOX_BUILD_LOG_FILE"
		export | grep "OF_" >> "$FOX_BUILD_LOG_FILE"
	fi
else
	if [ -z "$FOX_BUILD_DEVICE" -a -z "$BASH_SOURCE" ]; then
		echo "I: This script requires bash. Not processing the $FDEVICE $(basename $0)"
	fi
fi
#
