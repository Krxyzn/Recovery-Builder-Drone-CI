#!/bin/bash

export TG_CHAT_ID=-1001580307414
export TG_TOKEN=1852697615:AAGKDF9cYNnTY4Ylm7XjBrsssS31eTtqYfk

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

tg_post_msg "<b>===+++ Syncing Rom Sources +++===</b>"
echo " ===+++ Syncing Rom Sources +++==="
git clone --recurse-submodules https://github.com/erfanoabdi/ErfanGSIs.git

tg_post_msg "<b>===+++ Starting Build Rom +++===</b>"
echo " ===+++ Building Rom +++==="
cd ErfanGSIs
bash setup.sh
./url2GSI.sh $ROM_URL $ROM_NAME

# Upload zips & Rom.img (U can improvise lateron adding telegram support etc etc)
tg_post_msg "<b>===+++ Uploading Rom +++===</b>"
echo " ===+++ Uploading Rom +++==="


# Push Rom to channel
    cd output
    ZIP=$(echo $ZIP_NAME-GSI-Aonly.7z)
    curl -F document=@$ZIP "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 
     
     ZIP=$(echo $ZIP_NAME-GSI-AB.7z)
    curl -F document=@$ZIP "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 
        
cat ErfanGSIs/output/*-Aonly-*.txt
