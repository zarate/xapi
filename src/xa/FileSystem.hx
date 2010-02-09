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
* <p>The FileSystem class offers basic funcionality for both files and folders, including path formatting.</p>
**/

package xa;

class FileSystem
{
	
	/**
	* <p>Translates a path to the current OS.</p>
	**/
	
	public static function pathToCurrent(path : String) : String
	{
		return (xa.System.isWindows())? pathToWindows(path) : pathToUnix(path);
	}
	
	/**
	* <p>Translates a path to Unix.</p>
	**/
	
	public static function pathToUnix(path : String) : String
	{
		return path.split("\\").join(xa.System.UNIX_SEPARATOR);
	}
	
	/**
	* <p>Translates a path to Windows.</p>
	**/
	
	public static function pathToWindows(path : String) : String
	{
		return path.split("/").join(xa.System.WIN_SEPARATOR);
	}
	
	/**
	* <p>Checks wether a given path exists on the file system.</p>
	**/
	
	public static function exists(path : String) : Bool
	{
		return neko.FileSystem.exists(path);
	}
	
	/**
	* <p>Renames a file or folder to a new path. <strong>Please note that the nexPath must be absolute or relative, not only the new desired name</strong>.</p>
	**/
	
	public static function rename(path : String, newPath : String) : Void 
	{
		neko.FileSystem.rename(path, newPath);
	}
	
}