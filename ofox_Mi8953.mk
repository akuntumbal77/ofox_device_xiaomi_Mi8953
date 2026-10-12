#
# Copyright 2021 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Release name (Mi8953 - keluarga msm8953: mido / vince / ysl)
PRODUCT_RELEASE_NAME := Mi8953
DEVICE_PATH := device/xiaomi/$(PRODUCT_RELEASE_NAME)

$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

# Inherit from the common recovery product configuration
# (vendor/twrp adalah repo bawaan minimal-manifest TWRP yang dipakai
#  OrangeFox fox_12.1 juga - path ini disediakan oleh source, bukan repo ini)
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit device configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

# Inherit any OrangeFox-specific product settings (opsional, kalau ada)
$(call inherit-product-if-exists, $(DEVICE_PATH)/fox_Mi8953.mk)

# Device identifier. This must come after all inclusions
PRODUCT_NAME := ofox_$(PRODUCT_RELEASE_NAME)
PRODUCT_DEVICE := $(PRODUCT_RELEASE_NAME)
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := Mi8953
PRODUCT_MANUFACTURER := Xiaomi
