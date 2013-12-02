$(function (){
	$('.auto').unbind('keyup').bind('keyup',function(){
		var field = $(this).attr('id');
		$.ajax({
			url: "search.php",
			method:"post",
			cache: false,
			data: {
				action: "autoComplete",
				sender: field,
				fragment: $(this).val()
			},
			success:function(data){	
				renderResult(data);
			},
			error:function(errorData){
				alert(
				"There seems to be an error:\n"
				);
			}
		});
	});

	$('input[type="button"]').click(function(){
		
		var action = $(this).attr('action');
		var submit = {}, stop = false;


		$('.add').each(function(){
			if (this.value != "") {
				submit[this.id] = this.value;
			} 
			else if (action == "addBook") {
				stop = true;
			}
		});

		$.ajax({
			url: action == "addBook" ? "update.php" : "search.php",
			method: "post",
			cache: false,
			data: {
				action: action,
				fields: submit,
				employee: 1,	 // test-value. Set this from select-menu
				type: "'change'" // test value. Set this from radio buttons
			},
			beforeSend:function(jqXHR, setting){
				if (stop) {
					alert ("All fields must be entered before adding article to database!");
					jqXHR.abort();
				}
			},
			success:function(data){
				renderResult(data);
			},
			error:function(errorData){
				alert("There seems to be an error:\n");
			}
		})
	});
});

function renderResult(data){
	for (var i = 0; i < data.length; i++) {
		// console.log(data[i]);
	}
}
