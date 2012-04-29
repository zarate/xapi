import massive.munit.Assert;

class FileRemoveTest
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
	public function simple_remove()
	{
		var sourceFilePath = TestUtils.getTmpFile();
		
		xa.File.write(sourceFilePath, "wadus");
		
		xa.File.remove(sourceFilePath);
		
		Assert.isFalse(xa.File.isFile(sourceFilePath));
	}
	
	@Test
	public function remove_folder()
	{
		var sourceFolderPath = TestUtils.getTmpFolder();
		
		xa.Folder.create(sourceFolderPath);
		
		var result = false;
		
		try
		{
			xa.File.remove(sourceFolderPath);
			result = true;
		}
		catch(e : Dynamic){}
		
		Assert.isFalse(result);
	}
}
