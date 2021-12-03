import os
import platform
import shutil
from distutils import dir_util

SCRIPT_PATH = os.path.split(os.path.realpath(__file__))[0]
os.chdir(SCRIPT_PATH + '/..')

dst = '../nim_core_windows/windows/src/common'
if os.path.isdir(dst):
    shutil.rmtree(dst)
shutil.copytree('macos/Classes/common', dst)

shutil.copyfile('scripts/downloadSDK.dart', '../nim_core_windows/scripts/downloadSDK.dart')

