/**
********************************************************************************
Copyright 2017 cbCaptcha by Mark Skelton
www.compknowhow.com
********************************************************************************

Author:  Mark Skelton
Description:  Captcha interceptor to insert the captcha image
	and validate the captcha code on comment post
*/
component extends="coldbox.system.Interceptor" {

	// DI
	property name="captchaService"	inject="id:captchaService@cbCaptcha";
	property name="htmlHelper"		inject="HTMLHelper@coldbox";

	/**
	* Configure interceptor
	*/
	function configure(){
		return this;
	}

	/**
	* this needs to be added to comment form
	*/
	function cbui_postCommentForm( event, interceptData ){
		interceptData.commentForm &= captchaService.display() & "
			#htmlHelper.textField(
				name			= "captchacode",
				label			= "Enter the security code shown above:",
				required		= "required",
				class			= "form-control",
				groupWrapper	= "div class=form-group",
				size			= "50"
			)#
		";
	}

	/**
	* intercept comment post
	*/
	function cbui_preCommentPost( event, interceptData ){
		var rc = event.getCollection();

		if( structKeyExists(  rc, "captchacode" ) and !captchaService.validate( rc.captchacode ) ){
			arrayAppend( arguments.interceptData.commentErrors, "Invalid security code. Please try again." );
		}
	}
}
