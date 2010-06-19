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
* <p>Provides search functionality over system items.</p> 
**/

package xa;

class Search
{
	
	/**
	* <p>Searches for items in the given folder path.</p>
	* <p>Similar to the [xa.Folder.copy()] method, you can exclude items from the search using a filter function matching the String -> Bool signature.
	* The filter function will get called once per item, receiving the path of each item. It should return true to include the item in the
	* search result or false otherwise. You can use predefined filters in the Filter class or roll your own.</p>
	* <p>The search is fully recursive by default (deep = -1). To search <strong>only</strong> the items in the root of the folder, pass 0 for the deep parameter.
	* If you want to search for items in the root and the next level, pass 1. To search for items in root + first and second levels, past 2, etc.</p> 
	**/
	
	public static function search(folderPath : String, ?filter : String -> Bool, ?deep : Int = -1) : Array<String>
	{
		// We use an internal privateSearch function to keep search public signature clean (without currentLevel counter)
		return privateSearch(folderPath, filter, deep, 0);
	}
	
	// ---------------------------- 
	
	private static function privateSearch(folderPath : String, ?filter : String -> Bool, ?deep : Int = -1, ?currentLevel : Int = 0) : Array<String>
	{
		
		if(filter == null)
		{
			filter = xa.Filter.ALL;
		}
		
		var systemSeparator = xa.System.getSeparator();
		
		var foundItems = new Array<String>();
		
		var items = xa.Folder.read(folderPath);
		
		for(itemName in items)
		{
			
			var itemPath = folderPath + systemSeparator + itemName;
			
			if(filter(itemPath))
			{
				
				foundItems.push(itemPath);
				
				if(deep == -1 || (currentLevel < deep))
				{
				
					if(xa.Folder.isFolder(itemPath))
					{
					
						currentLevel++;
						var recursiveItems = privateSearch(itemPath, filter, deep, currentLevel);
						foundItems = foundItems.concat(recursiveItems);
										
					}
				
				}
				
			}
			
		}
		
		return foundItems;
		
	}
	
}