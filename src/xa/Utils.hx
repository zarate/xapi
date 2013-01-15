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
* <p>Provides simple helper methods.</p>
**/

package xa;
class Utils
{
	/**
	* <p>Prints out to the standard output (automatically adds a line break).</p>
	**/
	public static function print(txt : String) : Void
	{
		#if flash

			var stdout = new flash.filesystem.FileStream();
			stdout.open(new flash.filesystem.File("/dev/stdout"), flash.filesystem.FileMode.WRITE);
			stdout.writeUTFBytes(txt + "\n");
			stdout.close();

		#else

			Sys.stdout().writeString(txt + '\n');
		
		#end
	}
	
	/**
	* <p>Prints out to the standard error (automatically adds a line break).</p>
	**/
	public static function printError(txt : String) : Void
	{
		#if flash

			var stderr = new flash.filesystem.FileStream();
			stderr.open(new flash.filesystem.File("/dev/stderr"), flash.filesystem.FileMode.WRITE);
			stderr.writeUTFBytes(txt + "\n");
			stderr.close();

		#else

			Sys.stderr().writeString(txt + '\n');

		#end
	}
}