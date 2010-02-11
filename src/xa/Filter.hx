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
* <p>The Filter class offers predetermined filters for actions such as Folder.copy() and Search.search().</p> 
* <p>As a rule of thumb, when you build your own filters, you should return true when you want the given
* item to be copied or returned as part of the search, false otherwise.</p>
**/

package xa;

class Filter
{

	/**
	* <p>Returns true for all items.</p> 
	**/	
	
	public static var ALL : String -> Bool = function(path : String) : Bool
	{
		return true;
	}

	/**
	* <p>Returns false for all hidden files. Please see xa.FileSystem.isHidden for a full
	* explanation of how this works across different systems.</p>
	**/
	
	public static var ALL_BUT_HIDDEN : String -> Bool = function(path : String) : Bool
	{
		return !xa.FileSystem.isHidden(path);
	}
	
}