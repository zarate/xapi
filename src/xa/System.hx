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
	* <p>Windows system identifier.</p>
	**/
	public static var WIN (default, null) : String = "Windows";
	
	/**
	* <p>Mac system identifier.</p>
	**/
	public static var MAC (default, null) : String = "Mac";
	
	/**
	* <p>Linux system identifier.</p>
	**/
	public static var LINUX (default, null) : String = "Linux";
	
	/**
	* <p>Folder separator for Windows systems ("\").</p>
	**/
	public static var WIN_SEPARATOR (default, null) : String = "\\";
	
	/**
	* <p>Folder separator for Unix systems ("/").</p>
	**/
	public static var UNIX_SEPARATOR (default, null) : String = "/";
	
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
	*  <p>Returns system name: "Windows", "Mac" or "Linux".</p>
	**/
	public static function getName() : String
	{
		#if flash

		var name = null;

		var version = flash.system.Capabilities.version;

		var ereg = ~/(^[a-z]+)/i;

		if(ereg.match(version))
		{
			name = switch(ereg.matched(1))
			{
				case "WIN": WIN;
				case "MAC": MAC;
				case "LNX": LINUX;
				default : ereg.matched(1);
			}
		}

		return name;

		#else

		return Sys.systemName();

		#end
	}
	
	/**
	*  <p>Returns current's system separator.</p>
	**/
	public static function getSeparator() : String
	{
		return (isWindows())? WIN_SEPARATOR : UNIX_SEPARATOR;
	}
	
	#if (neko || cpp)

	/**
	*  <p>Returns user's folder.</p>
	*  <p>In Windows returns the value of %USERPROFILE% and in Mac and Linux returns the value of $HOME.</p>
	*  <p>Please read first <a href="http://www.codinghorror.com/blog/archives/001032.html">Don't polute the user space</a> 
	*  in case you are planning to write files in the user folder.</p>
	**/
	public static function getUserFolder() : String
	{
		return (isWindows())? getEnvironment("USERPROFILE") : getEnvironment("HOME");
	}
	
	/**
	*  <p>Returns systems's temp folder.</p>
	*  <p>In Windows returns the value of %TEMP% or %TMP%. in Linux returns the value of $TMPDIR if exists, /tmp otherwise. In Macs returns the value of $TMPDIR.</p>
	**/
	public static function getTempFolder() : String
	{
		var folder = "";
		
		switch(getName())
		{
			case WIN:
				
				folder = getEnvironment("TEMP");
				
				if(folder == null)
				{
					folder = getEnvironment("TMP");
				}
				
			case MAC:
				
				folder = getEnvironment("TMPDIR");
				
			case LINUX: 
				
				folder = getEnvironment("TMPDIR");
				
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
	*  <p>Please note that is standard across Linux systems writing application data to the user folder, usually in a hidden folder such as ".appName".</p>
	**/
	public static function getAppDataFolder() : String
	{
		var folder = "";
		
		switch(getName())
		{
			case WIN:
				
				folder = getEnvironment("APPDATA");
				
			case MAC:
				
				folder = getUserFolder() + "/Library/Application Support";
				
			case LINUX: 
				
				folder = getEnvironment("HOME");
				
		}
		
		return folder;
	}

	/**
	*  <p>Returns the name of the current host system.</p>
	**/
	public static function getHostName() : String
	{
		var hostname : String;
		
		if(isUnix())
		{
			var p = new xa.Process('hostname', ['-s']);
			hostname = p.getOutput();
		}
		else
		{
			var p = new xa.Process('hostname', []);
			hostname = p.getOutput();
			p.close();
		}
		
		return hostname;
	}

	/**
	*  <p>Returns a hash containing systems's environment variables.</p>
	**/
	public static function environment() : Hash<String>
	{
		return Sys.environment();
	}

	private static function getEnvironment(name : String) : String
	{
		return Sys.getEnv(name);
	}

	#end
}