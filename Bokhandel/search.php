<?php
	try {
		$myPDO = new PDO("mysql:host=localhost;dbname=bookstore_db", "pma", "Hur17op54");		
		$myPDO -> setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
	} 
		catch(PDOException $e) {  
	    echo $e->getMessage();  
	}

	$_fields; $_tables; 
	$_conditions = 'WHERE ';

	if ($_REQUEST["action"] == "getEmployees") {
		$_fields = "*";
		$_tables = "employees";
		$_conditions = '';
	}

	if ($_REQUEST["action"] == "autoComplete") {
		$_fragment = $_REQUEST["fragment"];
		$_sender = $_REQUEST["sender"];
		$_fields = "b.isbn, a.author_last_name, a.author_first_name, b.title";
		$_tables = "articles b INNER JOIN book_author ba ON b.article_id = ba.article_id INNER JOIN authors a ON ba.author_id = a.author_id";
		if ($_sender == "search") {			
			$_conditions .= str_replace(",", " LIKE '$_fragment%' OR", $_fields);
		}
		else {  // Autocomplete limited to the active searchfield
			$_queryField = (strstr($_sender, "author") ? "a." : "b.") . $_sender; 
			$_conditions .= "$_queryField LIKE '$_fragment%'";
		}
	}
 
	if ($_REQUEST["action"] == "searchBook") {
		$_fields = "b.article_id, b.isbn, a.author_id, a.author_last_name, a.author_first_name, b.title, b.publisher, b.publishing_year, b.inventory, b.language, c.category_id, c.category_name, s.shelf_name, p.f_pris, p.price";
		$_tables = "articles b INNER JOIN book_author ba ON b.article_id = ba.article_id INNER JOIN authors a ON ba.author_id = a.author_id INNER JOIN article_category ac ON b.article_id = ac.article_id INNER JOIN categories c ON ac.category_id = c.category_id INNER JOIN shelves s ON b.shelf_id = s.shelf_id INNER JOIN prices p ON b.article_id = p.article_id";
		
		$_submitted = $_REQUEST['fields'];
		foreach ($_submitted as $key => $value) {
			if ($_conditions != 'WHERE ') $_conditions .= ' AND ';
			$_conditions .= $key . " LIKE '%" . $value . "%'";
		}
	}

	$sql = "SELECT $_fields FROM $_tables $_conditions;"; 
	$statement = $myPDO->query($sql);
	$statement -> setFetchMode(PDO::FETCH_ASSOC);
	$result = $statement->fetchALL();	

	header('Content-Type: application/json');
	echo (json_encode($result));
?>