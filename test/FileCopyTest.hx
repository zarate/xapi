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
		var originalFile = TestUtils.getTmpFile();
		
		xa.File.write(originalFile, "hello world " + Std.random(5000));
		
		var copyFileFullPath = haxe.io.Path.directory(originalFile) + xa.System.getSeparator() + "tmp-" + Std.random(10000);
		
		if(xa.File.isFile(copyFileFullPath)) // very unlikely, but you never know
		{
			xa.File.remove(copyFileFullPath);
		}
		
		xa.File.copy(originalFile, copyFileFullPath);
		
		// copy exists and content is the same
		Assert.isTrue(xa.File.isFile(copyFileFullPath) && (xa.File.read(originalFile) == xa.File.read(copyFileFullPath)));
	}
}
