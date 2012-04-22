import massive.munit.Assert;

class FileHasExtensionTest 
{
	var _tmpFolder : String;
	
	@BeforeClass
	public function setup()
	{
		_tmpFolder = xa.System.getTempFolder() + xa.System.getSeparator() + "xapi-test-" + Std.random(10000);
		
		xa.Folder.create(_tmpFolder);
	}
	
	@AfterClass
	public function tearDown()
	{
		xa.Folder.forceDelete(_tmpFolder);
	}
	
	@Test
	public function single_extension_positive()
	{
		var filepath = getTmpFile("wadus.html");
		
		xa.File.write(filepath, "");
		
		var extensions = ["html"];
		
		Assert.isTrue(xa.File.hasExtension(filepath, extensions));
	}
	
	@Test
	public function single_extension_positive_case_insensitive()
	{
		var filepath = getTmpFile("wadus.html");
		
		xa.File.write(filepath, "");
		
		var extensions = ["HTML"];
		
		Assert.isTrue(xa.File.hasExtension(filepath, extensions));		
	}
	
	@Test
	public function single_extension_with_dot()
	{
		var filepath = getTmpFile("wadus.html");
		
		xa.File.write(filepath, "");
		
		var extensions = [".html"];
		
		Assert.isFalse(xa.File.hasExtension(filepath, extensions));
	}
	
	@Test
	public function multiple_extensions_positive()
	{
		var filepath = getTmpFile("wadus.html");
		
		xa.File.write(filepath, "");
		
		var extensions = ["txt", "doc", "html"];
		
		Assert.isTrue(xa.File.hasExtension(filepath, extensions));
	}
	
	@Test
	public function extension_in_name()
	{
		var filepath = getTmpFile("html.doc");
		
		xa.File.write(filepath, "");
		
		var extensions = ["html"];
		
		Assert.isFalse(xa.File.hasExtension(filepath, extensions));
	}
	
	@Test
	public function single_partial_extension_negative()
	{
		var filepath = getTmpFile("wadus.html");
		
		xa.File.write(filepath, "");
		
		var extensions = ["htm"];
		
		Assert.isFalse(xa.File.hasExtension(filepath, extensions));
	}
	
	@Test
	public function file_no_extension()
	{
		var filepath = getTmpFile("wadus");
		
		xa.File.write(filepath, "");
		
		var extensions = ["htm"];
		
		Assert.isFalse(xa.File.hasExtension(filepath, extensions));
	}
	
	@Test
	public function null_array_of_extensions()
	{
		var filepath = getTmpFile("wadus");
		
		xa.File.write(filepath, "");
		
		Assert.isFalse(xa.File.hasExtension(filepath, null));
	}
	
	@Test
	public function empty_array_of_extensions()
	{
		var filepath = getTmpFile("wadus");
		
		xa.File.write(filepath, "");
		
		Assert.isFalse(xa.File.hasExtension(filepath, []));		
	}
	
	function getTmpFile(filename : String) : String
	{
		return _tmpFolder + xa.System.getSeparator() + filename;
	}
}