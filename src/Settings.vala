namespace Codewall {
	public class Settings : Granite.Services.Settings {public string test { get; set; }public Settings(string schema_id) {
		base (schema_id);
	}
	}

}