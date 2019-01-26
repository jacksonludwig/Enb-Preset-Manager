package controller;

import java.io.File;

import javafx.scene.layout.BorderPane;
import model.FileMover;
import view.HomePane;

public class HomeShop {
	private HomePane homePane;
	private MenuBarShop menuBarShop;
	private BorderPane root;

	public HomeShop(MenuBarShop menuBarShop, BorderPane root) {
		homePane = new HomePane();
		this.menuBarShop = menuBarShop;
		this.root = root;
		root.setCenter(homePane.getHomePane());
		setCallBacks();

	}

	private void setCallBacks() {
		homePane.getLoadPresetOne().setOnAction(e -> {
			FileMover.deleteDirectories("C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\enbcache",
					"C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\enbseries");
			File directory = new File("C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\");
			FileMover.deleteBaseFiles(directory);

			File copyFiles = new File(
					"C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\Other zips\\NAT NVT setup");
			for (File f : copyFiles.listFiles()) {
				FileMover.copy(f.getAbsolutePath(),
						"C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\" + f.getName());
			}
		});

		homePane.getLoadPresetTwo().setOnAction(e -> {
			FileMover.deleteDirectories("C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\enbcache",
					"C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\enbseries");
			File directory = new File("C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\");
			FileMover.deleteBaseFiles(directory);

			File copyFiles = new File(
					"C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\Other zips\\obsidian NVT setup");
			for (File f : copyFiles.listFiles()) {
				FileMover.copy(f.getAbsolutePath(),
						"C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\" + f.getName());
			}
		});

		homePane.getLoadPresetThree().setOnAction(e -> {
			FileMover.deleteDirectories("C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\enbcache",
					"C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\enbseries");
			File directory = new File("C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\");
			FileMover.deleteBaseFiles(directory);

			File copyFiles = new File(
					"C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\Other zips\\Ruvaak Vivid setup");
			for (File f : copyFiles.listFiles()) {
				FileMover.copy(f.getAbsolutePath(),
						"C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\" + f.getName());
			}
		});
		
		homePane.getDeleteAllEnbFiles().setOnAction(e -> {
			FileMover.deleteDirectories("C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\enbcache",
					"C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\enbseries");
			File directory = new File("C:\\Steam\\steamapps\\common\\Skyrim Special Edition\\");
			FileMover.deleteBaseFiles(directory);
		});
	}

	public HomePane getHomePane() {
		return homePane;
	}

	public void setHomePane(HomePane homePane) {
		this.homePane = homePane;
	}

}
