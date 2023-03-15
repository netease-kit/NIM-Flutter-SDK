#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os
import sys
import glob
import platform
import shutil

SCRIPT_PATH = os.path.split(os.path.realpath(__file__))[0]

BUILD_OUT = 'output'
BUILD_CMD = 'cmake -S . -B {BUILD_OUT_PATH} -G {BUILD_GENERATORS} -DINSTALL_CPP_WRAPPER=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_CXX_STANDARD=14 && cmake --build {BUILD_OUT_PATH} --config {BUILD_TYPE}'

def build_macos(config='Release'):
    BUILD_CMD_TMP = BUILD_CMD.format(BUILD_OUT_PATH=BUILD_OUT, BUILD_GENERATORS="\"Xcode\"", BUILD_TYPE=config)
    print("build cmd:" + BUILD_CMD_TMP)
    os.chdir('../nim_sdk/wrapper')
    ret = os.system(BUILD_CMD_TMP)
    if 0 != ret:
        print('!!!!!!!!!!!!!!!!!!build fail!!!!!!!!!!!!!!!!!!!!')
        return False

    build_type = ''
    if config.lower() == 'release':
        build_type = 'Release'
    elif config.lower() == 'debug':
        build_type = 'Debug'
    else:
        print('!!!!!!!!!!!!!!!!!!build_type is empty!!!!!!!!!!!!!!!!!!!!')
        return False

    shutil.copyfile(BUILD_OUT + "/nim_cpp_wrapper/" + build_type + "/libnim_cpp_wrapper.a", SCRIPT_PATH + '/../nim_sdk/lib/libnim_cpp_wrapper.a')
    shutil.copyfile(BUILD_OUT + "/nim_chatroom_cpp_wrapper/" + build_type + "/libnim_chatroom_cpp_wrapper.a", SCRIPT_PATH + '/../nim_sdk/lib/libnim_chatroom_cpp_wrapper.a')
    shutil.copyfile(BUILD_OUT + "/nim_wrapper_util/" + build_type + "/libnim_wrapper_util.a", SCRIPT_PATH + '/../nim_sdk/lib/libnim_wrapper_util.a')

    return True

def copy_macos():
    nim_sdk = SCRIPT_PATH + '/../macos/nim_sdk'
    if os.path.isdir(nim_sdk):
        shutil.rmtree(nim_sdk)
    shutil.copytree(SCRIPT_PATH + '/../nim_sdk/lib',  nim_sdk + '/lib')
    shutil.copytree(SCRIPT_PATH + '/../nim_sdk/include', nim_sdk + '/include', symlinks=True)
    shutil.copytree(SCRIPT_PATH + '/../nim_sdk/wrapper', nim_sdk + '/wrapper', ignore=shutil.ignore_patterns('output'))

    return True

def main():
    build_type = 'Release'
    if len(sys.argv) == 1:
        print('default build Release.')
    else:
        build_type = sys.argv[1]

    os.chdir(SCRIPT_PATH)
    print('downloadSDK start.')
    os.system('dart run downloadSDK.dart')
    print('downloadSDK end.')
    
    print('buildSDK start.')
    build_macos(build_type)
    print('buildSDK end.')

    print('copySDK start.')
    copy_macos()
    print('copySDK end.')
        
if __name__ == '__main__':
    main()
