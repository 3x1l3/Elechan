using Gtk;
using Json;

namespace EleChan {

public class ViewImageWindow : Gtk.Window {

	Gtk.ScrolledWindow viewport = null;
	Gdk.Pixbuf original = null;

	public ViewImageWindow(string url) {
		this.title = "EleChan View Image";         // Define the window title
		this.set_default_size(600, 600);         // Define the intial size of the window.
		//this.destroy.connect(Gtk.main_quit);         // Clicking the close button will fully terminate the program.
		this.set_position(Gtk.WindowPosition.CENTER);         // Launch the program in the center of the screen
    this.set_titlebar(this.buildHeaderBar());
		this.viewport = new Gtk.ScrolledWindow(null,null);
		this.add(this.viewport);

		this.loadImage(url);



		this.viewport.show_all();
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
		header.set_title("EleChan Image Viewer");
		header.set_show_close_button(true);
		//header.set_subtitle("Subtitle here");
		header.spacing = 0;

		//Get image from icon theme

		Gdk.Pixbuf buf1 = new Gdk.Pixbuf.from_file("/usr/local/share/applications/zoomout.png");
		buf1 = buf1.scale_simple(32,32,Gdk.InterpType.BILINEAR);
		Gtk.Image img = new Gtk.Image.from_pixbuf (buf1);
		Gtk.ToolButton button2 = new Gtk.ToolButton (img, "Zoom Out");
    
		//Add Icon to header
		header.pack_start(button2);

		//Get another Icon.
		buf1 = new Gdk.Pixbuf.from_file("/usr/local/share/applications/zoomin.png");
		buf1 = buf1.scale_simple(16,16,Gdk.InterpType.BILINEAR);
		img = new Gtk.Image.from_pixbuf (buf1);
		Gtk.ToolButton button3 = new Gtk.ToolButton (img, "Zoom In");

		//Add it again
		header.pack_start(button3);

		//Add a search entry to the header
		//header.pack_start(new Gtk.SearchEntry());

		//Return it to be included somewhere else.
		return header;

	}


	private void loadImage(string url) {
		stdout.printf("added image %s\n", url);
		GLib.File file = GLib.File.new_for_uri(url);
		Gtk.Image image = null;
		int newHeight = 0;
		file.read_async.begin (Priority.DEFAULT, null, (obj, res) => {
			        //AppWindow this = (AppWindow)obj;
			     
			        var @is = file.read_async.end(res);
			     
			        this.original= new Gdk.Pixbuf.from_stream(@is);

			        newHeight = this.original.get_width()  / this.original.get_height() * 400;

			        Gdk.Pixbuf buf = this.original.copy();

			        image = new Gtk.Image.from_pixbuf(this.resizeImage(this.original, 400,400));
			        stdout.printf("new height %i\n", newHeight);
			        this.viewport.add(image);
			        this.viewport.show_all();

			}
		);

	}
	
	
	private Gdk.Pixbuf resizeImage(Gdk.Pixbuf image, int newWidth, int newHeight) {
	  
	  var sourceRatio = image.get_width() / image.get_height();
	  var targetRatio = newWidth / newHeight;
	  
	  float scale = 0;
	  
	  if (sourceRatio < targetRatio) {
	     scale = image.get_width() / newWidth;
	  } else {
	     scale = image.get_height() / newHeight;
	  }
	  
	  int resizeWidth = (int) image.get_width() / scale;
	  int resizeHeight = (int) image.get_height() / scale;
	  
	  return image.scale_simple(resizeWidth, resizeHeight, Gdk.InterpType.BILINEAR);
	  
	}



}
}