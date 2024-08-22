// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#pragma once

#include <string>
#include <vector>

#include "stackWalker.h"

class MyStackWalker;
class CallStackItem;

class MyStackWalker : public StackWalker {
 public:
  const std::vector<CallStackItem>& GetCallStack() { return callStack_; }

  bool HasModule(const std::string& module);
  std::string GetCallStackInfoTxt(const std::string& dll_name,
                                  std::string& stacks);

 protected:
  friend class CallStackItem;
  virtual void OnSymInit(LPCSTR szSearchPath, DWORD symOptions,
                         LPCSTR szUserName);
  virtual void OnLoadModule(LPCSTR img, LPCSTR mod, DWORD64 baseAddr,
                            DWORD size, DWORD result, LPCSTR symType,
                            LPCSTR pdbName, ULONGLONG fileVersion);
  virtual void OnCallstackEntry(CallstackEntryType eType,
                                CallstackEntry& entry);
  virtual void OnDbgHelpErr(LPCSTR szFuncName, DWORD gle, DWORD64 addr);
  virtual void OnOutput(LPCSTR szText);

 private:
  std::vector<CallStackItem> callStack_;
};

class CallStackItem {
 public:
  CallStackItem() = default;
  CallStackItem(MyStackWalker::CallstackEntry& entry);
  std::string FunctionName() { return functionName_; }

  std::string SourceFile() { return sourceFile_; }

  int LineNumber() { return lineNumber_; }

  std::string Module() { return module_; }

  std::string GetInfoTxt();

 private:
  std::string functionName_;
  std::string sourceFile_;
  int lineNumber_;
  std::string module_;
};