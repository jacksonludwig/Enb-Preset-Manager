package controller;

import javafx.application.Platform;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuBar;
import javafx.scene.control.MenuItem;
import javafx.scene.layout.BorderPane;

public class MenuBarShop {
	private MenuItem exitMenuItem;
	private Menu fileMenu;
	private MenuBar menuBar;
	
	public MenuBarShop(BorderPane root) {
		fileMenu = new Menu("FILE");
		exitMenuItem = new MenuItem("EXIT");
		fileMenu.getItems().add(exitMenuItem);
		
		menuBar = new MenuBar();
		menuBar.getMenus().add(fileMenu);
		
		setCallbacks();
		
		root.setTop(menuBar);
	}
	
	private void setCallbacks() {
		exitMenuItem.setOnAction(e -> {
			Platform.exit();
		});
	}
}
