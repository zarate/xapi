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

package xa 
{
	import flash.filesystem.File;

	public class FileSystem 
	{
		public static function exists(path : String) : Boolean
		{
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			
			var ret : Boolean = file.exists;
			
			file = null;
			
			return ret;
		}
		
		public static function isHidden(path : String) : Boolean
		{
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			
			var ret : Boolean = file.isHidden;
			
			file = null;
			
			return ret;
		}
		
		public static function rename(path : String, newPath : String) : void
		{
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			
			var newFile : flash.filesystem.File = new flash.filesystem.File(newPath);
			file.moveTo(newFile, false); // TODO: check out if haxe overwrites by default an update docs
			
			file = null;
			newFile = null;
		}
		
		public static function getNameFromPath(path : String) : String
		{
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			
			var ret : String = file.name;
			
			file = null;
			
			return ret
		}
		
		public static function pathToUnix(path : String) : String
		{
			return path.split("\\").join(xa.System.UNIX_SEPARATOR);
		}
		
		public static function pathToWindows(path : String) : String
		{
			return path.split("/").join(xa.System.WIN_SEPARATOR);
		}
		
		public static function pathToCurrent(path : String) : String
		{
			return (true == xa.System.isWindows())? pathToWindows(path) : pathToUnix(path);
		}
	}
}