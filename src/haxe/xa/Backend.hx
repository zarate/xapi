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

package xa;

#if neko

/**
* <p>Alias for neko.io.File, php.io.File or cpp.io.File depending on the compilation target.</p> 
**/

typedef XAFile = neko.io.File;

/**
* <p>Alias for neko.io.FileInput, php.io.FileInput or cpp.io.FileInput depending on the compilation target.</p> 
**/

typedef XAFileInput = neko.io.FileInput;

/**
* <p>Alias for neko.io.FileOutput, php.io.FileOutput or cpp.io.FileOutput depending on the compilation target.</p> 
**/

typedef XAFileOutput = neko.io.FileOutput;

/**
* <p>Alias for neko.io.Path, php.io.Path or cpp.io.Path depending on the compilation target.</p> 
**/

typedef XAPath = neko.io.Path;

/**
* <p>Alias for neko.FileSystem, php.FileSystem or cpp.FileSystem depending on the compilation target.</p> 
**/

typedef XAFileSystem = neko.FileSystem;

/**
* <p>Alias for neko.Sys, php.Sys or cpp.Sys depending on the compilation target.</p> 
**/

typedef XASys = neko.Sys;

/**
* <p>Alias for neko.Lib, php.Lib or cpp.Lib depending on the compilation target.</p> 
**/

typedef XALib = neko.Lib;

/**
* <p>Alias for neko.io.Process, php.io.Process or cpp.io.Process depending on the compilation target.</p> 
**/

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

/**
* <p>The Backend class provides cross-platform typedef aliases to File, FileInput, FileOutput, Path, FileSystem, Sys, Lib and Process classes.</p> 
* <p>This alows XAPI to target Neko, PHP and C++ through a common API until this is implemented in the Std API.</p>
* <p>You can read about it in <a href="http://wiki.github.com/zarate/xapi/cross-target">Wiki</a>, the <a href="http://lists.motion-twin.com/pipermail/haxe/2010-February/034044.html">mailing list</a> and the <a href="http://haxe.org/com/features">New Features page</a> on haXe's site.</p>
**/

class Backend{}