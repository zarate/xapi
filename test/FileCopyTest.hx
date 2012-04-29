import massive.munit.Assert;

class FileCopyTest
{
	@BeforeClass
	public function setup()
	{
		TestUtils.createTempFolder();
	}
	
	@AfterClass
	public function tearDown()
	{
		TestUtils.removeTempFolder();
	}
	
	@Test
	public function simple_copy()
	{
		var sourceFilePath = TestUtils.getTmpFile();
		
		xa.File.write(sourceFilePath, "hello world " + Std.random(5000));
		
		var destinationFilePath = haxe.io.Path.directory(sourceFilePath) + xa.System.getSeparator() + "tmp-" + Std.random(10000);
		
		xa.File.copy(sourceFilePath, destinationFilePath);
		
		// copy exists and content is the same
		Assert.isTrue(xa.File.isFile(destinationFilePath) && (xa.File.read(sourceFilePath) == xa.File.read(destinationFilePath)));
	}
	
	@Test
	public function destination_file_already_exists()
	{
		var sourceFilePath = TestUtils.getTmpFile();
		
		xa.File.write(sourceFilePath, "hello world " + Std.random(5000));
		
		var destinationFilePath = haxe.io.Path.directory(sourceFilePath) + xa.System.getSeparator() + "tmp-" + Std.random(10000);
		
		// let's create the destination file
		xa.File.write(destinationFilePath, "wadus");		
		
		// now the copy
		xa.File.copy(sourceFilePath, destinationFilePath);
		
		// end of the day, copy exists and content is the same
		Assert.isTrue(xa.File.isFile(destinationFilePath) && (xa.File.read(sourceFilePath) == xa.File.read(destinationFilePath)));
	}
	
	@Test
	public function missing_destination_file()
	{
		var sourceFilePath = TestUtils.getTmpFile();
		
		xa.File.write(sourceFilePath, "hello world " + Std.random(5000));
		
		var destFileFolder = haxe.io.Path.directory(sourceFilePath) + xa.System.getSeparator() + "wadus-" + Std.random(10000);
		
		if(xa.Folder.isFolder(destFileFolder))
		{
			xa.Folder.forceRemove(destFileFolder);
		}
		
		var result = false;
		
		try
		{
			xa.File.copy(sourceFilePath, destFileFolder + xa.System.getSeparator() + "wadus");
			result = true;
		}
		catch(e : Dynamic){}
		
		Assert.isFalse(result);
	}
	
	@Test
	public function missing_source_file()
	{
		var result = false;
		
		var randomFilePath = "wadus-" + Std.random(1000);
		
		if(xa.File.isFile(randomFilePath))
		{
			xa.File.remove(randomFilePath);
		}
		
		try
		{
			xa.File.copy(randomFilePath, TestUtils.getTmpFile());
			result = true;
		}
		catch(e : Dynamic){}
		
		Assert.isFalse(result);
	}
	
	@Test
	public function null_source()
	{
		var result = false;
		
		try
		{
			xa.File.copy(null, "");
			result = true;
		}
		catch(e : Dynamic){}
		
		Assert.isFalse(result);
	}
	
	@Test
	public function null_destination()
	{
		var result = false;
		
		try
		{
			xa.File.copy("", null);
			result = true;
		}
		catch(e : Dynamic){}
		
		Assert.isFalse(result);
	}
}
