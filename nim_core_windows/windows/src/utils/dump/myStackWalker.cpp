// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "myStackWalker.h"

#include <Shlwapi.h>
#pragma comment(lib, "Shlwapi.lib")
#include <iostream>

CallStackItem::CallStackItem(MyStackWalker::CallstackEntry& entry) {
  if (entry.undFullName[0] != 0)
    functionName_ = entry.undFullName;
  else if (entry.undName[0] != 0)
    functionName_ = entry.undName;
  else if (entry.name[0] != 0)
    functionName_ = entry.name;

  if (entry.lineFileName[0] != 0) sourceFile_ = entry.lineFileName;

  lineNumber_ = entry.lineNumber;
  if (entry.loadedImageName[0] != 0) {
    module_ = PathFindFileNameA(entry.loadedImageName);
  }
}
std::string CallStackItem::GetInfoTxt() {
  std::string info;
  info.append(module_);
  info.append("!");
  info.append(functionName_);
  info.append(" ");
  info.append(sourceFile_);
  info.append("+");
  info.append(std::to_string(lineNumber_));
  return info;
}

bool MyStackWalker::HasModule(const std::string& module) {
  for (auto& item : callStack_) {
    YXLOG(Fatal) << "item: " << item.Module() << YXLOGEnd;
    if (item.Module() == module) return true;
  }
  return false;
}
std::string MyStackWalker::GetCallStackInfoTxt(const std::string& dll_name,
                                               std::string& stacks) {
  std::string txt;
  for (auto& item : callStack_) {
    std::string stack_info = item.GetInfoTxt() + "\n";
    txt.append(stack_info);

    if (item.Module() == dll_name) {
      stacks.append(stack_info);
    }
  }
  return txt;
}

void MyStackWalker::OnSymInit(LPCSTR szSearchPath, DWORD symOptions,
                              LPCSTR szUserName) {}

void MyStackWalker::OnLoadModule(LPCSTR img, LPCSTR mod, DWORD64 baseAddr,
                                 DWORD size, DWORD result, LPCSTR symType,
                                 LPCSTR pdbName, ULONGLONG fileVersion) {}

void MyStackWalker::OnCallstackEntry(CallstackEntryType eType,
                                     CallstackEntry& entry) {
  if ((eType != lastEntry) && (entry.offset != 0)) {
    CallStackItem item(entry);
    callStack_.push_back(item);
  }
}

void MyStackWalker::OnDbgHelpErr(LPCSTR szFuncName, DWORD gle, DWORD64 addr) {
  StackWalker::OnDbgHelpErr(szFuncName, gle, addr);
}

void MyStackWalker::OnOutput(LPCSTR szText) { StackWalker::OnOutput(szText); }
