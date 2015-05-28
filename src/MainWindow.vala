using Gtk;
using Json;
public class AppWindow : Gtk.Window {

	//::Store the initial boards. Will cache the first time.
	Gtk.ListStore boardsListStore = null;

	Gtk.ListStore threadsListStore = null;

	//::This layout contains the status bar/ main pane and or tools bar if needed.
	Gtk.Box appBox;

	//::Next drilldown contains a narrower main pane plus adds the tree view for the board.
	Gtk.Box boardsBox;

	//::Narrow it down more and it has the threads on the top pane and the view on the bottom.
	Gtk.Box threadsBox;

	//::Boards tree view for the sidebar.
	Gtk.TreeView boardsTreeView;

	//:: Threads tree view for top bar.
	Gtk.TreeView threadsTreeView;
	
	Gtk.ScrolledWindow boardsScrolledWindow;
	Gtk.ScrolledWindow threadsScrolledWindow;
	
	

	public AppWindow() {         //This is the default constructor for the new window.

		this.title = "4Chan Browser";         // Define the window title
		this.set_default_size(400, 400);         // Define the intial size of the window.
		this.destroy.connect(Gtk.main_quit);         // Clicking the close button will fully terminate the program.
		this.set_position(Gtk.WindowPosition.CENTER);         // Launch the program in the center of the screen
		this.set_titlebar(this.buildHeaderBar());

		this.boardsTreeView = new Gtk.TreeView();
		this.boardsTreeView.set_activate_on_single_click(true);


		this.threadsTreeView = new Gtk.TreeView.with_model(this.threadsListStore);
		
		this.boardsScrolledWindow = new Gtk.ScrolledWindow(null,null);
        this.boardsScrolledWindow.width_request = 200;
		this.threadsScrolledWindow = new Gtk.ScrolledWindow(null,null);


		//::Define the layouts that are needed to make this possible.
		this.appBox = new Box(Orientation.VERTICAL, 0);
		this.boardsBox = new Box(Orientation.HORIZONTAL, 0);
		this.threadsBox = new Box(Orientation.VERTICAL, 0);

		this.add(appBox);
		this.appBox.pack_start(this.boardsBox);
		
		//:: add the board tree view to the left side
		this.buildBoardsListStore();
		this.buildThreadsListStore("3");
		this.populateBoardsTreeView(this.boardsListStore);
		this.populateThreadsTreeView(this.threadsListStore);
		this.boardsBox.pack_start(this.boardsScrolledWindow, false, false);
		this.boardsBox.pack_start(this.threadsScrolledWindow);

		this.boardsTreeView.row_activated.connect(this.connection_rowClicked);
	}


	/**
	   ----------------------------------------------------

	   ----------------------------------------------------
	 */
	private void connection_rowClicked(TreePath path, TreeViewColumn column) {
		int index = int.parse(path.to_string());
		GLib.Value cell2;
		Gtk.TreeIter iter;

		boardsListStore.get_iter(out iter, path);
		boardsListStore.get_value(iter, 1, out cell2);

    
    this.buildThreadsListStore((string)cell2);
    this.populateThreadsTreeView(this.threadsListStore);
    this.threadsBox.pack_start(this.threadsScrolledWindow);
	}


	/**
	   ----------------------------------------------------

	   ----------------------------------------------------
	 */

