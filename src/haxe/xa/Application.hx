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
*  <p>The Application class provides access to basic information about your application. </p> 
**/

package xa;

import xa.Backend;

class Application
{
	
	/**
	* <p>Returns the full path to the folder where your application is located.</p>
	* <p>If you are planning to use this folder to store data, please read <a href="http://www.codinghorror.com/blog/archives/001032.html">Don't polute the user space</a>.</p> 
	**/
	
	public static function getFolder() : String
	{
		var path = getPath();
		return path.substr(0, path.lastIndexOf(xa.System.getSeparator()));
	}
	
	/**
	* <p>Returns the full path of your application's executable.</p>
	* <p>Internal Neko call is <a href="http://haxe.org/api/neko/sys">neko.Sys.executablePath()</a>.</p> 
	**/
	
	public static function getPath() : String
	{
		return XASys.executablePath();
	}
	
	/**
	* <p>Returns an array of strings with the parameters passed to your application.</p>
	* <p>Internal Neko call is <a href="http://haxe.org/api/neko/sys">neko.Sys.args()</a>.</p>  
	**/
	
	public static function getArguments() : Array<String>
	{
		return XASys.args();
	}
	
	/**
	* <p>Terminates the application with the provided exit code.</p>
	* <p>Use 0 if everything went ok and 1 or above depending on your error. You can read more about
	*  exit code conventions in <a href="http://tldp.org/LDP/abs/html/exit-status.html">Exit Status</a> and
	*  <a href="http://tldp.org/LDP/abs/html/exitcodes.html">Exit Codes</a>.</p>
	**/
	
	public static function exit(code : Int) : Void
	{
		XASys.exit(code);
	}
	
	/**
	* <p>Terminates the application with the provided exit error message. Default error code is 1.</p>
	* <p>This is just a shortcut to [xa.Utils.print(message)] combined with [xa.Application.exit(code)].</p>
	**/
	
	public static function exitError(message : String, ?code : Int = 1) : Void
	{
		xa.Utils.printError(message);
		exit(code);
	}
	
}