<?php
	try {
		$myPDO = new PDO("mysql:host=localhost;dbname=bookstore_db", "root", "");		
		$myPDO -> setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
	} 
		catch(PDOException $e) {  
	    echo $e->getMessage();  
	}
	$_fields = $_POST['fields'];

	if ($_fields['type'] == "add") {
		$insert_inventory_event = "INSERT INTO inventory_event(type, employee_id) VALUES(\"$_fields[type]\", (SELECT employee_id FROM employees WHERE employee_id = $_fields[employee_id]));";
		$insert_line_item = "INSERT INTO line_item(event_id, article_id, amount) VALUES((SELECT event_id FROM inventory_event ORDER BY date DESC LIMIT 1), (SELECT article_id FROM articles WHERE isbn = $_fields[isbn]), \"$_fields[amount]\");";


		$checkInventory = $myPDO->query("SELECT isbn FROM articles WHERE isbn = \"$_fields[isbn]\";");
		if ($checkInventory->rowCount()) {

			// Updating existing article! (adding or deleting amount)

			$update = "UPDATE articles SET inventory = inventory + $_fields[amount] WHERE isbn = \"$_fields[isbn]\";";
			$myPDO->exec($update);
			$myPDO->exec($insert_inventory_event);
			$myPDO->exec($insert_line_item);
			return;

		}
		else {

			// Inserting new article!

			//  articles (fk from shelves)
			$insert_articles = "INSERT INTO articles(isbn,title,publisher,publishing_year,shelf_id,inventory,language) VALUES (\"$_fields[isbn]\",\"$_fields[title]\",\"$_fields[publisher]\",\"$_fields[publishing_year]\", (SELECT shelf_id FROM shelves WHERE shelf_name = \"$_fields[shelf_name]\"), $_fields[amount], \"$_fields[language]\");";
			$myPDO->exec($insert_articles); // articles
			$myPDO->exec($insert_inventory_event); // inventory_event
			$myPDO->exec($insert_line_item); // line_item
			

			// categories 
			foreach ($_fields['categories'] as $_category) {
				$checkCategory = $myPDO->query("SELECT category_id FROM categories WHERE category_name = \"$_category\";");
				$insert_categories;
				if (!$checkCategory->rowCount()) {
					$insert_categories = "INSERT INTO categories(category_name) VALUES(\"$_category\");";				
				}
				$insert_article_category = "INSERT INTO article_category(article_id, category_id) VALUES((SELECT article_id FROM articles WHERE isbn = \"$_fields[isbn]\"),(SELECT category_id FROM categories WHERE category_name = \"$_category\"));";
		
				if ($insert_categories) {
					$myPDO->exec($insert_categories); // categories
				}
				$myPDO->exec($insert_article_category); // article_category			
			}

			// authors
			foreach ($_fields['authors'] as $_author) {
				$checkAuthor = $myPDO->query("SELECT author_id FROM authors WHERE author_first_name = \"$_author[author_first_name]\" AND author_last_name = \"$_author[author_last_name]\";");
				$insert_authors;
				if (!$checkAuthor->rowCount()) {
					$insert_authors = "INSERT INTO authors(author_last_name, author_first_name) VALUES(\"$_author[author_last_name]\", \"$_author[author_first_name]\");";
				}
				$insert_book_author = "INSERT INTO book_author(author_id, article_id) VALUES((SELECT author_id FROM authors WHERE author_last_name = \"$_author[author_last_name]\" AND author_first_name = \"$_author[author_first_name]\"), (SELECT article_id FROM articles WHERE ISBN = \"$_fields[isbn]\"));";
				
				if ($insert_authors) {
					$myPDO->exec($insert_authors); // new author
				}
				$myPDO->exec($insert_book_author); // new connection book_authors
			}

			$insert_price = "INSERT INTO prices(article_id, f_pris, price) VALUES((SELECT article_id FROM articles WHERE isbn = \"$_fields[isbn]\"), $_fields[f_pris], $_fields[price]);";
			$myPDO->exec($insert_price); // prices
			
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
		 			$articles .= " $key=\"$value\"";
		 			break;
		 		case 'authors':
		 			// $authors .= " $key=\"$value\"";  	// Will be implemented when form handles
		 			break; 									// multiple authors and categories
		 		case 'category_name':						// 
		 			// $categories .= " $key=\"$value\""; 	//
		 			break;									//
		 		case 'f_pris':
		 		case 'price':
		 			if (!$articles) $articles = 'SET';
		 			else $articles .= ',';
		 			$prices .= " $key=$value";
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