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
* <p>Provides information about the system.</p>
**/

package xa;

class System
{

	/**
	* <p>Windows system id.</p>
	**/
	
	public static var WIN : String = "Windows";
	
	/**
	* <p>Mac system id.</p>
	**/
	
	public static var MAC : String = "Mac";
	
	/**
	* <p>Linux system id.</p>
	**/
	
	public static var LINUX : String = "Linux";
	
	/**
	* <p>Folder separator for Windows systems "\".</p>
	**/
	
	public static var WIN_SEPARATOR:String = "\\";
	
	/**
	* <p>Folder separator for Unix systems "/".</p>
	**/
	
	public static var UNIX_SEPARATOR:String = "/";
	
	/**
	*  <p>Returns true if the system is Mac.</p>
	**/
	
	public static function isMac() : Bool
	{
		return (getName() == MAC);
	}
	
	/**
	*  <p>Returns true if the system is Windows.</p>
	**/
	
	public static function isWindows() : Bool
	{
		return (getName() == WIN);
	}
	
	/**
	*  <p>Returns true if the system is Linux.</p>
	**/
	
	public static function isLinux() : Bool
	{
		return (getName() == LINUX);
	}
	
	/**
	*  <p>Returns true if the system is either Mac or Linux.</p>
	**/
	
	public static function isUnix() : Bool
	{
		return (isMac() || isLinux());
	}
	
	/**
	*  <p>Returns system name: Windows, Mac or Linux.</p>
	**/
	
	public static function getName() : String
	{
		return neko.Sys.systemName();
	}
	
	/**
	*  <p>Returns current's system separator.</p>
	**/
	
	public static function getSeparator() : String
	{
		return (isWindows())? WIN_SEPARATOR : UNIX_SEPARATOR;
	}
	
	/**
	*  <p>Returns user's folder.</p>
	*  <p>In Windows returns the value of %USERPROFILE% and in Mac and Linux returns the value of $HOME.</p>
	*  <p>Please read first <a href="">Don't polute the user space</a> in case you are planning to write files in the user folder.</p>
	**/
	
	public static function getUserFolder() : String
	{
		return (isWindows())? neko.Sys.getEnv("USERPROFILE") : neko.Sys.getEnv("HOME");
	}
	
	/**
	*  <p>Returns systems's temp folder.</p>
	*  <p>In Windows returns the value of %TEMP% or %TEMP%. in Linux returns the value of $TMPDIR if exists, /tmp otherwise. <strong>Not ready for Macs yet</strong>.</p>
	**/
	
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
	
	/**
	*  <p>Returns systems's applications data folder.</p>
	*  <p>In Windows returns the value of %APPDATA%. in Linux returns the value of $HOME and Macs $HOME + "/Library/Application Support".</p>
	*  <p>Please note that is standard across Linux system writing application data to the user folder, usually	in a hidden folder such as ".appName".</p>
	**/
	
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
	
	/**
	*  <p>Returns a hash containing systems's environment variables.</p>
	**/
	
	public static function environment() : Hash<String>
	{
		return neko.Sys.environment();
	}
	
}