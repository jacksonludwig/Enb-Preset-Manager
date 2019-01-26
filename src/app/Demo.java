package app;

import controller.HomeShop;
import controller.MenuBarShop;
import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;

public class Demo extends Application{
	private BorderPane root;

	public static void main(String[] args) {
		launch(args);
	}

	@Override
	public void start(Stage primaryStage) throws Exception {
		root = new BorderPane();
		
		MenuBarShop menuBarShop = new MenuBarShop(root);
		HomeShop homeShop = new HomeShop(menuBarShop, root);
		
		
		Scene scene = new Scene(root, 500, 250);
		primaryStage.setScene(scene);
		primaryStage.show();
	}

}
