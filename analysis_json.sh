createDirPath() {
  FILE_DATE=`date '+%Y%m%d'`
  DIR_NAME=analysis_json_${FILE_DATE}_${1}
  DIR=~/work/playground/${DIR_NAME}
  if [ ! -d ${DIR} ];then
    echo ${DIR}
  else
    let FILE_COUNT=${1}+1
    createDirPath $FILE_COUNT
  fi
}
DIR_PATH=`createDirPath 1`
mkdir -p ${DIR_PATH}/json
cp -p ./analysis_json.ts ${DIR_PATH}/analysis_json.ts
touch ${DIR_PATH}/.myRoot
printf "${DIR_PATH}\n"
printf "created analysis json dir!\n"
