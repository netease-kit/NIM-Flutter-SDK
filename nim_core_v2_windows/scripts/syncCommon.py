import os
import platform
import shutil
from distutils import dir_util

SCRIPT_PATH = os.path.split(os.path.realpath(__file__))[0]
os.chdir(SCRIPT_PATH + '/..')

dst = '../nim_core_v2_macos/macos/Classes/common/services'
if os.path.isdir(dst):
    shutil.rmtree(dst)
shutil.copytree('windows/src/common/services', dst)
