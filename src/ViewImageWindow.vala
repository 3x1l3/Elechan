using Gtk;
using Json;

namespace EleChan {

public class ViewImageWindow : Gtk.Window {

	Gtk.ScrolledWindow viewport = null;
	Gdk.Pixbuf original = null;
	
	float zoom = (float)0.5;

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
		buf1 = buf1.scale_simple(16,16,Gdk.InterpType.BILINEAR);
		Gtk.Image img = new Gtk.Image.from_pixbuf (buf1);
		Gtk.ToolButton button2 = new Gtk.ToolButton (img, "Zoom Out");

		//Add Icon to header
		header.pack_start(button2);

		//Get another Icon.
		buf1 = new Gdk.Pixbuf.from_file("/usr/local/share/applications/zoomin.png");
		buf1 = buf1.scale_simple(16,16,Gdk.InterpType.BILINEAR);
		img = new Gtk.Image.from_pixbuf (buf1);
		Gtk.ToolButton button3 = new Gtk.ToolButton (img, "Zoom In");


    button2.clicked.connect(() => {
    
          this.viewport.@foreach((obj)=> {
              obj.destroy();
          });
    
    
            this.zoom *= (float)0.5;
            stdout.printf("%f\n", this.zoom);
             Gtk.Image image = null;
			        image = new Gtk.Image.from_pixbuf(this.resizeImage(this.original, (int)(this.original.get_width()*this.zoom),(int)(this.original.get_height()*this.zoom)));
this.viewport.child_set(new Gtk.Label(this.zoom.to_string()));
			        this.viewport.add(image);
			        
			        this.viewport.show_all();
    
    });
    
    button3.clicked.connect(()=> {
              this.viewport.@foreach((obj)=> {
              obj.destroy();
          });
    
    
            this.zoom /= (float)0.5;
            stdout.printf("%f\n", this.zoom);
             Gtk.Image image = null;
			        image = new Gtk.Image.from_pixbuf(this.resizeImage(this.original, (int)(this.original.get_width()*this.zoom),(int)(this.original.get_height()*this.zoom)));
this.viewport.child_set(new Gtk.Label(this.zoom.to_string()));
			        this.viewport.add(image);
			        
			        this.viewport.show_all();
    
    });

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
		
		int newHeight = 0;
		file.read_async.begin (Priority.DEFAULT, null, (obj, res) => {
			        //AppWindow this = (AppWindow)obj;

			        var @is = file.read_async.end(res);

			        this.original= new Gdk.Pixbuf.from_stream(@is);

			        newHeight = this.original.get_width()  / this.original.get_height() * 400;

			        Gdk.Pixbuf buf = this.original.copy();
              
              Gtk.Image image = null;
			        image = new Gtk.Image.from_pixbuf(this.resizeImage(this.original, (int)(this.original.get_width()*this.zoom),(int)(this.original.get_height()*this.zoom)));

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
		}
		else {
			scale = image.get_height() / newHeight;
		}

		int resizeWidth = (int) (image.get_width() / scale);
		int resizeHeight = (int) (image.get_height() / scale);

    stdout.printf("Resize image new width %i and new height %i\n", resizeWidth, resizeHeight);

		return image.scale_simple(resizeWidth, resizeHeight, Gdk.InterpType.BILINEAR);

	}



}
}