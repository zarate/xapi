import massive.munit.TestRunner;

/**
 * Auto generated Test Application.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestMain
{
	static function main()
	{	
		new TestMain(); 
	}

	function new()
	{
		var suites = new Array<Class<massive.munit.TestSuite>>();
		suites.push(TestSuite);

		var runner = new TestRunner(new XapiClient());
		runner.run(suites);
	}
}
