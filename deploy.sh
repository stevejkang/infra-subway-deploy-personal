#!/bin/bash

## λ³μ μ€μ 
BRANCH=$1
PROFILE=$2

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << DEPLOY >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

function pull() {
  echo -e ">> Getting branch πβοΈ "
  git pull origin "$BRANCH"
}

function build() {
  echo -e ">> Building π..."
  ./gradlew clean build -x test
}

function get_pid() {
  echo -e "$(jps | grep "subway" | awk '{print $1}')"
}

function kill_app() {
  local pid="$1"
  if [[ -z $pid ]]; then
    echo -e ">> PID not found π..."
  else
    echo -e ">> Killing PID (PID: $pid) π..."
    kill "$pid"
  fi
}

function start_app() {
  echo -e ">> Starting up (Profile: $PROFILE) π... "
  nohup java -jar \
        -Dspring.profiles.active="$PROFILE" \
        $(find ./* -name "*.jar" | head -n 1) \
        1>/home/ubuntu/subway.log \
        2>&1 \
        &
}

## μ μ₯μ pull
pull;

## gradle build
build;

## νλ‘μΈμ€ pidλ₯Ό μ°Ύλ λͺλ Ήμ΄
PID="$(get_pid)";

## νλ‘μΈμ€λ₯Ό μ’λ£νλ λͺλ Ήμ΄
kill_app "$PID";

## νλ‘μ νΈ μ€ν
start_app;
