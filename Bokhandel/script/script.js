$(function (){
	var currentData;

	$('#resetButton').click(function(){
		currentData = undefined;
	});

	$('#resetButton').click();

	// Load employees into select element
	$.ajax({   
		url: "search.php",
		cache: false,
		data: {action: "getEmployees"},
		success:function(data){
			var select = $('#employee_id');
			for (var i=0; i<data.length; i++) {
				var opt = $('<option value="' + data[i]['employee_id'] + '">' + data[i]['employee_first_name'] + ' ' + data[i]['employee_last_name'] + '</option>');
				select.append(opt);
			}
		}
	});

	$('html').click(function(){
		$('.minicomplete').remove();
	})

	

	// Autocomplete ajax call
	$('.auto').unbind('keyup').bind('keyup',function(e){
		if (e.keyCode == 13 || (e.keyCode >= 37 && e.keyCode <= 40) || $('input[name="type"]:checked').val() == "change") {
			return;
		}
		if ($(this).val().length == 0) {
			$('.minicomplete').remove();
			return;
		}
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
				if (data.length) {
					showMenu(data, field);
				}
				else {
					$('.minicomplete').remove();
				}
			},
			error:function(errorData){
				alert("There seems to be an error:\n");
			}
		});
	});

	// 'Sök'-button ajax call
	$('#searchButton').click(function(){
		
		var submit = {};


		$('.auto').each(function(){
			if (this.value != "") {
				submit[this.id] = this.value;
			} 
		});

		$.ajax({
			url: "search.php",
			method: "post",
			cache: false,
			data: {
				action: "searchBook",
				fields: submit,
			},
			success:function(data){
				currentData = data[0];
				renderResult(data);
			},
			error:function(errorData){
				alert("Ett fel har inträffat.\nKontakta systemansvarig!");
			}
		})
	});

	// 'Spara'-button ajax call
	$('#saveButton').click(function(){
		var fields = {
			"type": $('input[name="type"]:checked').val(), 
			"article_id": currentData['article_id'],

		};
		var stop = false, errorMsg;

		if (fields.type == 'add') {
			$('.add').each(function(){
				if (this.value != "") {
					fields[this.id] = this.value;
				} 
				else {
					if (this.id != "price") // Price is not required
						stop = true;
						errorMsg = "Alla fält utom 'Pris' måste vara ifyllda före artikeln kan sparas till databasen!";
				}
			});
		}
		else if (fields.type == 'change') {
			if (typeof currentData == 'undefined') {
				stop = true;
				errorMsg = "Ingen giltig artikel från databasen har valts för ändring!";
			}
			else {
				$('.add').each(function(){
					if (this.value != currentData[this.id]) {
						fields[this.id] = this.value;
					}
				}); 	
			}
		}

		$.ajax({
			url: "update.php",
			method: "post",
			cache: false,
			data: {"fields": fields},
			beforeSend:function(jqXHR, setting){
				if (stop) {
					alert (errorMsg);
					jqXHR.abort();
				}
			},
			success:function(data){
				if (fields.type == 'change') {
					$('#addRadio').click();
					alert("Ändring genomförd!");
				}
				else {
					alert("Artikel tillagd!");
				}
			},
			error:function(errorData){
				alert("Ett fel har inträffat.\nKontakta systemansvarig!");
			}
		})
	});
});

function renderResult(data) {
	for (var i in data[0]) {
		$('form').find('#' + i).val(data[0][i]);
	} 
} 

function showMenu(dataList, sender) {
	var menu = $('<menu class="minicomplete"/>')
	for (var i=0; i < dataList.length; i++) {
		var opt = $('<div>' + dataList[i]['author_last_name']
		+ ', ' + dataList[i]['author_first_name'] + ': ' + dataList[i]['title'] + '</div>');
		opt.data("isbn",dataList[i]['isbn']);
		if (i == 0) opt.attr("class","selected");
		menu.append(opt);
	}
	$('.minicomplete').remove();
	menu.css({
		top: $('#' + sender).offset().top  + 25,
		left: $('#' + sender).offset().left - 25
	}).appendTo('body');

	menu.find("div").click(function(){
		$('form').find('input[type="text"]').val('');
		$('form').find('#isbn').val($(this).data("isbn"));
		$('.minicomplete').remove();
		$('#searchButton').click();
	});

	menu.find("div").bind('mouseover', function(){
		$('.selected').attr("class","");
		$(this).attr("class","selected");
	})

	$(document).unbind('keydown').bind('keydown', function(e){
		var current = $('.selected');
		if (e.keyCode == 40) {
			if (current.next().length) {
				current.next().attr("class", "selected");
				current.attr("class","");
			}
		}
		else if (e.keyCode == 38) {
			if (current.prev().length) {
				current.prev().attr("class","selected");
				current.attr("class","");
			}
		}
		else if (e.keyCode == 13) {
			menu.find('.selected').click();
		}
	});
}
