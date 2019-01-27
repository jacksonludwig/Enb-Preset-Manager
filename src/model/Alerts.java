package model;

import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;

public class Alerts {
	public static void showPresetLoaded() {
		Alert alert = new Alert(AlertType.INFORMATION);
		alert.setTitle("Preset Load Completed");
		alert.setContentText("The Preset Was Loaded Sucessfully");
		alert.setHeaderText("The Selected Preset Was Moved Into The Skyrim Directory");
		alert.showAndWait();
	}
	
	public static void showEnbDeleted() {
		Alert alert = new Alert(AlertType.INFORMATION);
		alert.setTitle("Preset Delete Completed");
		alert.setContentText("The Preset Was Deleted Sucessfully");
		alert.setHeaderText("The Existing Preset Was Deleted From The Skyrim Directory");
		alert.showAndWait();
	}
}
