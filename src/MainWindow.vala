using Gtk;
using Json;

namespace EleChan {

public class AppWindow : Gtk.Window {

	//::Store the initial boards. Will cache the first time.
	Gtk.ListStore boardsListStore = null;

	Gtk.ListStore threadsListStore = null;

	Gee.ArrayList<Gtk.Image> thumbnails = null;

	//::This layout contains the status bar/ main pane and or tools bar if needed.
	Gtk.Box appBox;

	//::Next drilldown contains a narrower main pane plus adds the tree view for the board.
	Gtk.Paned boardsBox;

	//::Narrow it down more and it has the threads on the top pane and the view on the bottom.
	Gtk.Paned threadsBox;

	Gtk.Grid thumbsGrid;

	//::Boards tree view for the sidebar.
	Gtk.TreeView boardsTreeView;

	//:: Threads tree view for top bar.
	Gtk.TreeView threadsTreeView;

	Gtk.ScrolledWindow boardsScrolledWindow;
	Gtk.ScrolledWindow threadsScrolledWindow;
	Gtk.ScrolledWindow thumbsScrolledWindow;

	//Store current board.
	string board = "";

	//::number of rows initailized in grid row. For deleting later.
	private int gridRows = 0;

	private int row = 1;
	private int column = 1;

	public AppWindow() {         //This is the default constructor for the new window.

		this.title = "4Chan Browser";         // Define the window title
		this.set_default_size(600, 600);         // Define the intial size of the window.
		this.destroy.connect(Gtk.main_quit);         // Clicking the close button will fully terminate the program.
		this.set_position(Gtk.WindowPosition.CENTER);         // Launch the program in the center of the screen
		this.set_titlebar(this.buildHeaderBar());
		this.set_events(Gdk.EventMask.BUTTON_PRESS_MASK);
		
		
		
		this.boardsTreeView = new Gtk.TreeView();

		this.thumbsGrid = new Gtk.Grid();
		this.thumbsGrid.set_row_spacing(10);
		this.thumbsGrid.set_column_spacing(10);
		this.thumbsGrid.set_margin_top(10);
		this.thumbsGrid.set_margin_left(10);


		this.threadsTreeView = new Gtk.TreeView.with_model(this.threadsListStore);

		this.boardsScrolledWindow = new Gtk.ScrolledWindow(null,null);

		this.threadsScrolledWindow = new Gtk.ScrolledWindow(null,null);
		this.thumbsScrolledWindow = new Gtk.ScrolledWindow(null,null);




		//::Define the layouts that are needed to make this possible.
		this.appBox = new Box(Orientation.VERTICAL, 0);
		this.boardsBox = new Gtk.Paned(Orientation.HORIZONTAL);
		this.threadsBox = new Gtk.Paned(Orientation.VERTICAL);



		this.add(appBox);
		this.appBox.pack_start(this.boardsBox);

		//:: add the board tree view to the left side
		this.buildBoardsListStore();
		this.buildThreadsListStore("3");
		this.populateBoardsTreeView(this.boardsListStore);
		this.populateThreadsTreeView(this.threadsListStore);
		this.boardsBox.add1(this.boardsScrolledWindow);



		this.boardsScrolledWindow.set_size_request(200,-1);
		this.threadsScrolledWindow.set_size_request(-1,200);

		this.thumbsScrolledWindow.add(this.thumbsGrid);

		this.threadsBox.add1(this.threadsScrolledWindow);



		this.threadsBox.add2(this.thumbsScrolledWindow);


		this.boardsBox.add2(this.threadsBox);

		this.thumbnails = new Gee.ArrayList<Gtk.Image>();

		this.boardsTreeView.set_activate_on_single_click(true);
		this.threadsTreeView.set_activate_on_single_click(true);
		this.boardsTreeView.row_activated.connect(this.connection_boardsRowClicked);
		this.threadsTreeView.row_activated.connect(this.connection_threadsRowClicked);
	}


	/**
	   ----------------------------------------------------

	   ----------------------------------------------------
	 */
	private void connection_boardsRowClicked(TreePath path, TreeViewColumn column) {
		int index = int.parse(path.to_string());
		GLib.Value cell2;
		Gtk.TreeIter iter;

		boardsListStore.get_iter(out iter, path);
		boardsListStore.get_value(iter, 1, out cell2);


		this.buildThreadsListStore((string)cell2);
		this.populateThreadsTreeView(this.threadsListStore);

	}

