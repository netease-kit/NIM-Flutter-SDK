// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "appDump.h"

#include <DbgHelp.h>
#pragma comment(lib, "Dbghelp.lib")
#include <Shlwapi.h>
#pragma comment(lib, "Shlwapi.lib")
#include <windows.h>

#include "myStackWalker.h"

static LPTOP_LEVEL_EXCEPTION_FILTER dump_cb_ = nullptr;
static std::wstring dump_path_;

BOOL CALLBACK MyMiniDumpCallback(PVOID, const PMINIDUMP_CALLBACK_INPUT input,
                                 PMINIDUMP_CALLBACK_OUTPUT output) {
  if (input == NULL || output == NULL) return FALSE;

  BOOL ret = FALSE;
  switch (input->CallbackType) {
    case IncludeModuleCallback:
    case IncludeThreadCallback:
    case ThreadCallback:
    case ThreadExCallback:
      ret = TRUE;
      break;
    case ModuleCallback: {
      if (!(output->ModuleWriteFlags & ModuleReferencedByMemory)) {
        output->ModuleWriteFlags &= ~ModuleWriteModule;
      }
      ret = TRUE;
    } break;
    default:
      break;
  }

  return ret;
}

void WriteDump(EXCEPTION_POINTERS* exp, const std::wstring& path) {
  YXLOG(Fatal) << "writeDump." << YXLOGEnd;
  HANDLE h = ::CreateFile(path.c_str(), GENERIC_WRITE | GENERIC_READ,
                          FILE_SHARE_WRITE | FILE_SHARE_READ, NULL,
                          CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
  if (NULL == h || INVALID_HANDLE_VALUE == h) {
    YXLOG(Fatal) << "createFile failed." << YXLOGEnd;
    return;
  }
  MINIDUMP_EXCEPTION_INFORMATION info;
  info.ThreadId = ::GetCurrentThreadId();
  info.ExceptionPointers = exp;
  info.ClientPointers = NULL;

  MINIDUMP_CALLBACK_INFORMATION mci;
  mci.CallbackRoutine = (MINIDUMP_CALLBACK_ROUTINE)MyMiniDumpCallback;
  mci.CallbackParam = 0;

  MINIDUMP_TYPE mdt =
      (MINIDUMP_TYPE)(/*MiniDumpWithIndirectlyReferencedMemory |*/
                      MiniDumpScanMemory);

  MiniDumpWriteDump(GetCurrentProcess(), GetCurrentProcessId(), h, mdt, &info,
                    NULL, &mci);
  ::CloseHandle(h);
}

static std::string getCurMoudleName() {
  static std::string s_curMoudleName;
  if (s_curMoudleName.empty()) {
    wchar_t path[MAX_PATH] = {0};
    DWORD dw = GetModuleFileName(NULL, path, MAX_PATH);
    if (0 != dw) {
      std::wstring curMoudleName = PathFindFileName(path);
      if (curMoudleName.empty()) {
        s_curMoudleName.clear();
      } else {
        int size_needed =
            WideCharToMultiByte(CP_UTF8, 0, &curMoudleName[0],
                                (int)curMoudleName.size(), NULL, 0, NULL, NULL);
        std::string strTo(size_needed, 0);
        WideCharToMultiByte(CP_UTF8, 0, &curMoudleName[0],
                            (int)curMoudleName.size(), &strTo[0], size_needed,
                            NULL, NULL);
        s_curMoudleName = strTo;
      }
    }

    YXLOG(Fatal) << "getCurMoudleName: " << s_curMoudleName << YXLOGEnd;
  }

  return s_curMoudleName;
}

static bool IsCurMoudleCrash(MyStackWalker& stackwalker) {
  if (stackwalker.HasModule(getCurMoudleName())) return true;
  return false;
}

LONG WINAPI MyUnhandledExceptionFilter(EXCEPTION_POINTERS* exp) {
  MyStackWalker stackwalker;
  stackwalker.ShowCallstack(GetCurrentThread(), exp->ContextRecord);
  if (IsCurMoudleCrash(stackwalker)) {
    std::string cur_stacks;
    std::string all_stacks =
        stackwalker.GetCallStackInfoTxt(getCurMoudleName(), cur_stacks);
    all_stacks.insert(0, "\n");
    YXLOG(Fatal) << "crash, stacks: " << all_stacks << YXLOGEnd;
    if (!dump_path_.empty()) {
      WriteDump(exp, dump_path_);
    }
  }
  if (dump_cb_ != nullptr) {
    return dump_cb_(exp);
  }
  return EXCEPTION_EXECUTE_HANDLER;
}

void InitDumpInfo(const std::string& dumpFile) {
  if (dumpFile.empty()) {
    dump_path_.clear();
  } else {
    int size_needed = MultiByteToWideChar(CP_UTF8, 0, &dumpFile[0],
                                          (int)dumpFile.size(), NULL, 0);
    std::wstring wstrTo(size_needed, 0);
    MultiByteToWideChar(CP_UTF8, 0, &dumpFile[0], (int)dumpFile.size(),
                        &wstrTo[0], size_needed);
    dump_path_ = wstrTo;
  }

  dump_cb_ = ::SetUnhandledExceptionFilter(MyUnhandledExceptionFilter);
}

void ClearDumpInfo() {
  dump_path_.clear();
  if (dump_cb_) {
    auto cb = ::SetUnhandledExceptionFilter(dump_cb_);
    if (cb != MyUnhandledExceptionFilter) {
      ::SetUnhandledExceptionFilter(cb);
    }
    dump_cb_ = nullptr;
  }
}