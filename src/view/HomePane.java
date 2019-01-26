package view;

import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.control.Button;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

public class HomePane {
	private GridPane gridPane;
	private Button loadPresetOne;
	private Button loadPresetTwo;
	private Button loadPresetThree;
	private Button deleteAllEnbFiles;
	private HBox buttonBox;
	private VBox vBox;
	
	public HomePane() {
		gridPane = new GridPane();
		gridPane.setAlignment(Pos.CENTER);
		gridPane.setPadding(new Insets(20));
		gridPane.setHgap(20);
		gridPane.setVgap(20);
		
		loadPresetOne = new Button("Load Preset One");
		loadPresetOne.setPrefSize(150, 20);
		loadPresetTwo = new Button("Load Preset Two");
		loadPresetTwo.setPrefSize(150, 20);
		loadPresetThree = new Button("Load Preset Three");
		loadPresetThree.setPrefSize(150, 20);
		
		deleteAllEnbFiles = new Button("Uninstall Enbseries");
		deleteAllEnbFiles.setPrefSize(128, 20);
		
		buttonBox = new HBox(40);
		buttonBox.setAlignment(Pos.CENTER);
		buttonBox.getChildren().addAll(loadPresetOne, loadPresetTwo, loadPresetThree);
		
		vBox = new VBox(40);
		vBox.setAlignment(Pos.CENTER);
		vBox.getChildren().addAll(buttonBox, deleteAllEnbFiles);
		
		gridPane.add(vBox, 0, 0);
	}

	public GridPane getHomePane() {
		return gridPane;
	}

	public void setHomePane(GridPane gridPane) {
		this.gridPane = gridPane;
	}

	public Button getLoadPresetOne() {
		return loadPresetOne;
	}

	public void setLoadPresetOne(Button loadPresetOne) {
		this.loadPresetOne = loadPresetOne;
	}

	public Button getLoadPresetTwo() {
		return loadPresetTwo;
	}

	public void setLoadPresetTwo(Button loadPresetTwo) {
		this.loadPresetTwo = loadPresetTwo;
	}

	public Button getLoadPresetThree() {
		return loadPresetThree;
	}

	public void setLoadPresetThree(Button loadPresetThree) {
		this.loadPresetThree = loadPresetThree;
	}

	public HBox getButtonBox() {
		return buttonBox;
	}

	public void setButtonBox(HBox buttonBox) {
		this.buttonBox = buttonBox;
	}

	public Button getDeleteAllEnbFiles() {
		return deleteAllEnbFiles;
	}

	public void setDeleteAllEnbFiles(Button deleteAllEnbFiles) {
		this.deleteAllEnbFiles = deleteAllEnbFiles;
	}
	
}
