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
	
	public static function getTmpFile(?filename : String) : String
	{
		if(null == filename)
		{
			filename = "tmp-" + Std.random(10000);
		}
		
		if(xa.File.isFile(filename))
		{
			xa.File.remove(filename);
		}
		
		return _tmpFolder + xa.System.getSeparator() + filename;
	}
}
