// thanks to https://alexandermonachino.com/ar-quick-look/

function enhanceWithARQuickLook() {
	
	// check for AR support
	const a = document.createElement('a');
	supportsAR = a.relList.supports('ar') ? true : false;
	
	// if the host device supports AR Quick Look...
	if ( supportsAR ) {

		const attr = 'data-ar-fp',
			  elements = document.querySelectorAll('['+attr+']');

		// if there are AR-ready links on the page...
		if ( elements.length > 0 ) {

			// convert AR-ready links
			for ( var i in elements ) {

				const instance = elements[i],
					  a = document.createElement('a');
				a.setAttribute('href', instance.getAttribute(attr));
				a.setAttribute('rel', 'ar');
				instance.removeAttribute(attr);
				instance.parentNode.insertBefore(a, instance);
				a.appendChild(instance);

			}

		}
		
	}
	
}

enhanceWithARQuickLook();