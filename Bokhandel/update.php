<?php
	try {
		$myPDO = new PDO("mysql:host=localhost;dbname=bookstore_db", "pma", "Hur17op54");		
		$myPDO -> setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
	} 
		catch(PDOException $e) {  
	    echo $e->getMessage();  
	}
	$_fields = $_POST['fields'];

	if ($_fields['type'] == "add") {
		$insert_2 = "INSERT INTO inventory_event(type, employee_id) VALUES(\"$_fields[type]\", (SELECT employee_id FROM employees WHERE employee_id = $_fields[employee_id]));";
		$insert_3 = "INSERT INTO line_item(event_id, article_id, amount) VALUES((SELECT event_id FROM inventory_event ORDER BY date DESC LIMIT 1), (SELECT article_id FROM articles WHERE isbn = \"$_fields[isbn]\"), $_fields[amount]);";
 		$insert_4; $insert_6;

		$checkInventory = $myPDO->query("SELECT isbn FROM articles WHERE isbn = \"$_fields[isbn]\";");
		if ($checkInventory->rowCount()) {

			// Updating existing article! (adding or deleting amount)

			$update = "UPDATE articles SET inventory = inventory + $_fields[amount] WHERE isbn = \"$_fields[isbn]\";";
			$myPDO->exec($update);
			$myPDO->exec($insert_2);
			$myPDO->exec($insert_3);
			return;

		}
		else {

			// Inserting new article!

			//  articles (fk from shelves)
			$insert_1 = "INSERT INTO articles(isbn,title,publisher,publishing_year,shelf_id,inventory,language) VALUES (\"$_fields[isbn]\",\"$_fields[title]\",\"$_fields[publisher]\",\"$_fields[publishing_year]\", (SELECT shelf_id FROM shelves WHERE shelf_name = \"$_fields[shelf_name]\"), $_fields[amount], \"$_fields[language]\");";
			$myPDO->exec($insert_1); // articles
			$myPDO->exec($insert_2); // inventory_event
			$myPDO->exec($insert_3); // line_item
			

			// categories 
			foreach ($_fields['categories'] as $_category) {
				$checkCategory = $myPDO->query("SELECT category_id FROM categories WHERE category_name = \"$_fields[category_name]\";");
				if (!$checkCategory->rowCount()) {
					$insert_4 = "INSERT INTO categories(category_name) VALUES(\"$_fields[category_name]\");";				
				}
				$insert_5 = "INSERT INTO article_category(article_id, category_id) VALUES((SELECT article_id FROM articles WHERE isbn = $_fields[isbn]),(SELECT category_id FROM categories WHERE category_name = \"$_fields[category_name]\"));";
		
				if ($insert_4) {
					$myPDO->exec($insert_4); // categories
				}
				$myPDO->exec($insert_5); // article_category			
			}

			// authors
			foreach ($_fields['authors'] as $_author) {
				$checkAuthor = $myPDO->query("SELECT author_id FROM authors WHERE author_first_name =\"$_author[author_first_name]\" AND author_last_name = \"$_author[author_last_name]\";");
				if (!$checkAuthor->rowCount()) {
					$insert_6 = "INSERT INTO authors(author_last_name, author_first_name) VALUES(\"$_author[author_last_name]\", \"$_author[author_first_name]\");";
				}
				$insert_7 = "INSERT INTO book_author(author_id, article_id) VALUES((SELECT author_id FROM authors WHERE author_last_name = \"$_author[author_last_name]\" AND author_first_name = \"$_author[author_first_name]\"), (SELECT article_id FROM articles WHERE ISBN = $_fields[isbn]));";
				
				if ($insert_6) {
					$myPDO->exec($insert_6); // authors
				}
				$myPDO->exec($insert_7); // book_authors
			}

			$price;
			if (!$_fields['price']) {
				$price = $_fields['f_pris'] * 1.85 * 1.25;
			}
			else {
				$price = $_fields['price'];
			}

			$insert_8 = "INSERT INTO prices(article_id, f_pris, price) VALUES((SELECT article_id FROM articles WHERE isbn = $_fields[isbn]), $_fields[f_pris], $price);";



			

			

			$myPDO->exec($insert_8); // prices
			
			return;
		}
	}
	if ($_fields['type'] == 'change') {
		$articles = $authors = $categories = $prices = '';
		foreach ($_fields as $key => $value) {
		 	switch ($key) {
		 		case 'isbn':
		 		case 'title':
		 		case 'publisher':
		 		case 'publishing_year':
		 		case 'shelf_id':
		 		case 'inventory':
		 		case 'language':		
		 			if (!$articles) $articles = 'SET';
		 			else $articles .= ',';
		 			$articles .= " {$key}=\"$value\"";
		 			break;
		 		case 'authors':
		 			// $authors .= " {$key}=\"$value\"";
		 			break;
		 		case 'category_name':
		 			// $categories .= " {$key}=\"$value\"";
		 			break;
		 		case 'f_pris':
		 		case 'price':
		 			if (!$articles) $articles = 'SET';
		 			else $articles .= ',';
		 			$prices .= " {$key}=\"$value\"";
		 			break;

		 		default:
		 			break;
		 	}
		}
		if ($articles) {
			$update = "UPDATE articles $articles WHERE article_id = $_fields[article_id];";
			print_r($update);
			$myPDO->exec($update);
		}
		if ($authors) {

		}
		if ($categories) {

		}
		if ($prices) {
			$update = "UPDATE prices $prices WHERE article_id = $_fields[article_id];";
			$myPDO->exec($update);
		}
	}
?>