<?php
	try {
		$myPDO = new PDO("mysql:host=localhost;dbname=bookstore_db", "pma", "Hur17op54");		
		$myPDO -> setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
	} 
		catch(PDOException $e) {  
	    echo $e->getMessage();  
	}

	$_fields; $_tables; $_conditions;

	if ($_REQUEST["action"] == "autoComplete") {
		$_fragment = $_REQUEST["fragment"];
		$_sender = $_REQUEST["sender"];

		
		if ($_sender == "search") {
			$_fields = "b.ISBN, a.author_last_name, a.author_first_name, b.title";
			$_tables = "articles b INNER JOIN book_author ba ON b.article_id = ba.article_id INNER JOIN authors a ON ba.author_id = a.author_id";
			$_conditions = str_replace(",", " LIKE '%$_fragment%' OR", $_fields);
		}
		else {  // Autocomplete limited to the active searchfield
			$_fields = (strstr($_sender, "author") ? "a." : "b.") . $_sender; 
			switch ($_sender) {
				case "isbn":
				case "title":
				case "publisher":
					$_tables = "articles";
					break;
				case "author_first_name":
				case "author_last_name":
					$_tables = "articles b INNER JOIN book_author ba ON b.article_id = ba.article_id INNER JOIN authors a ON ba.author_id = a.author_id";
					break;
			}
			$_conditions = "$_fields LIKE '%$_fragment%'";
		}
		

	}
 
	if ($_REQUEST["action"] == "searchBook") {
		$_fields = "b.ISBN, a.author_last_name, a.author_first_name, b.title, b.publisher, b.publishing_year, b.inventory, b.language, c.category_name, s.shelf_name, p.f_pris, p.price";
		$_tables = "articles b INNER JOIN book_author ba ON b.article_id = ba.article_id INNER JOIN authors a ON ba.author_id = a.author_id INNER JOIN article_category ac ON b.article_id = ac.article_id INNER JOIN categories c ON ac.category_id = c.category_id INNER JOIN shelves s ON b.shelf_id = s.shelf_id INNER JOIN prices p ON b.article_id = p.article_id";
		
		$_submitted = $_REQUEST['fields'];
		$_conditions = '';
		foreach ($_submitted as $key => $value) {
			if ($_conditions != '') $_conditions .= ' AND ';
			$_conditions .= $key . " LIKE '%" . $value . "%'";
		}
	}

	$sql = "SELECT $_fields FROM $_tables WHERE $_conditions;"; 
	$statement = $myPDO->query($sql);
	$statement -> setFetchMode(PDO::FETCH_ASSOC);
	$result = $statement->fetchALL();	

	header('Content-Type: application/json');
	echo (json_encode($result));
?>