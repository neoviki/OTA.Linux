: '
    OTA Update Utility

        Author    : Viki - Vignesh Natarajan
        Contact   : vikiworks.io
'

BASE_DIR="."

UPDATE_CHECK_INTERVAL=10

CUR_CFG_FILE="$BASE_DIR/cfg.txt"
NEW_CFG_FILE="$BASE_DIR/cfg_update.txt"

CUR_SW_FILE="$BASE_DIR/sw.txt"
NEW_SW_FILE="$BASE_DIR/sw_update.txt"

REMOTE_SW_VER_FILE="http://vikiworks.io/downloads/sw_update.txt"
REMOTE_CFG_VER_FILE="http://vikiworks.io/downloads/cfg_update.txt"
REMOTE_SW="http://vikiworks.io/downloads/sw.tar.gz"
REMOTE_CFG="http://vikiworks.io/downloads/config.xml"
LOCAL_SW="sw.tar.gz"
LOCAL_CFG="config.xml"

#Arg1 : Remote file name URL [ only http is supported ]
download(){
    REMOTE_FILE_URL=$1
    LOCAL_FILE=$2
    #echo "[ status  ] Downloading [ ${REMOTE_FILE_URL} ]"
    wget -q $REMOTE_FILE_URL -O /tmp/remote_file.ota
    if [ $? -eq 0 ]; then
        #echo "[ status  ] Remote file download successful : "$LOCAL_FILE
        mv /tmp/remote_file.ota $LOCAL_FILE 
        sleep 4
    else
        echo "[ failure ] Remote file download successful : "$LOCAL_FILE
    fi

}

check_sw_update(){
    download $REMOTE_SW_VER_FILE $NEW_SW_FILE
    
    CUR_SW_ID="`cat $CUR_SW_FILE`"
    NEW_SW_ID="`cat $NEW_SW_FILE`"

    if [ "$CUR_SW_ID" != $NEW_SW_ID ]; then
        echo "[ status  ] New software update available"
        download $REMOTE_SW $LOCAL_SW
        mv $NEW_SW_FILE $CUR_SW_FILE
    fi
}

check_cfg_update(){
    download $REMOTE_CFG_VER_FILE $NEW_CFG_FILE
    
    CUR_CFG_ID="`cat $CUR_CFG_FILE`"
    NEW_CFG_ID="`cat $NEW_CFG_FILE`"

    if [ "$CUR_CFG_ID" != $NEW_CFG_ID ]; then
        echo "[ status  ] New config update available"
        download $REMOTE_CFG $LOCAL_CFG
        mv $NEW_CFG_FILE $CUR_CFG_FILE
    fi
}

init_file(){
   FILE=$1
    if [ ! -f "$FILE" ]; then #if file doesn't exist
        echo "[ status  ] Creating $FILE file"
        touch $FILE
        echo "0" > $FILE
    fi 
}

ota_app(){

    init_file $CUR_CFG_FILE
    init_file $NEW_CFG_FILE
    init_file $CUR_SW_FILE
    init_file $NEW_SW_FILE

    while [ 1 ]
    do
        echo "[ status  ] checking for new firmware / config update"
        check_sw_update
        check_cfg_update
        sleep $UPDATE_CHECK_INTERVAL
    done
}

ota_app
