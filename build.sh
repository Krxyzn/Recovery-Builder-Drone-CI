#!/bin/bash

apt-get -y update && apt-get -y upgrade && apt-get -y install bc bison build-essential curl flex g++-multilib gcc gcc-multilib clang git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev unzip openjdk-8-jdk python ccache libtinfo5 repo libstdc++6 wget libssl-dev rsync golang-go

git clone --recurse-submodules https://github.com/erkanergen7/ErfanGSIs-VelanGSIs ErfanGSIs
chmod -R 777 ErfanGSIs
cd ErfanGSIs

export TG_CHAT_ID=-1001580307414
export TG_TOKEN=1852697615:AAGKDF9cYNnTY4Ylm7XjBrsssS31eTtqYfk
export BOT_MSG_URL=https://api.telegram.org/bot$TG_TOKEN/sendMessage
export INFO=cat output/*-Aonly-*.txt

msg() {
    echo -e "\e[1;32m$*\e[0m"
}

err() {
    echo -e "\e[1;41m$*\e[0m"
}

DATE=$(date +"%F-%S")
START=$(date +"%s")

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

tg_post_msg "<b>Rom Compilation Started...</b>%0A<b>Date : </b><code>$DATE</code>%0A"
bash setup.sh
apt-get update --fix-missing
./url2GSI.sh $ROM_URL $ROM_NAME

tg_post_msg "<b>===+++ Uploading Rom +++===</b>"
echo " ===+++ Uploading Rom +++==="
# Push Rom to channel
	zip -r output/$ZIP_NAME-GSI-AB.7z output/*-AB-*.img
    ZIP=$(echo $ZIP_NAME-GSI-AB.7z)
    curl -F document=@output/$ZIP "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 
     
    zip -r output/$ZIP_NAME-GSI-Aonly.7z output/*-Aonly-*.img
    ZIP=$(echo $ZIP_NAME-GSI-Aonly.7z)
    curl -F document=@output/$ZIP "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 

tg_post_msg "<b>Rom Info : </b><code>$INFO</code>%0A"
