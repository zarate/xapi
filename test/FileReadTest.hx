import massive.munit.Assert;

class FileReadTest
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
	function read_test()
	{
		var path = TestUtils.getTmpFile();

		xa.File.write(path, "wadus");

		Assert.areEqual("wadus", xa.File.read(path));
	}
}