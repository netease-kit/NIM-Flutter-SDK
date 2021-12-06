import os
import platform
import shutil
from distutils import dir_util

SCRIPT_PATH = os.path.split(os.path.realpath(__file__))[0]
os.chdir(SCRIPT_PATH + '/..')

dst = '../nim_core_macos/macos/Classes/common'
if os.path.isdir(dst):
    shutil.rmtree(dst)
shutil.copytree('windows/src/common', dst)

shutil.copyfile('scripts/downloadSDK.dart', '../nim_core_macos/scripts/downloadSDK.dart')
