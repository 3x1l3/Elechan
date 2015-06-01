using Gtk;
using Json;

namespace EleChan {

public class ViewImageWindow : Gtk.Window {

	Gtk.ScrolledWindow viewport = null;

	public ViewImageWindow(string url) {
		this.title = "EleChan View Image";         // Define the window title
		this.set_default_size(600, 600);         // Define the intial size of the window.
		//this.destroy.connect(Gtk.main_quit);         // Clicking the close button will fully terminate the program.
		this.set_position(Gtk.WindowPosition.CENTER);         // Launch the program in the center of the screen

		this.viewport = new Gtk.ScrolledWindow(null,null);
		this.add(this.viewport);
    stdout.printf("before load image\n");
		this.loadImage(url);
    stdout.printf("after load image\n");

		
		this.viewport.show_all();
	}

	private void loadImage(string url) {
		stdout.printf("added image %s\n", url);
		GLib.File file = GLib.File.new_for_uri(url);
		Gtk.Image image = null;
		file.read_async.begin (Priority.DEFAULT, null, (obj, res) => {
			        //AppWindow this = (AppWindow)obj;
			        var @is = file.read_async.end(res);

			        Gdk.Pixbuf buf = new Gdk.Pixbuf.from_stream(@is);
			        image = new Gtk.Image.from_pixbuf(buf);
			                      stdout.printf("in async func\n");
			        this.viewport.add(image);
this.viewport.show_all();

			}
		);

	}

}
}