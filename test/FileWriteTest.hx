import massive.munit.Assert;
import haxe.unit.TestRunner;

class FileWriteTest
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
	public function simple_write()
	{
		var filepath = TestUtils.getTmpFile();
				
		var txt = "hello world";
		
		xa.File.write(filepath, txt);
		
		Assert.isTrue(xa.File.read(filepath) == txt);
	}
	
	@Test
	public function line_breaks()
	{
		var filepath = TestUtils.getTmpFile();
		
		xa.File.write(filepath, "one\ntwo\nthree"); //FIXME: doubt this is cross-platform
		
		Assert.isTrue(xa.File.read(filepath).split("\n").length == 3);
	}
	
	@Test
	public function empty_path()
	{
		var result = false;
		
		try
		{
			xa.File.write("", "");
			result = true;
		}
		catch(e : Dynamic){}
		
		Assert.isFalse(result);
	}	
	
	@Test
	public function null_path()
	{
		var result = true;
		
		try
		{
			xa.File.write(null, "");
			result = false;
		}
		catch(e : Dynamic){}
		
		Assert.isTrue(result);
	}
	
	@Test
	public function null_content()
	{
		var result = true;
		
		try
		{
			xa.File.write(TestUtils.getTmpFile(), null);
			result = false;
		}
		catch(e : Dynamic){}
		
		Assert.isTrue(result);
	}
}