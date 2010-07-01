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
	import flash.system.Capabilities;
	import flash.filesystem.File;

	public class System 
	{
		public static const LINUX : String = 'Linux';
		
		public static const MAC : String = 'Mac';
		
		public static const WIN : String = 'Windows';
		
		public static const WIN_SEPARATOR : String = "\\";
		
		public static const UNIX_SEPARATOR : String = '/';
		
		public static function isMac() : Boolean
		{
			return (-1 != getName().indexOf(MAC));
		}
		
		public static function isWindows() : Boolean
		{
			return (-1 != getName().indexOf(WIN));
		}
		
		public static function isLinux() : Boolean
		{
			return (-1 != getName().indexOf(LINUX));
		}
		
		public static function getName() : String
		{
			return Capabilities.os;
		}
		
		public static function getSeparator() : String
		{
			return (true == isWindows())? WIN_SEPARATOR : UNIX_SEPARATOR;
		}
		
		public static function getUserFolder() : String
		{
			return flash.filesystem.File.userDirectory.nativePath;
		}
		
		public static function getTempFolder() : String
		{
			var tmpFile : flash.filesystem.File = flash.filesystem.File.createTempFile();
			
			var path : String = tmpFile.nativePath.substr(0, tmpFile.nativePath.lastIndexOf(getSeparator()));
			
			tmpFile.deleteFile();
			tmpFile = null;
			
			return path;
		}
		
		public static function getAppDataFolder() : String
		{
			var bits : Array = flash.filesystem.File.applicationStorageDirectory.nativePath.split(getSeparator());
			return bits.slice(0, bits.length - 2).join(getSeparator());
		}
	}
}