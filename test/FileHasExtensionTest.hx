import massive.munit.Assert;

class FileHasExtensionTest 
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
	public function single_extension_positive()
	{
		var filepath = TestUtils.getTmpFile("wadus.html");
		
		xa.File.write(filepath, "");
		
		var extensions = ["html"];
		
		Assert.isTrue(xa.File.hasExtension(filepath, extensions));
	}
	
	@Test
	public function single_extension_positive_case_insensitive()
	{
		var filepath = TestUtils.getTmpFile("wadus.html");
		
		xa.File.write(filepath, "");
		
		var extensions = ["HTML"];
		
		Assert.isTrue(xa.File.hasExtension(filepath, extensions));		
	}
	
	@Test
	public function single_extension_with_dot()
	{
		var filepath = TestUtils.getTmpFile("wadus.html");
		
		xa.File.write(filepath, "");
		
		var extensions = [".html"];
		
		Assert.isFalse(xa.File.hasExtension(filepath, extensions));
	}
	
	@Test
	public function multiple_extensions_positive()
	{
		var filepath = TestUtils.getTmpFile("wadus.html");
		
		xa.File.write(filepath, "");
		
		var extensions = ["txt", "doc", "html"];
		
		Assert.isTrue(xa.File.hasExtension(filepath, extensions));
	}
	
	@Test
	public function extension_in_name()
	{
		var filepath = TestUtils.getTmpFile("html.doc");
		
		xa.File.write(filepath, "");
		
		var extensions = ["html"];
		
		Assert.isFalse(xa.File.hasExtension(filepath, extensions));
	}
	
	@Test
	public function single_partial_extension_negative()
	{
		var filepath = TestUtils.getTmpFile("wadus.html");
		
		xa.File.write(filepath, "");
		
		var extensions = ["htm"];
		
		Assert.isFalse(xa.File.hasExtension(filepath, extensions));
	}
	
	@Test
	public function file_no_extension()
	{
		var filepath = TestUtils.getTmpFile("wadus");
		
		xa.File.write(filepath, "");
		
		var extensions = ["htm"];
		
		Assert.isFalse(xa.File.hasExtension(filepath, extensions));
	}
	
	@Test
	public function null_array_of_extensions()
	{
		var filepath = TestUtils.getTmpFile("wadus");
		
		xa.File.write(filepath, "");
		
		Assert.isFalse(xa.File.hasExtension(filepath, null));
	}
	
	@Test
	public function empty_array_of_extensions()
	{
		var filepath = TestUtils.getTmpFile("wadus");
		
		xa.File.write(filepath, "");
		
		Assert.isFalse(xa.File.hasExtension(filepath, []));		
	}	
}