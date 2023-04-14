state("shapezio") {}

init {
	old.line = "";

	var path = Path.GetDirectoryName(game.MainModule.FileName) + "/stderr.log";
	if (File.Exists(path)){
		vars.stream = new StreamReader(File.Open(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
	}else{
		vars.stream = null;

		var result = MessageBox.Show(
			"Shapez was not launched with the launch script. It can be found in the speedrun.com resources." + "\n\n" +
			"Would you like to go there now?",
			"LiveSplit | Shapez",
			MessageBoxButtons.YesNo);

		if (result == DialogResult.Yes)
			Process.Start(new ProcessStartInfo {
				UseShellExecute = true,
				FileName = "https://speedrun.com/shapez/resources"
			});
	}
}

update {
	if (vars.stream == null)
		return false;

	var line = vars.stream.ReadLine();
	if (line != null)
  		current.line = line;
	if (old.line == current.line)
		return false;
}

start {
	return current.line.Contains("GAME STARTED");
}

split {
	return current.line.Contains("Complete level");
}

reset {
	return current.line.Contains("destructing root");
}

exit {
	if (vars.stream != null)
		vars.stream.Close();
}

shutdown {
	if (vars.stream != null)
		vars.stream.Close();
}
