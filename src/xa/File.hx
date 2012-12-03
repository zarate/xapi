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
* <p>The File class provides access to files in the system.</p> 
* <p>You can use both relative and absolute paths. Please note that paths are relative to your current working directory (which might not be your application's directory).</p> 
**/

package xa;

class File
{	
	/**
	* <p>Reads the content of a text file.</p> 
	**/
	public static function read(path : String) : String
	{
		#if flash

			var file = new flash.filesystem.File(path);
			
			var stream = new flash.filesystem.FileStream();
			stream.open(file, flash.filesystem.FileMode.READ);

			var content : String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			
			return content;

		#else

			var file = sys.io.File.read(path, false);
			var content = file.readAll().toString();
			file.close();
			 
			return content;

		#end
	}
	
	/**
	* <p>Writes content to a text file.</p> 
	**/
	public static function write(path : String, content : String) : Void
	{
		#if flash

			var file = new flash.filesystem.File(path);
			
			var stream = new flash.filesystem.FileStream();
			stream.open(file, flash.filesystem.FileMode.WRITE);
			stream.writeUTFBytes(content);
			stream.close();

		#else

			var file = sys.io.File.write(path, false);
			file.writeString(content);
			file.close();

		#end
	}
	
	/**
	* <p>Appends content to a text file. It creates the file if it doesn't exist.</p> 
	**/
	public static function append(path : String, content : String) : Void 
	{
		#if flash

			var file = new flash.filesystem.File(path);
			
			var stream = new flash.filesystem.FileStream();
			stream.open(file, flash.filesystem.FileMode.APPEND);
			stream.writeUTFBytes(content);
			stream.close();

		#else

			var file = sys.io.File.append(path, false);
			file.writeString(content);
			file.close();

		#end
	}
	
	/**
	* <p>Removes a file.</p> 
	**/
	public static function remove(path : String) : Void
	{
		#if flash

			var file = new flash.filesystem.File(path);
			file.deleteFile();

		#else

			sys.FileSystem.deleteFile(path);

		#end
	}
	
	/**
	* <p>Copies source file to destination <strong>file</strong>. If destination file doesn't exist, it will be created. If it does, it will be overwritten (<strong>no warning!</strong>).</p>
	* <p>Example: if you want to copy file "a.txt" to "folder", you need this:</p>
	* <p>[xa.File.copy("a.txt", "folder/a.txt");]</p>
	* <p>Note that you just can't pass "folder", <strong>you need to pass the full path of the new file</strong>.</p> 
	**/
	public static function copy(sourcePath : String, destinationPath : String) : Void 
	{
		#if flash

			var source = new flash.filesystem.File(sourcePath);
			source.copyTo(new flash.filesystem.File(destinationPath), true);

		#else

			sys.io.File.copy(sourcePath, destinationPath);

		#end
	}
	
	/**
	* <p>Returns true if the path exists <strong>and</strong> is a file.</p> 
	**/
	public static function isFile(path : String) : Bool
	{
		#if flash

			var file = new flash.filesystem.File(path);
			return (file.exists && !file.isDirectory);

		#else

			return (sys.FileSystem.exists(path) && !sys.FileSystem.isDirectory(path));

		#end
	}
	
	/**
	*  <p>Returns true if the given file has any of the extensions passed, false otherwise.</p>
	*  <p>Example: if you want to check if a file has either HTML or HTM extension, you could try:</p>
	*  <p>[var isHtml = xa.File.hasExtension("file.html", \["htm", "html"\])].</p>
	*  <p>Extensions are case-insensitve ("txt" will match both txt and TXT).</p>
	*  <p><b>DO NOT INCLUDE "." on the extensions to be matched.</b></p>
	**/  
	public static function hasExtension(path : String, extensions : Array<String>) : Bool
	{
		var ret = false;
		
		var file = new haxe.io.Path(path);
		
		if(null != file.ext) // if file has no extension, exit soon
		{
			for(extension in extensions)
			{
				if(extension.toLowerCase() == file.ext.toLowerCase())
				{
					ret = true;
					break;
				}
			}
		}
		
		return ret;
	}
	
	/**
	* <p>Launches a given file with system's default application passing the parameters given.</p>
	* <p>For example, it will open html files with your default browser and pdf files with your pdf reader.</p> 
	**/
	public static function launch(path : String, ?args : Array<String>) : Void 
	{
		#if flash

			// Read this for more info: http://www.adobe.com/devnet/air/flex/articles/exploring_file_capabilities.html#a
			
			var file = new flash.filesystem.File(path);
			file.openWithDefaultApplication();

		#else

			// Worth taking a look to http://haxe.org/api/neko/io/Process
			// http://lists.motion-twin.com/pipermail/haxe/2008-March/015438.html
			
			var command = (xa.System.isWindows())? "start" : "open";		
			Sys.command('"' + command + '" ' + sys.FileSystem.fullPath(path), args);

		#end
	}
}