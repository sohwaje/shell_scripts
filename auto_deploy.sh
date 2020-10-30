# 소스 도커 자동적용 및 자동 컨테이너 시작 스크립트
# 사용예시
#  Dockerfile에 명시된 파일명으로 변환하여 도커 컨테이너로 기동
# ./auto_apply.sh

DEPLOY_NAME="test.jar"

## HOME 디렉토리 명
HOME_DIRECTORY="azureuser"

## SERVICE DIRECTORY(현재 서비스 디렉토리명)
SERVICE_DIRECTORY="apps/api"

## SERVICE 명(jar 파일 이름 앞자리와 동일해야함)
SERVICE_NAME="simplewebserver"

## Spring Profile
SPRING_PROFILE="stage"

## 외부에 제공되는 포트
HOST_PORT=80
## Docker Container 포트
CONTAINER_PORT=80

## Tag 버전명
VERSION="lts"

## IMAGE 명
IMAGE_NAME="${SERVICE_NAME}-${SPRING_PROFILE}"

APPLICATION_HOME="/home/${HOME_DIRECTORY}/${SERVICE_DIRECTORY}"
APPLICATION_NAME="${SERVICE_NAME}.jar"

cd ${APPLICATION_HOME}
FILE_NAME=$(ls ${SERVICE_NAME}*.jar -ltr | tail -1 | awk '{ print $9 }')
echo 'AUTO APPLY FILE_NAME: '$FILE_NAME

echo "======= 경로확인 ======="
echo "pwd"
pwd
echo "======= START ======="
if [ $FILE_NAME ];then
  if [ -f $FILE_NAME ];then

    echo "1. remove previous $DEPLOY_NAME"
    if [ -f $DEPLOY_NAME ];then

      echo "EXIST $DEPLOY_NAME -----------------"
      echo "2. rename $FILE_NAME -> $DEPLOY_NAME"
      EXIST_COUNT=`ls *.jar | grep -v "$DEPLOY_NAME" | wc -l`
      echo "EXIST_COUNT=$EXIST_COUNT"
      if [ $EXIST_COUNT -gt 0 ];then
        echo "rm $DEPLOY_NAME"
        rm $DEPLOY_NAME
        echo "cp $FILE_NAME $DEPLOY_NAME"
        cp $FILE_NAME $DEPLOY_NAME
      fi
    else
      echo "NOT EXIST $DEPLOY_NAME--------------"
      echo "2. rename $FILE_NAME -> $DEPLOY_NAME"
      EXIST_COUNT=`ls *.jar | grep -v "$DEPLOY_NAME" | wc -l`
      echo "EXIST_COUNT=$EXIST_COUNT"
      if [ $EXIST_COUNT -gt 0 ];then
        echo "cp $FILE_NAME $DEPLOY_NAME"
        cp $FILE_NAME $DEPLOY_NAME
      fi
    fi

    CONTAINER_ID=$(docker ps -af ancestor=${IMAGE_NAME}:${VERSION} --format "{{.ID}}")
    echo "CONTAINER_ID=$CONTAINER_ID"
    echo "---------------------"
    echo "3. Docker container stop"
    if [ $CONTAINER_ID ];then
      echo "docker stop $CONTAINER_ID"
      docker stop $CONTAINER_ID
      echo "---------------------"
      echo "4. Docker container remove"
      #docker rm `sudo docker ps -a -q`
      echo "docker rm $CONTAINER_ID"
      docker rm $CONTAINER_ID
    else
      echo "CONTAINER is Empty pass..."
    fi
    echo "---------------------"
    echo "5. Docker image remove"
    IMAGE_ID=$(docker images -f=reference=${IMAGE_NAME}':*' --format "{{.ID}}")
    echo "IMAGE_ID=$IMAGE_ID"
    if [ $IMAGE_ID ];then
      echo "docker rmi -f $IMAGE_ID"
      docker rmi -f $IMAGE_ID
    else
      echo "IMAGE is Empty pass..."
    fi
    echo "---------------------"
    echo "6. zip log delete"

    echo "---------------------"
    echo "7. Docker build"
    echo "docker build --build-arg APPLICATION_NAME="${APPLICATION_NAME}" --build-arg DEPLOY_NAME="${DEPLOY_NAME}" --tag ${IMAGE_NAME}:${VERSION} ./"
    docker build --build-arg APPLICATION_NAME="${APPLICATION_NAME}" --build-arg DEPLOY_NAME="${DEPLOY_NAME}" --build-arg SPRING_PROFILE=${SPRING_PROFILE}  --tag ${IMAGE_NAME}:${VERSION} ./

    echo "---------------------"
    echo "8. Docker create image & container start"

    echo "docker run -itd -p $HOST_PORT:$CONTAINER_PORT --name ${IMAGE_NAME} -v $APPLICATION_HOME/log:/log -v $APPLICATION_HOME/iparking:/iparking:rw  -v /etc/localtime:/etc/localtime:ro -e TZ=Asia/Seoul ${IMAGE_NAME}:${VERSION}"
    docker run -itd -p $HOST_PORT:$CONTAINER_PORT --name ${IMAGE_NAME} -v $APPLICATION_HOME/log:/log -v $APPLICATION_HOME/iparking:/iparking:rw -v /etc/localtime:/etc/localtime:ro -e TZ=Asia/Seoul ${IMAGE_NAME}:${VERSION}

    echo "rm $DEPLOY_NAME"
    rm $DEPLOY_NAME

    ## 하루 지난 파일은 삭제
    #find $APPLICATION_HOME/*.jar -ctime +0 -exec sudo rm -f {} \;
    ## 두시간 지난 파일은 삭제
    find $APPLICATION_HOME/*.jar -cmin +120 -exec sudo rm -f {} \;

    echo "======= Complete ======="
  else
    echo "$FILE_NAME is not Exist"
    echo "======= FAIL ======="
  fi
else
  echo "FILE_NAME is Empty input FILE_NAME please .. "
  echo "======= FAIL ======="
fi
