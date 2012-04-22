class TestUtils
{
	static var _tmpFolder : String;
	
	public static function createTempFolder() : String
	{
		_tmpFolder = xa.System.getTempFolder() + xa.System.getSeparator() + "xapi-test-" + Std.random(10000);
		
		if(xa.Folder.isFolder(_tmpFolder))
		{
			xa.Folder.forceRemove(_tmpFolder);
		}
		
		xa.Folder.create(_tmpFolder);
		
		return _tmpFolder;
	}
	
	public static function removeTempFolder() : Void
	{
		xa.Folder.forceRemove(_tmpFolder);
	}
	
	public static function getTmpFolder(?name : String) : String
	{
		if(null == name)
		{
			name = "tmp-folder-" + Std.random(10000);
		}
		
		var fullpath = _tmpFolder + xa.System.getSeparator() + name;
		
		if(xa.Folder.isFolder(fullpath))
		{
			xa.Folder.forceRemove(fullpath);
		}
		
		return fullpath;
	}
		
	public static function getTmpFile(?name : String) : String
	{
		if(null == name)
		{
			name = "tmp-" + Std.random(10000);
		}
		
		var fullpath = _tmpFolder + xa.System.getSeparator() + name;
		
		if(xa.File.isFile(fullpath))
		{
			xa.File.remove(fullpath);
		}
		
		return fullpath;
	}
}
