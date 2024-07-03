#!/bin/bash

log_info() {
    echo -e "\033[36m $* \033[0m"
}

log_err() {
    echo -e "\033[31m $* \033[0m"
}

log_warn() {
    echo -e "\033[33m $* \033[0m"
}

help() {
    echo -n "\
Usage: $BASH_SOURCE [PARAM=VAL]...

Description: Updating soft links Tools

e.g: options
  param 1 - release type, e.g: develop
      param 2 - target name, e.g: rk3288
      param 3 - target type, e.g: bsp or main
      param 4 - dev version, e.g: 20240628
      param 5 - tag version, e.g: v0.0.0

  param 1 - release type, e.g: release
      param 2 - target name, e.g: rk3288
      param 3 - target type, e.g: bsp or main
      param 4 - tag version, e.g: v0.0.0

  param 1 - release type, e.g: release
      param 2 - target name, e.g: rk3288
      param 3 - target type, e.g: main
      param 4 - tag version, e.g: default
"
}

argcs=$@

if [ -z "$argcs" -o "$argcs" == "help" -o "$argcs" == "-h" ]; then
    help
    exit 0
fi

if [ ! -z $1 ]; then
    rel_type=$1
    if [ "$rel_type" == "develop" -o "$rel_type" == "release" ]; then
        log_info "$rel_type type process ..."
    else
        log_err "error: param 1, only support: develop and release, plaese check!!!"
        exit 1
    fi
fi

if [ ! -z $2 ]; then
    target_nm=$2
    ls *$target_nm*.xml >/dev/null 2>&1  || {
        log_err "error: param 2, no target name xml file, please check!!!"
        exit 2
    }
fi

if [ ! -z $3 ]; then
    target_tp=$3
    if [ "$target_tp" == "bsp" -o "$target_tp" == "main" ]; then
        log_info "$target_tp mode process ..."
    else
        log_err "error: param 3, only support: bsp and main, plaese check!!!"
        exit 3
    fi
fi

[ "$rel_type" == "develop" ] && {
    if [ ! -z $4 -a ! -z $5 ]; then
        cd $target_nm/ && {
            target_src="${target_nm}_${target_tp}_next_$4.xml"
            [ "$target_tp" == "main" ] && {
                target_src="${target_nm}_next_$4.xml"
            }
            [ -f $target_src ] || {
                log_err "error: param 4, no this file($target_src)"
                exit 4
            }
            target_dst="${target_nm}_${target_tp}_release_$5.xml"
            [ "$target_tp" == "main" ] && {
                target_dst="${target_nm}_release_$5.xml"
            }
            if [ -f $target_dst ]; then
                rm -f $target_dst
                log_warn "delete file($target_dst) ..."
            fi
            ln -s $target_src $target_dst
            log_info "develop: re-soft-linking new files ..."
        }
        cd - >/dev/null 2>&1
    else
        log_err "error: if develop, then param 4 and param 5 must existence!!!"
    fi
}

[ "$rel_type" == "release" ] && {
    if [ ! -z $4 ]; then
        if [ "$4" == "default" -a "$target_tp" == "main" ]; then
            target_src="${target_nm}_release.xml"
            target_dst="default.xml"
            if [ -f $target_dst ]; then
                rm -f $target_dst
                log_warn "delete file($target_dst) ..."
            fi
        else
            target_src="$target_nm/${target_nm}_${target_tp}_release_$4.xml"
            [ "$target_tp" == "main" ] && {
                target_src="$target_nm/${target_nm}_release_$4.xml"
            }
            [ -f $target_src ] || {
                log_err "error: param 4, no this file($target_src)"
                exit 4
            }
            target_dst="${target_nm}_${target_tp}_release.xml"
            [ "$target_tp" == "main" ] && {
                target_dst="${target_nm}_release.xml"
            }
            if [ -f $target_dst ]; then
                rm -f $target_dst
                log_warn "delete file($target_dst) ..."
            fi
        fi
        ln -s $target_src $target_dst
        log_info "release: re-soft-linking new files ..."
    else
        log_err "error: if develop, then param 4 must existence!!!"
    fi
}
exit 0