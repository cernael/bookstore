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
	});

	$(document).unbind('keydown').bind('keydown', function(e){
		if ($('.minicomplete').length) {
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
				$('.minicomplete').find('.selected').click();
			}
		}
		else if (e.keyCode == 13) { // Enter key bound to save for every textfield if in "changes" mode
									// or if in "amount"-field in "register" mode
			if ($('input[name="type"]:checked').val() == "change" || $(this).attr('id') == "#inventory") {
				$('#saveButton').click();
			}
		}
		
	});

	// Autocomplete ajax call
	$('.auto').unbind('keyup').bind('keyup',function(e){
		if (e.keyCode == 13 || (e.keyCode >= 37 && e.keyCode <= 40) || $('input[name="type"]:checked').val() == "change") {
			return;
		}
		if ($(this).val().length == 0) { // När backspace tar bort sista bokstaven i fältet tas minicomplete bort
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
				currentData = data;
				renderResult(currentData);
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
			"article_id": undefined,
			"authors": [],
			"categories": [] 
		};		
		if (currentData){
			fields.article_id = currentData[0].article_id;
		}
		var stop = false, errorMsg;

		if (fields.type == 'add') {
			$('.add').each(function(){
				fields[this.id] = this.value;
				if (this.value == "" && this.id != "price") { // All fields except "price" is required
					stop = true;
					errorMsg = "Alla fält utom 'Pris' måste vara ifyllda före artikeln kan sparas till databasen!";
				}
			});
			if (!fields.price) {
				fields.price =  fields.f_pris * 1.85 * 1.25;
			} 
			$('.authors').each(function(){
				var author = {
					"author_first_name": $(this).find('#author_first_name').val(),
					"author_last_name": $(this).find('#author_last_name').val()
				};
				fields.authors.push(author); 
			});
			$('.categories').each(function(){
				fields.categories.push($(this).val());
			});
		}
		else if (fields.type == 'change') {
			if (typeof currentData == 'undefined') {
				stop = true;
				errorMsg = "Ingen giltig artikel från databasen har valts för ändring!";
			}
			else {
				$('.add').each(function(){
					if (this.value != currentData[0][this.id]) {
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
				var isbn = $('form').find('#isbn').val();
				$('form').find('input[type="text"]').val('');
				$('form').find('#isbn').val(isbn);
				$('#searchButton').click();

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
	$('form').find('#inventory').text(data[0]['inventory']); 
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
}
