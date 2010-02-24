/*
MIT license:
http://www.opensource.org/licenses/mit-license.php

Copyright (c) 2010 XAPI project contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

/**
* <p>The Backend class provides cross-platform typedef aliases to File, FileInput, FileOutput, Path, FileSystem, Sys, Lib and Process classes.</p> 
* <p>This alows XAPI to target Neko, PHP and C++ through a common API until this is implemented in the Std API.</p>
* <p>You can read about it in the mailing list and the New Features page on haXe's wiki.</p>
**/

package xa;

#if neko

typedef XAFile = neko.io.File;
typedef XAFileInput = neko.io.FileInput;
typedef XAFileOutput = neko.io.FileOutput;
typedef XAPath = neko.io.Path;
typedef XAFileSystem = neko.FileSystem;
typedef XASys = neko.Sys;
typedef XALib = neko.Lib;
typedef XAProcess = neko.io.Process;

#elseif php

typedef XAFile = php.io.File;
typedef XAFileInput = php.io.FileInput;
typedef XAFileOutput = php.io.FileOutput;
typedef XAPath = php.io.Path;
typedef XAFileSystem = php.FileSystem;
typedef XASys = php.Sys;
typedef XALib = php.Lib;
typedef XAProcess = php.io.Process;

#elseif cpp

typedef XAFile = cpp.io.File;
typedef XAFileInput = cpp.io.FileInput;
typedef XAFileOutput = cpp.io.FileOutput;
typedef XAPath = cpp.io.Path;
typedef XAFileSystem = cpp.FileSystem;
typedef XASys = cpp.Sys;
typedef XALib = cpp.Lib;
typedef XAProcess = cpp.io.Process;

#end

class Backend{}