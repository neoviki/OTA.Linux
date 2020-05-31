: '
    OTA Update Utility

        Author    : Viki - Vignesh Natarajan
        Contact   : vikiworks.io
'

#----------------- USER CONFIG START ------------------ #
REMOTE_URL="http://vikiworks.io/downloads"

#Config Version File Name @ remote url
VERSION_FILE_CFG="cfg_ver.txt"

#Software Version File Name @ remote url
VERSION_FILE_SW="sw_ver.txt"

#Software File Name @ remote url
SW_FILE="sw.tar.gz"

#Config File Name @ remote url
CFG_FILE="config.xml"

#Local Directory To Store Vertion Files, Config File and Software File
LOCAL_BASE_DIR="./updates"

#Frequency to check software updates @ remote url [ in seconds ]
UPDATE_CHECK_INTERVAL=10


#----------------- USER CONFIG END -------------------- #











# ---------------------- System Files -------------------- #


SW_VER_URL="$REMOTE_URL/$VERSION_FILE_SW"
CFG_VER_URL="$REMOTE_URL/$VERSION_FILE_CFG"
SW_UPDATE_URL="$REMOTE_URL/$SW_FILE"
CFG_UPDATE_URL="$REMOTE_URL/$CFG_FILE"

LOCAL_SW="$LOCAL_BASE_DIR/$SW_FILE"
LOCAL_CFG="$LOCAL_BASE_DIR/$CFG_FILE"

# Hidden Files
CUR_CFG_FILE="$LOCAL_BASE_DIR/.cur_$VERSION_FILE_CFG"
NEW_CFG_FILE="$LOCAL_BASE_DIR/.new_$VERSION_FILE_CFG"
CUR_SW_FILE="$LOCAL_BASE_DIR/.cur_$VERSION_FILE_SW"
NEW_SW_FILE="$LOCAL_BASE_DIR/.new_$VERSION_FILE_SW"

backup_old_config(){
    echo "[ status  ] backup old config"

}

backup_old_software(){
    echo "[ status  ] backup old software"
}

restore_old_software(){
    echo "[ status  ] restoring previous working software"

}

restore_old_config(){
    echo "[ status  ] restoring previous working config"

}

verify_config_installation(){
    echo "[ status  ] Verifying new config install"
    #On Failure
    #restore_old_config
}

verify_software_installation(){
    echo "[ status  ] Verifying new software install"
    #On Failure
    #restore_old_software
}

install_new_config(){
    backup_old_config
    echo "[ status  ] Installing new config update"
    verify_config_installation
}

install_new_software(){
    backup_old_software
    echo "[ status  ] Installing new software update"
    verify_software_installation
}



#Arg1 : Remote file name URL [ only http is supported ]
download(){
    REMOTE_FILE_URL=$1
    LOCAL_FILE=$2
    #echo "[ status  ] Downloading [ ${REMOTE_FILE_URL} ]"
    wget -q $REMOTE_FILE_URL -O /tmp/remote_file.ota
    if [ $? -eq 0 ]; then
        #echo "[ status  ] Remote file download successful : "$LOCAL_FILE
        mv /tmp/remote_file.ota $LOCAL_FILE 
        sleep 1
    else
        echo "[ failure ] Remote file download : [ ${REMOTE_FILE_URL} ]"
    fi

}

check_sw_update(){
    echo "[ status  ] Checking for new software update"
    download $SW_VER_URL $NEW_SW_FILE
    
    CUR_SW_ID="`cat $CUR_SW_FILE`"
    NEW_SW_ID="`cat $NEW_SW_FILE`"

    if [ "$CUR_SW_ID" != "$NEW_SW_ID" ]; then
        echo "[ status  ] New software update available"
        download $SW_UPDATE_URL $LOCAL_SW
        mv $NEW_SW_FILE $CUR_SW_FILE
        install_new_software
    fi
}

check_cfg_update(){
    echo "[ status  ] Checking for new config update"
    download $CFG_VER_URL $NEW_CFG_FILE
    
    CUR_CFG_ID="`cat $CUR_CFG_FILE`"
    NEW_CFG_ID="`cat $NEW_CFG_FILE`"

    if [ "$CUR_CFG_ID" != "$NEW_CFG_ID" ]; then
        echo "[ status  ] New config update available"
        download $CFG_UPDATE_URL $LOCAL_CFG
        mv $NEW_CFG_FILE $CUR_CFG_FILE
        install_new_config
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
    echo "[ status  ] OTA Update Monitor"    
    #Check and Create Directory

    [ ! -d "$LOCAL_BASE_DIR" ] && mkdir -p "$LOCAL_BASE_DIR"
    
    while [ 1 ]
    do
        #Checking Every time -> There are chances user accidentally delete these files

        init_file $CUR_CFG_FILE
        init_file $NEW_CFG_FILE
        init_file $CUR_SW_FILE
        init_file $NEW_SW_FILE

        check_sw_update
        check_cfg_update
        sleep $UPDATE_CHECK_INTERVAL
    done
}

ota_app
