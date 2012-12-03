import massive.munit.TestResult;
import massive.munit.ITestResultClient;

class XapiClient implements massive.munit.IAdvancedTestResultClient
{
	public var completionHandler (get_completeHandler, set_completeHandler) : ITestResultClient -> Void;

	public var id (default, null) : String = "XapiClient";

	public function new()
	{
	}

	public function addPass(result : TestResult) : Void
	{
		log("PASS: " + result.className + "." + result.name);
	}

	public function addFail(result : TestResult) : Void
	{
		log("FAIL: " + result.className + "." + result.name);
	}

	public function addError(result : TestResult) : Void
	{
		log("ERROR: " + result.className + "." + result.name);
	}

	public function addIgnore(result : TestResult) : Void
	{
		log("IGNORE: " + result.className + "." + result.name);
	}

	public function reportFinalStatistics(testCount : Int, passCount : Int, failCount : Int, errorCount : Int, ignoreCount : Int, time : Float) : Dynamic
	{
		log("FINAL");
		log("TESTS: " + testCount);
		log("PASS: " + passCount);
		log("FAIL: " + failCount);
		log("ERROR: " + errorCount);
		log("IGNORE: " + ignoreCount);
		log("TIME: " + time + "ms");
	}

	public function setCurrentTestClass(className : String) : Void
	{
		log("CURRENT CLASS: " + className);
	}

	function log(txt : String) : Void
	{
		#if flash

			var file = new flash.filesystem.File("/dev/stdout");
			
			var stream = new flash.filesystem.FileStream();
			stream.open(file, flash.filesystem.FileMode.WRITE);
			stream.writeUTFBytes(txt + "\n");
			stream.close();
			
			file = null;
			stream = null;

		#else

			xa.Utils.print(txt);

		#end
	}

	function get_completeHandler() : ITestResultClient -> Void
	{
		return completionHandler;
	}

	function set_completeHandler(value : ITestResultClient -> Void) : ITestResultClient -> Void
	{
		completionHandler = value;
		return completionHandler;
	}
}