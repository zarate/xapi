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

class System
{
	
	public static var WIN : String = "Windows";
	
	public static var MAC : String = "Mac";
	
	public static var LINUX : String = "Linux";
	
	public static var WIN_SEPARATOR:String = "\\";
	
	public static var UNIX_SEPARATOR:String = "/";
	
	public static function isMac() : Bool
	{
		return (getName() == MAC);
	}
	
	public static function isWindows() : Bool
	{
		return (getName() == WIN);
	}
	
	public static function isLinux() : Bool
	{
		return (getName() == LINUX);
	}
	
	public static function isUnix() : Bool
	{
		return (isMac() || isLinux());
	}
	
	public static function getName() : String
	{
		return neko.Sys.systemName();
	}
	
	public static function getSeparator() : String
	{
		return (isWindows())? WIN_SEPARATOR : UNIX_SEPARATOR;
	}
	
	public static function getUserFolder() : String
	{
		return (isWindows())? neko.Sys.getEnv("USERPROFILE") : neko.Sys.getEnv("HOME");
	}
	
	public static function getTempFolder() : String
	{
		
		var folder = "";
		
		switch(getName())
		{
			
			case WIN:
				
				folder = neko.Sys.getEnv("TEMP");
				
				if(folder == null)
				{
					folder = neko.Sys.getEnv("TMP");
				}
				
			case MAC:
				
				// TODO
				
			case LINUX: 
				
				folder = neko.Sys.getEnv("TMPDIR");
				
				if(folder == null)
				{
					folder = "/tmp";
				}
				
		}
		
		return folder;
		
	}
	
	public static function getAppDataFolder() : String
	{
		
		var folder = "";
		
		switch(getName())
		{
			
			case WIN:
				
				folder = neko.Sys.getEnv("APPDATA");
				
			case MAC:
				
				folder = getUserFolder() + "/Library/Application Support";
				
			case LINUX: 
				
				folder = neko.Sys.getEnv("HOME");
				
		}
		
		return folder;
		
	}
	
	public static function environment() : Hash<String>
	{
		return neko.Sys.environment();
	}
	
}