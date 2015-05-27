using Gtk;
public class AppWindow : Gtk.Window {
		public AppWindow() { //This is the default constructor for the new window.	
			
			this.title = "4Chan Browser"; // Define the window title
			this.set_default_size(400, 400); // Define the intial size of the window.
			this.destroy.connect(Gtk.main_quit); // Clicking the close button will fully terminate the program.
			this.set_position(Gtk.WindowPosition.CENTER); // Launch the program in the center of the screen
            this.set_titlebar(this.header());

this.request();

		}

        private Gtk.HeaderBar header() {
	var header = new Gtk.HeaderBar();
	
	/*
	 * Set properties of the Header Bar
	 */
	header.set_title("4Chan Browser");
	header.set_show_close_button(true);
	//header.set_subtitle("Subtitle here");
	header.spacing = 0;

	//Get image from icon theme
	Gtk.Image img = new Gtk.Image.from_icon_name ("document-new", Gtk.IconSize.MENU);
	Gtk.ToolButton button2 = new Gtk.ToolButton (img, null);
	
	//Add Icon to header
	header.pack_start(button2);

	//Get another Icon.
	img = new Gtk.Image.from_icon_name ("document-open", Gtk.IconSize.MENU);
	Gtk.ToolButton button3 = new Gtk.ToolButton (img, null);
	
	//Add it again
	header.pack_start(button3);

	//Add a search entry to the header
	//header.pack_start(new Gtk.SearchEntry());

	//Return it to be included somewhere else.
	return header;

}

    private void request() {

        Soup.Session session = new Soup.Session();
        Soup.Message message = new Soup.Message("GET", "http://a.4cdn.org/boards.json");

 
  /* send a sync request */
    session.send_message (message);
    message.response_headers.foreach ((name, val) => {
        stdout.printf ("Name: %s -> Value: %s\n", name, val);
    });

    stdout.printf ("Message length: %lld\n%s\n",
                   message.response_body.length,
                   message.response_body.data);
    }


    private void treeview() {
    	// The Model:
		Gtk.ListStore list_store = new Gtk.ListStore (2, typeof (string), typeof (int));
		Gtk.TreeIter iter;

		list_store.append (out iter);
		list_store.set (iter, 0, "Burgenland", 1, 13);
		list_store.append (out iter);
		list_store.set (iter, 0, "Carinthia", 1, 17);
		list_store.append (out iter);
		list_store.set (iter, 0, "Lower Austria", 1, 75);
		list_store.append (out iter);
		list_store.set (iter, 0, "Upper Austria", 1, 32);
		list_store.append (out iter);
		list_store.set (iter, 0, "Salzburg", 1, 10);
		list_store.append (out iter);
		list_store.set (iter, 0, "Styria", 1, 34);
		list_store.append (out iter);
		list_store.set (iter, 0, "Tyrol", 1, 11);
		list_store.append (out iter);
		list_store.set (iter, 0, "Vorarlberg", 1, 5);
		list_store.append (out iter);
		list_store.set (iter, 0, "Vienna", 1, 1);

		// The View:
		Gtk.TreeView view = new Gtk.TreeView.with_model (list_store);
		this.add (view);

		Gtk.CellRendererText cell = new Gtk.CellRendererText ();
		view.insert_column_with_attributes (-1, "State", cell, "text", 0);
		view.insert_column_with_attributes (-1, "Cities", cell, "text", 1);
}


		
		/**
		 * Much like other programming langauges such as Java, we will define our main 
		 * execution loop as a static method. 
		 */
		public static int main(string[] args) {
			Gtk.init(ref args);
			AppWindow window = new AppWindow();
			window.show_all(); // Tell the window to draw
			Gtk.main();
			return 0;	
		}
	}