	private void connection_threadsRowClicked(TreePath path, TreeViewColumn column) {
		int index = int.parse(path.to_string());
		GLib.Value cell3;
		Gtk.TreeIter iter;

		threadsListStore.get_iter(out iter, path);
		threadsListStore.get_value(iter, 2, out cell3);


		this.buildThumbnailsArray((int64)cell3);
		//this.populateThreadsTreeView(this.threadsListStore);

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
		header.set_title("EleChan 4Chan Browser");
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

				if (!board.is_null()) {
					var board_node = board.get_object();
					// stdout.printf("%s\n", board_node.get_string_member("title"));

					//::We will just populate a ListStore that we will return at the end of the method containing just the titles.
					//:: @TODO Will have to create a parallel array or store to record the board shortcut
					Gtk.TreeIter iter;
					this.boardsListStore.append(out iter);

					string title = board_node.has_member("title") ? board_node.get_string_member("title") : "";
					string boardAbrv = board_node.has_member("board") ? board_node.get_string_member("board") : "";

					this.boardsListStore.set(iter, 0, title, 1, boardAbrv);
				}
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
		this.board = board;
		if (this.threadsListStore == null) {
			this.threadsListStore = new Gtk.ListStore(3, typeof (string), typeof (int64), typeof(int64));
		}

		this.threadsListStore.clear();

		for (int i = 1; i <=10; i++ ) {
			//create new soup session
			Soup.Session session = new Soup.Session();

			// Syncrouniously get the information from the URI
			Soup.Message message = new Soup.Message("GET", "http://a.4cdn.org/"+ board + "/"+i.to_string()+".json");
			session.queue_message (message, (sess, mess) =>{

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

				                        if (!thread.is_null()) {
				                                var posts = thread.get_object().get_array_member("posts");
				                                var post = posts.get_element(0);
				                                if (!post.is_null()) {
				                                        var post_object = post.get_object();
				                                        string sub = post_object.has_member("sub") ? post_object.get_string_member("sub") : "";
				                                        string com = post_object.has_member("com") ? post_object.get_string_member("com") : "";
				                                        int64 images = post_object.has_member("images") ? post_object.get_int_member("images") : 0;
				                                        int64 threadno = post_object.has_member("no") ? post_object.get_int_member("no") : 0;
				                                        string blurb = "";

				                                        if (sub == "") {
				                                                blurb = com;
									}
				                                        else{
				                                                blurb = sub + " - " + com;
									}


				                                        this.threadsListStore.append(out iter);
				                                        this.threadsListStore.set(iter, 0, sub, 1, images, 2, threadno);
								}
							}


						}

					}
				        catch {
				                warning("Failed to retrieve posts.");
					}

				}
			);





		}

		return this.threadsListStore;
	}

	private void buildThumbnailsArray(int64 threadNumber) {

		this.clearGrid();

		var threadURL = "http://a.4cdn.org/"+ this.board +"/thread/"+ threadNumber.to_string()+".json";
		Soup.Session session = new Soup.Session();
		Soup.Message message = new Soup.Message("GET", threadURL);
		session.send_message (message);
		try {
			var parser = new Json.Parser();
			string data = (string) message.response_body.flatten().data;
			stdout.printf("%s\n", threadURL);
			parser.load_from_data(data, -1);


			//::Get the root of the JSON as an object.
			var root_object = parser.get_root ().get_object ();

			//::Get the array member boards. Which is the first containing member in the array.
			var threads = root_object.get_array_member("posts");



			foreach (var post in threads.get_elements()) {

				if (post.is_null()) {
					continue;
				}

				var obj = post.get_object();




				var tim = obj.has_member("tim") ? obj.get_int_member("tim") : 0;
				var ext = obj.has_member("ext") ? obj.get_string_member("ext"):"";
				Gtk.Image image = null;



				if (tim != 0) {
					var url = "http://t.4cdn.org/" + this.board + "/"+ tim.to_string() + "s.jpg";


					GLib.File file = GLib.File.new_for_uri(url);


					file.read_async.begin (Priority.DEFAULT, null, (obj, res) => {
						        //AppWindow this = (AppWindow)obj;
						        var @is = file.read_async.end(res);
						        Gdk.Pixbuf buf = new Gdk.Pixbuf.from_stream(@is);
						        buf = buf.scale_simple(100,100, Gdk.InterpType.BILINEAR);
						        image = new Gtk.Image.from_pixbuf(buf);

						        //:: Find what a right key press is
                    Gtk.EventBox box = new Gtk.EventBox();
                    box.add(image);
                    
                    
                    
                    
                    //::This is our on click thumb event.
						        box.button_press_event.connect( (obj, event) => {
                        var largeImgURL = "http://t.4cdn.org/" + this.board + "/"+ tim.to_string() + ext;

                        
                        Gtk.Image fullImage = new Gtk.Image.from_pixbuf(buf);
                        Gtk.ScrolledWindow fullImageView = new Gtk.ScrolledWindow(null,null);
                        fullImageView.add(fullImage);
    
                        ViewImageWindow tmp = new ViewImageWindow(largeImgURL);
                        tmp.show_all();
                        
								        return true;
								}
						        );
						        
						        
						        
						        
						        this.thumbsGrid.attach(box, this.column, this.row, 1,1);


						        if (this.column > 6) {
						                this.column = 0;
						                this.row++;
							}
						        else{
						                this.column++;
							}

						        this.thumbsGrid.show_all();
						}
					);


				}

			}

		}
		catch {

		}


	}


	/**
	   ----------------------------------------------------

	   ----------------------------------------------------
	 */
	private void clearGrid() {
		for (int i = 0; i <= this.row+1; i++) {
			this.thumbsGrid.remove_row(i);

			//stdout.printf("deleting row %i\n", i);
		}

		this.thumbsGrid.show_all();
		this.column = 0;
		this.row = 0;
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
		this.threadsTreeView.insert_column_with_attributes(-1, "Images",cell, "text", 1);
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
		window.show_all();                                                        // Tell the window to draw
		Gtk.main();
		return 0;
	}
}
}

