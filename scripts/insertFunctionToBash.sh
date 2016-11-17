#!/usr/bin/env bash
newline=$'\n'

# $1 functionName
# $2 function Body
function createFunctionAsString() {
    functionName="$1"
    functionBody="$2"
    printf "function ${functionName} () {
        ${functionBody} ${newline}"$'\n'"}"
}
# $1 procedure Name
# $2 procedure Body
function createProcedureAsString() {
    procedureName="$1"
    procedureBody="$2"
    printf "${procedureName} () {
        ${procedureBody}"$'\n'"}"
}

# $1 functionName
# $2 function Body
function insertFunctionToBash() {
    printf "$(createFunctionAsString "$1" "$2")" >> ~/.bashrc
}

# $1 functionName
# $2 function Body
function insertProcedureToBash() {
    printf "$(createProcedureAsString "$1" "$2")" >> ~/.bashrc
}