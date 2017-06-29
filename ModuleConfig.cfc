/**
********************************************************************************
Copyright 2017 cbCaptcha by Mark Skelton
www.compknowhow.com
********************************************************************************

Author:  Mark Skelton
Description:  Module configuration
*/
component {

	// Module Properties
	this.title 				= "cbCaptcha";
	this.author 			= "Mark Skelton";
	this.webURL 			= "https://compknowhow.com";
	this.description 		= "Generates a captcha image for your website's comment forms";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbCaptcha";

	function configure(){

		// SES Routes
		routes = [
			// Convention Route
			{pattern="/:handler/:action?"}
		];

		// Custom Declared Interceptors
		interceptors = [
			{ class="#moduleMapping#.interceptors.captcha" }
		];
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){

	}

	/**
	* Fired when the module is activated by ContentBox
	*/
	function onActivate(){

	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

	/**
	* Fired when the module is deactivated by ContentBox
	*/
	function onDeactivate(){

	}
}
