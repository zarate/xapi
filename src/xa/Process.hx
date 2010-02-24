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
* <p>Use the Process to launch and interact with other tools in the system (SVN, MTASC, commands such ls, etc.).</p>
* <p>See <a href="http://haxe.org/api/neko/io/process">neko.io.Process</a> for the full API and <a href="http://haxe.org/api/neko/io/process/examples">usage samples</a>.</p>
**/

package xa;

import xa.Backend;

class Process extends XAProcess
{

	/**
	* <p>Returns the standard error from the process.</p>
	**/
	
	public function getError() : String
	{
		return readStream(stderr);
	}
	
	/**
	* <p>Returns the standard output from the process.</p> 
	**/
	
	public function getOutput() : String
	{
		return readStream(stdout);
	}
	
	/**
	*  <p>Returns true if the exit code is 0, false otherwise.</p>
	*  <p>Please note that <strong>calling success() will block your app until the process has finished</strong>.</p>
	**/
	
	public function success() : Bool
	{
		return (exitCode() == 0);
	}
	
	/**
	*  <p>Returns process' exit code. If there are no errors, code is 0, more than 0 otherwise.</p>
	*  <p>Please note that <strong>calling exitCode() will block your app until the process has finished</strong>.</p>
	**/
	
	override public function exitCode() : Int
	{
		
		if(_code == null)
		{
			_code = super.exitCode();
		}
		
		return _code;
		
	}
	
	// -------
	
	/**
	*  <p>Reads a stream line by line until the end. to avoid problems reading long streams.</p>
	*  <p>Reading line by line in a loop prevents errors when the stream returned is too long.</p>
	**/
	
	private function readStream(stream : haxe.io.Input) : String
	{
		
		var s = '';
		
		while(true)
		{
			
			try
			{
				s += stream.readLine() + '\n';
			}
			catch(e : haxe.io.Eof)
			{
				break;
			}
			
		}
		
		stream.close();
		
		return s;
		
	}
	
	private var _code : Int;
	
}