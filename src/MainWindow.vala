using Gtk;
using Json;
public class AppWindow : Gtk.Window {

  //::Store the initial boards. Will cache the first time.
	Gtk.ListStore boards_list = null;
	
	Gtk.ListStore threads_list = null;
	
	//::This layout contains the status bar/ main pane and or tools bar if needed. 
	Gtk.Box outer_layout;
	
	//::Next drilldown contains a narrower main pane plus adds the tree view for the board.
	Gtk.Box boards_layout;
	
	//::Narrow it down more and it has the threads on the top pane and the view on the bottom.
	Gtk.Box threads_layout;
	
	//::Boards tree view for the sidebar.
	Gtk.TreeView boards_view;
	
	//:: Threads tree view for top bar.
	Gtk.TreeView threads_view;

	public AppWindow() {         //This is the default constructor for the new window.

		this.title = "4Chan Browser";         // Define the window title
		this.set_default_size(400, 400);         // Define the intial size of the window.
		this.destroy.connect(Gtk.main_quit);         // Clicking the close button will fully terminate the program.
		this.set_position(Gtk.WindowPosition.CENTER);         // Launch the program in the center of the screen
		this.set_titlebar(this.header());
		
		this.boards_view = new Gtk.TreeView();
		this.boards_view.set_activate_on_single_click(true);
		
		this.threads_view = new Gtk.TreeView();
    
		
		//::Define the layouts that are needed to make this possible.
		this.outer_layout = new Box(Orientation.VERTICAL, 0);
		this.boards_layout = new Box(Orientation.HORIZONTAL, 0);
		this.threads_layout = new Box(Orientation.VERTICAL, 0);
		
		this.add(outer_layout);
		this.outer_layout.pack_start(this.boards_layout);
    this.boards_layout.pack_start(this.board_view(this.request_boards()));
    this.boards_layout.pack_start(this.threads_view);
    this.boards_view.row_activated.connect(this.connection_rowClicked);
	}
	
	private void connection_rowClicked(TreePath path, TreeViewColumn column) {
	 int index = int.parse(path.to_string());
	 GLib.Value cell2;
	 Gtk.TreeIter iter;
	 
	 boards_list.get_iter(out iter, path);
	 boards_list.get_value(iter, 1, out cell2);
	 
	 stdout.printf("%s\n", (string)cell2);
	 
	 this.get_threads((string)cell2);
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


	/**

	   Get boards
	   This will initialize the boards for the tree view

	 */
	private Gtk.ListStore request_boards() {
	
	  if (this.boards_list != null) {
	  stdout.printf("boards not null\n");
	    return this.boards_list;
	    }
	    
	  this.boards_list = new Gtk.ListStore(2, typeof (string), typeof(string));
	


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
				this.boards_list.append(out iter);
				this.boards_list.set(iter, 0, board_node.get_string_member("title"), 1, board_node.get_string_member("board"));

			}

		}
		catch {
			warning("Failed to retrieve board listing.");
		}
 
		return this.boards_list;
	}


	private Gtk.ListStore get_threads(string board, int page = 1) {
	

	    
	  this.threads_list = new Gtk.ListStore(2, typeof (string), typeof(string));
	


		//create new soup session
		Soup.Session session = new Soup.Session();

		// Syncrouniously get the information from the URI
		Soup.Message message = new Soup.Message("GET", "http://a.4cdn.org/"+ board + "/"+page.to_string()+".json");
		session.send_message (message);

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

      stdout.printf("%s\n", thread.get_object().get_array_member("posts").get_element(0).get_object().get_array_member("sub").get_element(0).get_string());

				//var thread_node = thread.get_object().get_array_member("posts");
				// stdout.printf("%s\n", board_node.get_string_member("title"));

      //  var post = thread_node.get_element(0);
       // stdout.printf("%s\n", post.get_string());
        
        
        
        
        
        
        
        //::We will just populate a ListStore that we will return at the end of the method containing just the titles.
				//Gtk.TreeIter iter;
				//this.threads_list.append(out iter);
				//this.threads_list.set(iter, 0, post.get_string_member("com"), 1, post.get_string_member("now"));

			}

		}
		catch {
			warning("Failed to retrieve board listing.");
		}
 
		return this.threads_list;
	}

	private Gtk.ScrolledWindow board_view(Gtk.ListStore list) {

		//:: Make the board tree view using the list parameter
		this.boards_view = new Gtk.TreeView.with_model (list);
		Gtk.ScrolledWindow scroll = new Gtk.ScrolledWindow(null,null);
		scroll.add(this.boards_view);


		Gtk.CellRendererText cell = new Gtk.CellRendererText ();
		boards_view.insert_column_with_attributes (-1, "Board", cell, "text", 0);
		//view.insert_column_with_attributes (-1, "Cities", cell, "text", 1);

		return scroll;
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


