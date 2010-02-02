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

class File
{
	
	public static function read(path : String) : String
	{
		var f = neko.io.File.read(path, false);
		var content = f.readAll().toString();
		f.close();
		
		return content;
	}
	
	public static function write(path : String, content : String) : Void
	{
		var f = neko.io.File.write(path, false);
		f.writeString(content);
		f.close();
	}
	
	public static function append(path : String, content : String) : Void 
	{
		var f = neko.io.File.append(path, false);
		f.writeString(content);
		f.close();
	}
	
	public static function delete(path : String) : Void 
	{
		neko.FileSystem.deleteFile(path);
	}
	
	public static function copy(source : String, destination : String) : Void 
	{
		neko.io.File.copy(source, destination);
	}
	
	public static function isFile(path : String) : Bool
	{
		return (neko.FileSystem.exists(path) && !neko.FileSystem.isDirectory(path));
	}
	
	public static function launch(path : String, ?args : Array<String>) : Void 
	{
		
		// Worth taking a look to http://haxe.org/api/neko/io/Process
		// http://lists.motion-twin.com/pipermail/haxe/2008-March/015438.html
		
		var actualPath = new neko.io.Path(path);
		
		// a relative path makes actualPath.dir null, so we handle that using current working directory
		if(actualPath.dir == null)
		{
			actualPath.dir = neko.Sys.getCwd();
		}
		
		neko.Sys.setCwd(actualPath.dir);
		
		var command = (xa.System.isWindows())? "start" : "open";
		neko.Sys.command('"' + command + '" ' + actualPath.file + "." + actualPath.ext, args);
		
	}
	
	public static function readBinary(path : String) : neko.io.FileInput
	{
		return neko.io.File.read(path, true);
	}
	
	public static function writeBinary(path : String) : neko.io.FileOutput
	{
		return neko.io.File.write(path, true);
	}
	
	public static function appendBinary(path : String) : neko.io.FileOutput
	{
		return neko.io.File.append(path, true);
	}
	
}