	private Gtk.HeaderBar buildHeaderBar() {
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


	/**
	   ----------------------------------------------------

	   ----------------------------------------------------
	 */
	private Gtk.ListStore buildBoardsListStore() {

		if (this.boardsListStore != null) {
			stdout.printf("boards not null\n");
			return this.boardsListStore;
		}

		this.boardsListStore = new Gtk.ListStore(2, typeof (string), typeof(string));

		//create new soup session
		Soup.Session session = new Soup.Session();

		// Syncrouniously get the information from the URI
		Soup.Message message = new Soup.Message("GET", "http://a.4cdn.org/boards.json");
		session.send_message (message);

		try {

			//::Now lets make a Json Parser and load the message from the soup GET.
			var parser = new Json.Parser();
			parser.load_from_data((string) message.response_body.flatten().data, -1);

			//::Get the root of the JSON as an object.
			var root_object = parser.get_root ().get_object ();

			//::Get the array member boards. Which is the first containing member in the array.
			var boards = root_object.get_array_member("boards");

			// stdout.printf(" %s\n", boards.get_element(0).get_object().get_string_member("title"));

			//::Loop through each board and get the elements.
			foreach (var board in boards.get_elements()) {

				var board_node = board.get_object();
				// stdout.printf("%s\n", board_node.get_string_member("title"));

				//::We will just populate a ListStore that we will return at the end of the method containing just the titles.
				//:: @TODO Will have to create a parallel array or store to record the board shortcut
				Gtk.TreeIter iter;
				this.boardsListStore.append(out iter);
				this.boardsListStore.set(iter, 0, board_node.get_string_member("title"), 1, board_node.get_string_member("board"));

			}

		}
		catch {
			warning("Failed to retrieve board listing.");
		}

		return this.boardsListStore;
	}


	/**
	   ----------------------------------------------------

	   ----------------------------------------------------
	 */

	private Gtk.ListStore buildThreadsListStore(string board) {
	
        if (this.threadsListStore == null)
		    this.threadsListStore = new Gtk.ListStore(2, typeof (string), typeof(string));

        this.threadsListStore.clear();
		
        for (int i = 1; i <=10; i++ ) {
		//create new soup session
		Soup.Session session = new Soup.Session();

		// Syncrouniously get the information from the URI
		Soup.Message message = new Soup.Message("GET", "http://a.4cdn.org/"+ board + "/"+i.to_string()+".json");
		session.send_message (message);
		Gtk.TreeIter iter;
		try {

			//::Now lets make a Json Parser and load the message from the soup GET.
			var parser = new Json.Parser();
			parser.load_from_data((string) message.response_body.flatten().data, -1);

			//::Get the root of the JSON as an object.
			var root_object = parser.get_root ().get_object ();

			//::Get the array member boards. Which is the first containing member in the array.
			var threads = root_object.get_array_member("threads");

			// stdout.printf(" %s\n", boards.get_element(0).get_object().get_string_member("title"));

			//::Loop through each board and get the elements.
			foreach (var thread in threads.get_elements()) {
				var post_head_subject = thread.get_object().get_array_member("posts").get_element(0).get_object().get_string_member("sub");


				this.threadsListStore.append(out iter);
				this.threadsListStore.set(iter, 0, post_head_subject, 1, "");



			}

		}
		catch {
			warning("Failed to retrieve posts.");
		}
}

		return this.threadsListStore;
	}


	/**
	   ----------------------------------------------------

	   ----------------------------------------------------
	 */

	private Gtk.ScrolledWindow populateBoardsTreeView(Gtk.ListStore list) {

		//:: Make the board tree view using the list parameter
		this.boardsTreeView = new Gtk.TreeView.with_model (list);
		this.boardsScrolledWindow = new Gtk.ScrolledWindow(null,null);
		this.boardsScrolledWindow.add(this.boardsTreeView);


		Gtk.CellRendererText cell = new Gtk.CellRendererText ();
		this.boardsTreeView.insert_column_with_attributes (-1, "Board", cell, "text", 0);
		//view.insert_column_with_attributes (-1, "Cities", cell, "text", 1);

		return this.boardsScrolledWindow;
	}


	/**
	   ----------------------------------------------------

	   ----------------------------------------------------
	 */

	private Gtk.ScrolledWindow populateThreadsTreeView(Gtk.ListStore list) {

		//:: Make the board tree view using the list parameter
		this.threadsTreeView = new Gtk.TreeView.with_model (this.threadsListStore);
		//this.threadsScrolledWindow = new Gtk.ScrolledWindow(null,null);
		this.threadsScrolledWindow.add(this.threadsTreeView);


		Gtk.CellRendererText cell = new Gtk.CellRendererText ();
		this.threadsTreeView.insert_column_with_attributes (-1, "Subject", cell, "text", 0);
		//view.insert_column_with_attributes (-1, "Cities", cell, "text", 1);

		return boardsScrolledWindow;
	}


	/**
	 * Much like other programming langauges such as Java, we will define our main
	 * execution loop as a static method.
	 */
	public static int main(string[] args) {
		Gtk.init(ref args);
		AppWindow window = new AppWindow();
		window.show_all();         // Tell the window to draw
		Gtk.main();
		return 0;
	}
}


