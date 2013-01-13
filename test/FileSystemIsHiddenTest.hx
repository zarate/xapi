import massive.munit.Assert;

class FileSystemIsHiddenTest
{
	@BeforeClass
	function setup()
	{
		TestUtils.createTempFolder();
	}
	
	@AfterClass
	function tearDown()
	{
		TestUtils.removeTempFolder();
	}

	@Test
	function check_non_hidden_file()
	{
		var tmpfile = TestUtils.getTmpFile();
		Assert.isFalse(xa.FileSystem.isHidden(tmpfile));
	}

	@Test
	function check_hidden_file()
	{
		var tmpfile = TestUtils.getTmpFile(".wadus");
		Assert.isTrue(xa.FileSystem.isHidden(tmpfile));
	}
}