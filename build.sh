#!/bin/bash

export TG_CHAT_ID=-1001518479647
export TG_TOKEN=1851416641:AAFFCb4y-oB1i9hjgtWYYQEeHjHCf2gh17I

# Just a basic script U can improvise lateron asper ur need xD 

# Function to show an informational message
msg() {
    echo -e "\e[1;32m$*\e[0m"
}

err() {
    echo -e "\e[1;41m$*\e[0m"
}

DATE=$(date +"%F-%S")
START=$(date +"%s")

# Inlined function to post a message
export BOT_MSG_URL="https://api.telegram.org/bot$TG_TOKEN/sendMessage"
tg_post_msg() {
	curl -s -X POST "$BOT_MSG_URL" -d chat_id="$TG_CHAT_ID" \
	-d "disable_web_page_preview=true" \
	-d "parse_mode=html" \
	-d text="$1"

}

tg_post_build() {
	curl --progress-bar -F document=@"$1" "$BOT_MSG_URL" \
	-F chat_id="$TG_CHAT_ID"  \
	-F "disable_web_page_preview=true" \
	-F "parse_mode=html" \
	-F caption="$3"
}

# Send a notificaton to TG
tg_post_msg "<b>Rom Compilation Started...</b>%0A<b>DATE : </b><code>$DATE</code>%0A"

tg_post_msg "<b>===+++ Setting up Build Environment +++===</b>"
echo " ===+++ Setting up Build Environment +++==="
apt-get install openssh-server -y
apt-get update --fix-missing
apt-get install openssh-server -y
mkdir ~/lineage && cd ~/lineage

tg_post_msg "<b>===+++ Syncing Rom Sources +++===</b>"
echo " ===+++ Syncing Rom Sources +++==="
repo init -u git://github.com/LineageOS/android.git -b lineage-18.1
repo sync --force-sync --no-clone-bundle -j31
git clone https://github.com/Redmi-MT6768/android_device_xiaomi_lava -b lineage-18.1 device/xiaomi/lava && git clone https://github.com/Redmi-MT6768/android_vendor_xiaomi_lava -b eleven vendor/xiaomi/lava && git clone https://github.com/Redmi-MT6768/android_kernel_xiaomi_mt6768 -b eleven kernel/xiaomi/mt6768 && git clone https://github.com/PixelExperience/device_mediatek_sepolicy_vndr -b eleven device/mediatek/sepolicy_vndr && git clone https://github.com/Redmi-MT6768/android_device_xiaomi_mt6768-common -b eleven device/xiaomi/mt6768-common

tg_post_msg "<b>===+++ Starting Build Rom +++===</b>"
echo " ===+++ Building Rom +++==="
export ALLOW_MISSING_DEPENDENCIES=true
export KBUILD_BUILD_USER=kucingabu
export KBUILD_BUILD_HOST=serverlelet
lunch lineage_lava-userdebug
mka bacon

# Upload zips & Rom.img (U can improvise lateron adding telegram support etc etc)
tg_post_msg "<b>===+++ Uploading Rom +++===</b>"
echo " ===+++ Uploading Rom +++==="

# Push Rom to channel
    cd out/target/product/$DEVICE
    ZIP=$(echo dotOS-*.zip)
    curl -F document=@$ZIP "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 
