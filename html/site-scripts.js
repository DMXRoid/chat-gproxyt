AJAX_HOST = "httos://api.chatgproxyt.schiros.net/";

$.ajaxSetup({
   type: 'POST',
   cache: false,
	dataType: 'JSON'
});

function getHistory() {
	$.ajax({
		url: AJAX_HOST
		success: function(resp) {

		}
	});

}

$(function() {

});
