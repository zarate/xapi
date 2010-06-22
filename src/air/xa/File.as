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
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class File
	{
		public static function read(path : String) : String
		{
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			
			var stream : FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var content : String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			
			file = null;
			stream = null;
			
			return content;
		}
		
		public static function append(path : String, content : String) : void
		{
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			
			var stream : FileStream = new FileStream();
			stream.open(file, FileMode.APPEND);
			stream.writeUTFBytes(content);
			stream.close();
			
			file = null;
			stream = null;
		}
		
		public static function write(path : String, content : String) : void
		{
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			
			var stream : FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(content);
			stream.close();
			
			file = null;
			stream = null;
		}
		
		public static function isFile(path : String) : Boolean
		{
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			
			var ret : Boolean = (file.exists && !file.isDirectory);
			
			file = null;
			
			return ret;
		}
		
		public static function remove(path : String) : void
		{
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			file.deleteFile();
		}
		
		public static function copy(sourcePath: String, destinationPath : String) : void
		{
			var source : flash.filesystem.File = new flash.filesystem.File(sourcePath);
			
			source.copyTo(new flash.filesystem.File(destinationPath), true);
			
			source = null;
		}
		
		public static function hasExtension(path : String, extensions : Vector.<String>) : Boolean
		{
			var ret : Boolean = false;
			
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			
			for each(var extension : String in extensions)
			{
				if('.' + file.extension.toLowerCase() == extension.toLowerCase())
				{
					ret = true;
					break;
				}
			}
			
			file = null;
			
			return ret;
		}
		
		public static function launch(path : String) : void
		{
			// Read this for more info: http://www.adobe.com/devnet/air/flex/articles/exploring_file_capabilities.html#a
			
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			file.openWithDefaultApplication();
			
			file = null;
		}
	}
}