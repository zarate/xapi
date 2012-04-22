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
* <p>Filters files based on its extension.</p>
* <p>It internally uses [xa.File.hasExtension()], see for more info.</p>
* <p>It allows all folders.</p>
**/

package xa.filters;

import xa.filters.IFilter;

class ExtensionFilter implements IFilter
{
	/**
	* @param extensions Array of extensions to filter
	* @param allow True if the files with the given extensions should be included, false otherwise.
	* 
	* @see xa.File#hasExtension()
	**/
	public function new(extensions : Array<String>, allow : Bool)
	{
		this.extensions = extensions;
		this.allow = allow;
	}
	
	/**
	* @inheritdoc
	**/
	public function filter(path : String) : Bool
	{
		var include = false;
		
		if(xa.File.isFile(path))
		{
			var hasExtension = xa.File.hasExtension(path, extensions);
			include = (allow)? hasExtension : !hasExtension;
		}
		else
		{
			include = true;
		}
		
		return include;
	}
	
	private var extensions : Array<String>;
	
	private var allow : Bool;
}