# Shebang is intentionally missing - do not run as a script

# Firmware archive settings
FW_VERSION="Pong_B4.0-251226-1110"
FW_BASENAME="${FW_VERSION}-image-firmware"
FW_ARCHIVE="${FW_BASENAME}.7z"
FW_URL="https://github.com/spike0en/nothing_archive/releases/download/${FW_VERSION}/${FW_ARCHIVE}"

# Paths
VENDOR_PATH="vendor/nothing/Pong"
RADIO_DIR="${VENDOR_PATH}/radio"
FW_EXTRACT_DIR="${FW_BASENAME}"

# Prepare directories
mkdir -p "${RADIO_DIR}"

# Download firmware archive
curl -L --fail -o "${FW_ARCHIVE}" "${FW_URL}"

# Extract firmware
7z x "${FW_ARCHIVE}" -o"${FW_EXTRACT_DIR}"

# Remove archive
rm -f "${FW_ARCHIVE}"

# Copy radio firmware images
cp "${FW_EXTRACT_DIR}/abl.img"          "${RADIO_DIR}/abl.img"
cp "${FW_EXTRACT_DIR}/aop.img"          "${RADIO_DIR}/aop.img"
cp "${FW_EXTRACT_DIR}/aop_config.img"   "${RADIO_DIR}/aop_config.img"
cp "${FW_EXTRACT_DIR}/bluetooth.img"    "${RADIO_DIR}/bluetooth.img"
cp "${FW_EXTRACT_DIR}/cpucp.img"        "${RADIO_DIR}/cpucp.img"
cp "${FW_EXTRACT_DIR}/devcfg.img"       "${RADIO_DIR}/devcfg.img"
cp "${FW_EXTRACT_DIR}/dsp.img"          "${RADIO_DIR}/dsp.img"
cp "${FW_EXTRACT_DIR}/featenabler.img"  "${RADIO_DIR}/featenabler.img"
cp "${FW_EXTRACT_DIR}/hyp.img"          "${RADIO_DIR}/hyp.img"
cp "${FW_EXTRACT_DIR}/imagefv.img"      "${RADIO_DIR}/imagefv.img"
cp "${FW_EXTRACT_DIR}/keymaster.img"    "${RADIO_DIR}/keymaster.img"
cp "${FW_EXTRACT_DIR}/modem.img"        "${RADIO_DIR}/modem.img"
cp "${FW_EXTRACT_DIR}/multiimgoem.img"  "${RADIO_DIR}/multiimgoem.img"
cp "${FW_EXTRACT_DIR}/multiimgqti.img"  "${RADIO_DIR}/multiimgqti.img"
cp "${FW_EXTRACT_DIR}/qupfw.img"        "${RADIO_DIR}/qupfw.img"
cp "${FW_EXTRACT_DIR}/qweslicstore.img" "${RADIO_DIR}/qweslicstore.img"
cp "${FW_EXTRACT_DIR}/shrm.img"         "${RADIO_DIR}/shrm.img"
cp "${FW_EXTRACT_DIR}/tz.img"           "${RADIO_DIR}/tz.img"
cp "${FW_EXTRACT_DIR}/uefi.img"         "${RADIO_DIR}/uefi.img"
cp "${FW_EXTRACT_DIR}/uefisecapp.img"   "${RADIO_DIR}/uefisecapp.img"
cp "${FW_EXTRACT_DIR}/xbl.img"          "${RADIO_DIR}/xbl.img"
cp "${FW_EXTRACT_DIR}/xbl_config.img"   "${RADIO_DIR}/xbl_config.img"
cp "${FW_EXTRACT_DIR}/xbl_ramdump.img"  "${RADIO_DIR}/xbl_ramdump.img"

# Remove firmware folder
rm -rf "${FW_EXTRACT_DIR}"

# Reassemble split proprietary library
cat ${VENDOR_PATH}/proprietary/vendor/lib64/libhyperzoom.arcsoft.so.part* \
> ${VENDOR_PATH}/proprietary/vendor/lib64/libhyperzoom.arcsoft.so

echo ""
echo "[vendorsetup.sh] Done!"
