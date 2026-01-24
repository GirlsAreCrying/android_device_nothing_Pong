# Shebang is intentionally missing - do not run as a script

# --------------------------------------------------
# Firmware archive settings
# --------------------------------------------------
FW_VERSION="Pong_B4.0-251226-1110"
FW_BASENAME="${FW_VERSION}-image-firmware"
FW_ARCHIVE="${FW_BASENAME}.7z"
FW_URL="https://github.com/spike0en/nothing_archive/releases/download/${FW_VERSION}/${FW_ARCHIVE}"

# --------------------------------------------------
# Paths
# --------------------------------------------------
VENDOR_PATH="vendor/nothing/Pong"
RADIO_DIR="${VENDOR_PATH}/radio"
FW_EXTRACT_DIR="${FW_BASENAME}"
RADIO_MK="${VENDOR_PATH}/Android.mk"

# --------------------------------------------------
# List of images
# --------------------------------------------------
IMG_LIST=(
    "abl.img"
    "aop.img"
    "aop_config.img"
    "bluetooth.img"
    "cpucp.img"
    "devcfg.img"
    "dsp.img"
    "featenabler.img"
    "hyp.img"
    "imagefv.img"
    "keymaster.img"
    "modem.img"
    "multiimgoem.img"
    "multiimgqti.img"
    "qupfw.img"
    "qweslicstore.img"
    "shrm.img"
    "tz.img"
    "uefi.img"
    "uefisecapp.img"
    "xbl.img"
    "xbl_config.img"
    "xbl_ramdump.img"
)

# --------------------------------------------------
# Prepare directories
# --------------------------------------------------
mkdir -p "${RADIO_DIR}"

# --------------------------------------------------
# Firmware handling
# --------------------------------------------------
FIRMWARE_UPDATED=0

if [ -d "${RADIO_DIR}" ] && ls "${RADIO_DIR}"/*.img >/dev/null 2>&1; then
    echo "[vendorsetup.sh] Radio firmware already exists, skipping download"
else
    echo "[vendorsetup.sh] Radio firmware not found, downloading"

    # Download firmware archive
    curl -L --fail -o "${FW_ARCHIVE}" "${FW_URL}"

    # Extract firmware
    7z x "${FW_ARCHIVE}" -o"${FW_EXTRACT_DIR}"

    # Remove archive
    rm -f "${FW_ARCHIVE}"

    # Copy images from IMG_LIST
    for img in "${IMG_LIST[@]}"; do
        if [ -f "${FW_EXTRACT_DIR}/${img}" ]; then
            cp "${FW_EXTRACT_DIR}/${img}" "${RADIO_DIR}/${img}"
        fi
    done

    # Remove firmware folder
    rm -rf "${FW_EXTRACT_DIR}"
    FIRMWARE_UPDATED=1
fi

# --------------------------------------------------
# Auto-generate Android.mk with SHA1
# --------------------------------------------------
if [ "${FIRMWARE_UPDATED}" = "1" ] || [ ! -f "${RADIO_MK}" ]; then
    echo "[vendorsetup.sh] Generating Android.mk with SHA1 checksums"

    {
        echo "#"
        echo "# Automatically generated file. DO NOT MODIFY"
        echo "#"
        echo
        echo "LOCAL_PATH := \$(call my-dir)"
        echo
        echo "ifeq (\$(TARGET_DEVICE),Pong)"
        echo

        for img in "${IMG_LIST[@]}"; do
            path="${RADIO_DIR}/${img}"
            if [ -f "${path}" ]; then
                sha1="$(sha1sum "${path}" | awk '{print $1}')"
                echo "\$(call add-radio-file-sha1-checked,radio/${img},${sha1})"
            fi
        done

        echo
        echo "endif"
    } > "${RADIO_MK}"
fi

# --------------------------------------------------
# Reassemble split proprietary library
# --------------------------------------------------
cat ${VENDOR_PATH}/proprietary/vendor/lib64/libhyperzoom.arcsoft.so.part* \
> ${VENDOR_PATH}/proprietary/vendor/lib64/libhyperzoom.arcsoft.so

echo ""
echo "[vendorsetup.sh] Done!"
