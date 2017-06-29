/* --------------------------------------------------------------------
Author 	 :	Tony Garcia
Date     :
Description :
 Displays a CAPTCHA image for form validation using ColdFusion 8 cfimage tag.
 The display() method displays the captcha image. If the user is returning to the form from a failed captcha validation (using
validate method), an error message also appears under the image, which can be customized by the 'message' argument.
 The validate() method is used in the event that handles the form and takes as an argument the form field value from the
 request collection in which the user entered the CAPTCHA code. It returns true if there is a match and false if not (and also
 sets a flag in the session scope to tell the object to display the error message if the user is redirected back to the form.)

This object is free to use and modify and is provided with NO WARRANTY of merchantability or fitness for a particular purpose.

Updates
06/28/2017 - Mark Skelton - Converted to cfscript, cleanup
11/16/2008 - Luis Majano - Cleanup
--------------------------------------------------------------------*/
/**
 * Create captchas
 */
component name="Captcha" hint="Create captchas" accessors="true" singleton {

	// ---------------------------------------- DEPENDENCIES ---------------------------------------

	property name="sessionStorage" inject="sessionStorage@cbStorages";

	// ---------------------------------------- CONSTRUCTOR ----------------------------------------

	public function init( sessionStorage ){
		variables.sessionStorage = arguments.sessionStorage;

		return this;
	}

	// ---------------------------------------- PUBLIC ----------------------------------------

	/**
	 * I display the captcha and an error message, if appropriate
	 */
	public function display(
		length="4",
		text="#makeRandomString( arguments.length )#",
		width="200",
		height="50",
		message="Please enter the correct code shown in the graphic."
	){
		var ret = "";
		setCaptchaCode( arguments.text );

		savecontent variable="ret" {
			cfimage( height=arguments.height, text=arguments.text, width=arguments.width, action="captcha" );

			if ( !isValidated() ){
				writeOutput( "<br><span class=""cb_captchamessage"">#arguments.message#</span>" );
			}
		}

		/*  after it's decided whether to display the error message,
		clear the validation flag in case user just navigates to another page and comes back */
		setValidated( true );
		return ret;
	}

	/**
	 * I validate the passed in against the captcha code
	 */
	public function validate( required code ){
		if ( hash( lcase( arguments.code ), "SHA" ) == getCaptchaCode() ){
			clearCaptcha();
			//  delete the captcha struct
			return true;
		} else {
			setValidated( false );
			return isValidated();
		}
	}

	public function setCaptchaCode( required captchastring ){
		getCaptchaStorage().captchaCode = hash( lcase( arguments.captchastring ), "SHA" );
	}

	public function getCaptchaCode(){
		return getCaptchaStorage().captchaCode;
	}

	// ---------------------------------------- PRIVATE ----------------------------------------

	private function getCaptchaStorage(){
		var captcha = { captchaCode = "", validated = true };

		if ( !variables.sessionStorage.exists( "cb_captcha" ) ){
			variables.sessionStorage.setVar( "cb_captcha", captcha );
		}

		return variables.sessionStorage.getVar( "cb_captcha" );
	}

	private function setValidated( required validated ){
		getCaptchaStorage().validated = arguments.validated;
	}

	private function isValidated(){
		return getCaptchaStorage().validated;
	}

	private function clearCaptcha(){
		variables.sessionStorage.deleteVar( "cb_captcha" );
	}

	private function makeRandomString( length="4" ){
		var min = arguments.length - 1;
		var max = arguments.length + 1;
		/*  Function ripped of from Raymond Camden
		( http://www.coldfusionjedi.com/index.cfm/2008/3/29/Quick-and-Dirty-ColdFusion-8-CAPTCHA-Guide )
		*/
		var chars = "23456789ABCDEFGHJKMNPQRSabcdefghjkmnpqrs";
		var captchalength = randRange( min, max );
		var result = "";
		var i = "";
		var char = "";

		for( i = 1; i <= captchalength; i++ ){
			char = mid( chars, randRange( 1, len( chars ) ), 1 );
			result &= char;
		}

		return result;
	}
}
