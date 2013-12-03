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
				// renderResult(data);
			},
			error:function(errorData){
				alert("There seems to be an error:\n");
			}
		});
	});

	$('input[action="searchBook"]').click(function(){
		
		var action = $(this).attr('action');
		var submit = {};


		$('.add').each(function(){
			if (this.value != "") {
				submit[this.id] = this.value;
			} 
		});

		$.ajax({
			url: "search.php",
			method: "post",
			cache: false,
			data: {
				action: action,
				fields: submit,
				employee: 1,	 // test-value. Set this from select-menu
				type: "'change'" // test value. Set this from radio buttons
			},
			success:function(data){
				renderResult(data);
			},
			error:function(errorData){
				alert("There seems to be an error:\n");
			}
		})
	});

	$('input[action="addBook"]').click(function(){
		
		var action = $(this).attr('action');
		var submit = {}, stop = false;

		$('.add').each(function(){
			if (this.value != "") {
				submit[this.id] = this.value;
			} 
			else {
				stop = true;
			}
		});

		$.ajax({
			url: action == "update.php",
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
				alert("Book added!");
			},
			error:function(errorData){
				alert("There seems to be an error:\n");
			}
		})
	});
});

function renderResult(data) {
	for (var i in data[0]) {
		$('form').find('#' + i).val(data[0][i]);
	} 
} 


