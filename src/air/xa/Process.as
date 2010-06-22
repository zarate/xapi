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
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	
	import flash.filesystem.File;
	
	import flash.events.NativeProcessExitEvent;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;

	public class Process extends EventDispatcher
	{
		public function Process(cmd : String, args : Vector.<String> = null)
		{
			// http://help.adobe.com/en_US/as3/dev/WSb2ba3b1aad8a27b060d22f991220f00ad8a-8000.html
			
			process = new NativeProcess();
			
			info = new NativeProcessStartupInfo();
			
			info.arguments = args;
			info.executable = new flash.filesystem.File(cmd);
			
			process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutput);
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onError);
			
			process.start(info);
		}
		
		public function getError() : String
		{
			return error;
		}
		
		public function getOutput() : String
		{
			return output;
		}
		
		public function success() : Boolean
		{
			return (0 == _exitCode);
		}
		
		public function exitCode() : Number
		{
			return _exitCode;
		}
		
		private function onOutput(event : ProgressEvent) : void
		{
			if(null == output)
			{
				output = '';
			}
			
			output += process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
		}
		
		private function onError(event : ProgressEvent) : void
		{
			if(null == error)
			{
				error = '';
			}

			error += process.standardError.readUTFBytes(process.standardError.bytesAvailable);
		}
		
		private function onExit(event : NativeProcessExitEvent) : void
		{
			_exitCode = event.exitCode;	
			dispatchEvent(event);
		}
		
		private var _exitCode : Number;
		
		private var error : String;
		
		private var output : String;
		
		private var process : NativeProcess;
		
		private var info : NativeProcessStartupInfo;
	}
}