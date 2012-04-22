import massive.munit.Assert;

class FileIsFileTest
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
	public function file_positive()
	{
		var tmpfile = TestUtils.getTmpFile();
		
		xa.File.write(tmpfile, "");
		
		Assert.isTrue(xa.File.isFile(tmpfile));
	}
	
	@Test
	public function file_negative()
	{
		var tmpFolder = TestUtils.getTmpFolder();
		
		Assert.isFalse(xa.File.isFile(tmpFolder));
	}
	
	@Test
	public function empty_path()
	{
		Assert.isFalse(xa.File.isFile(""));
	}
	
	@Test
	public function null_path()
	{
		var result = true;
		
		try
		{
			xa.File.isFile(null);
			result = false;
		}
		catch(e : Dynamic){}
		
		Assert.isTrue(result);
	}
}