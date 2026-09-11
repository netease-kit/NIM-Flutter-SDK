import os
import requests
import shutil
import tarfile
from pathlib import Path
from urllib.parse import urlparse


def main():
    url = "https://yx-web-nosdn.netease.im/package/1781089874649/nim-darwin-universal-10-10-0-4946-build-3590310.tar.gz?download=nim-darwin-universal-10-10-0-4946-build-3590310.tar.gz"

    if not url:
        print("[downloadSDK]: Platform not supported.")
        return

    u = urlparse(url)
    sdk_file = u.query.split('=')[1] if 'download' in u.query else "nim_sdk.zip"

    tmpdir = os.path.join(Path(__file__).resolve().parent, '../nim_sdk')
    sdk = os.path.join(tmpdir, sdk_file)
    if os.path.exists(sdk):
        print("[downloadSDK]: sdk existing.")
        return

    os.makedirs(tmpdir, exist_ok=True)
    print(f"[downloadSDK]: start download sdk from {url}")
    response = requests.get(url, stream=True)
    with open(sdk, 'wb') as f:
        shutil.copyfileobj(response.raw, f)

    print("[downloadSDK]: download the end.")
    print(f"[downloadSDK]: start decompressing {sdk}")

    with tarfile.open(sdk, "r:gz") as tar:
        tar.extractall(path=tmpdir)

    libnim_path = os.path.join(tmpdir, 'lib/libnim_tools_http.dylib')
    if os.path.exists(libnim_path):
        os.remove(libnim_path)

    print("[downloadSDK]: decompression end(successfull).")

if __name__ == "__main__":
    main()