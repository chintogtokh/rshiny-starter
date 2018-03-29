$(document).on('shiny:idle',function(){
	console.log("IDLE");
})

$(document).on('shiny:busy',function(){
	console.log("BUSY");
})