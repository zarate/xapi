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
		var f = neko.io.File.read(path, false);
		var content = f.readAll().toString();
		f.close();
		
		return content;
	}
	
	/**
	* <p>Writes content to a text file.</p> 
	**/
	
	public static function write(path : String, content : String) : Void
	{
		var f = neko.io.File.write(path, false);
		f.writeString(content);
		f.close();
	}
	
	/**
	* <p>Appends content to a text file.</p> 
	**/
	
	public static function append(path : String, content : String) : Void 
	{
		var f = neko.io.File.append(path, false);
		f.writeString(content);
		f.close();
	}
	
	/**
	* <p>Deletes a file.</p> 
	**/
	
	public static function delete(path : String) : Void 
	{
		neko.FileSystem.deleteFile(path);
	}
	
	/**
	* <p>Copies source file to destination <strong>file</strong>. If destination file doesn't exist, it will be created. If it does, it will be overwritten (<strong>no warning!</strong>).</p>
	* <p>Example: if you want to copy file "a.txt" to "folder", you need this:</p>
	* <p>[xa.File.copy("a.txt", "folder/a.txt");]</p>
	* <p>Note that you just can't pass "folder", <strong>you need to pass the full path of the new file</strong>.</p> 
	**/
	
	public static function copy(sourcePath : String, destinationPath : String) : Void 
	{
		neko.io.File.copy(sourcePath, destinationPath);
	}
	
	/**
	* <p>Returns true if the path exists <strong>and</strong> is a file.</p> 
	**/
	
	public static function isFile(path : String) : Bool
	{
		
		var exists : Bool = false;
		
		if(path != null)
		{
			exists = (neko.FileSystem.exists(path) && !neko.FileSystem.isDirectory(path));
		}
		
		return exists;
	}
	
	
	/**
	*  <p>Returns true if the given file has any of the extensions passed, false otherwise.</p>
	*  <p>Example: if you want to check if a file has either html or htm extension, you could try:</p>
	*  <p>[var isHtml = xa.File.hasExtension(path, \[".htm", ".html"\])].</p>
	*  <p>Extensions are case-insensitve (".txt" will match both .txt and .TXT).</p>
	**/  
	
	public static function hasExtension(path : String, extensions : Array<String>) : Bool
	{
		
		var name = xa.FileSystem.getNameFromPath(path);
		
		var w = extensions.join("|");
		var r = new EReg(w, 'i');
		
		return r.match(name);
		
	}
	
	/**
	* <p>Launches a given file with system's default application passing the parameters given.</p>
	* <p>For example, it will open html files with your default browser and pdf files with your pdf reader.</p> 
	**/
	
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
	
	/**
	* <p>Returns a std input object from which you can read the data of a binary file.</p> 
	**/
	
	public static function readBinary(path : String) : neko.io.FileInput
	{
		return neko.io.File.read(path, true);
	}
	
	/**
	* <p>Returns a std output object that you can use to write data to a binary file.</p> 
	**/
	
	public static function writeBinary(path : String) : neko.io.FileOutput
	{
		return neko.io.File.write(path, true);
	}
	
	/**
	* <p>Returns a std output object that you can use to append data to a binary file.</p> 
	**/
	
	public static function appendBinary(path : String) : neko.io.FileOutput
	{
		return neko.io.File.append(path, true);
	}
	
}