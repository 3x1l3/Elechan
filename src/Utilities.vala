/* Copyright 2014 Chad Klassen
 *
 * This file is part of Codewall.
 *
 * Codewall is free software: you can redistribute it
 * and/or modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * Codewall is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
 * Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with Codewall. If not, see http://www.gnu.org/licenses/.
 */

using Gtk;
namespace CodeWall {

public class SV {
	private Box layout;
	private ScrolledWindow pane1;
	private ScrolledWindow pane2;
	private TextView lines;
	private TextView source;
	public TextBuffer linesbuffer;
	public TextBuffer sourcebuffer;

	public int __line_count = 1;
	public SV() {

		this.layout = new Box(Orientation.HORIZONTAL, 0);
		this.pane1 = new ScrolledWindow(null,null);
		this.pane2 = new ScrolledWindow(null,null);
		this.linesbuffer = new TextBuffer(null);
		this.sourcebuffer = new TextBuffer(null);
		this.sourcebuffer.set_modified(true);
		this.lines = new TextView.with_buffer(this.linesbuffer);
		this.source = new TextView.with_buffer(this.sourcebuffer);
		this.linesbuffer.text = "1";
		this.__line_count = 1;
		var p1vsb = this.pane1.get_vscrollbar();

		p1vsb.set_child_visible(false);

	}

	public Box build() {
		this.lines.width_request = 0;
		this.lines.set_editable(false);
		this.lines.set_cursor_visible(false);
		this.lines.set_right_margin(0);


		this.pane1.add(this.lines);
		this.pane2.add(this.source);

		this.layout.pack_start(this.pane1, false, false);
		this.layout.pack_start(this.pane2);

		//this.sourcebuffer.changed.connect(this.__linechange);
		this.connectLinechange();
		this.autoscroll();

		return this.layout;

	}

	private void connectLinechange() {
		int ? currentLineCount = this.__line_count;
		TextBuffer ? lineBuffer = this.linesbuffer;

		this.sourcebuffer.changed.connect((object) => {
			        int newLineCount = object.get_line_count();
			        string lines = "";



			        if (newLineCount == currentLineCount) {

				}
			        else if (newLineCount < currentLineCount) {
			                string[] linesArray = lineBuffer.text.split("\n");
			                linesArray = linesArray[0 : newLineCount-1];
			                lineBuffer.text = string.joinv("\n", linesArray);
				}
			        else {
			                for (int i = currentLineCount; i<= newLineCount; i++) {
			                        lines += i.to_string() + "\n";
					}
			                lineBuffer.text += lines;
				}

			        lines = lines.splice(lines.length-1,lines.length,"");


			        //Assign the lines to the buffer.
			        lineBuffer.text = lines;

			        //Assign the number of new lines to the global variable.
			        this.__line_count = newLineCount;

			}
		);
	}

	private void autoscroll() {
		ScrolledWindow ? linewindow = this.pane1;
		ScrolledWindow ? sourcewindow = this.pane2;
		TextView ? sourceTextView = this.source;


		this.pane2.scroll_event.connect((scroll)=> {
			        linewindow.set_vadjustment(pane2.get_vadjustment());
			        return false;
			}
		);

		this.pane1.scroll_event.connect((scroll)=> {
			        sourcewindow.set_vadjustment(pane1.get_vadjustment());
			        return false;
			}
		);
		this.source.move_cursor.connect((step,count,selection) => {
			        sourcewindow.set_vadjustment(linewindow.get_vadjustment());
			}
		);
		this.sourcebuffer.changed.connect(() => {
			        sourceTextView.set_cursor_visible(true);
			        sourcewindow.set_vadjustment(linewindow.get_vadjustment());
			}
		);
	}

}

public class Utilities : GLib.Object {

	/*
	   Eventually this should be a helper method to build an array out of the parameters
	   passed in. I don't know if its possible to assign different datatypes to each
	   array element. I.e. { 1, 1.2, "Hello", GLib.Object } etc.
	 */
	public const int SAVEDIALOG = 1;
	public const int OPENDIALOG = 0;


	/*
	    private void buildArgs(int fixed, ...) {

	        var l = va_list();
	        while(true) {

	        }

	    }
	 */


	/*
	    Simplified version of stdout.printf(). Should use buildArgs above.
	 */


	/*
	    public void print(string str, ...) {
	        var l = va_list();


	    }
	 */
	public FileChooserDialog dialog(Window ? parent, int type = Utilities.OPENDIALOG) {

		string title = "Open document";
		string acceptLabel = "_Open";
		FileChooserAction action = FileChooserAction.OPEN;

		return_if_fail(type != Utilities.OPENDIALOG || type != Utilities.SAVEDIALOG);

		if (type == Utilities.SAVEDIALOG) {
			title = "Save document";
			acceptLabel = "_Save";
			action = FileChooserAction.SAVE;
		}

		FileChooserDialog chooser = new FileChooserDialog(
			title, parent, action,"_Cancel",ResponseType.CANCEL,acceptLabel,ResponseType.ACCEPT);
		return chooser;
	}



	public int gotoLineDialog(Window ? parent) {
		Dialog dialog = new Dialog.with_buttons("Goto", parent, DialogFlags.MODAL, "_Goto", ResponseType.ACCEPT, "_Cancel", ResponseType.REJECT);

		dialog.width_request = 300;
		dialog.height_request =100;
		dialog.set_resizable(false);
		Box area = dialog.get_content_area() as Box;

		//Need to add elements to it
		Box vBox = new Box(Orientation.VERTICAL, 5);
		area.pack_start(vBox, false, true, 10);
		Label label = new Label("Enter the line you wish to go to:");
		label.set_halign(Align.START);
		label.set_margin_left(5);
		vBox.pack_start(label, false, true, 0);
		Entry entry = new Entry();
		vBox.pack_start(entry,false,true,0);

		dialog.show_all();

		int ret = -1;
    
		entry.key_press_event.connect((source, key) => {

			        if (key.hardware_keycode == 104 || key.hardware_keycode == 36) {
			                dialog.response(ResponseType.ACCEPT);
				}
			        else if (key.hardware_keycode == 9) {
			                dialog.response(ResponseType.REJECT);
				}

			        return false;
			}
		);

		if (dialog.run() == ResponseType.ACCEPT) {
			ret = entry.get_text().to_int();
		}
		else {
			dialog.destroy();
		}

		dialog.close();

		return ret;
	}

	public static MessageDialog drawMessageDialog(string message, MessageType msgtype = MessageType.INFO, ButtonsType btntype = ButtonsType.OK) {
		
		MessageDialog msg = new Gtk.MessageDialog (null, Gtk.DialogFlags.MODAL, msgtype, btntype, message);

        if (msgtype == MessageType.INFO && btntype == ButtonsType.OK) {
		    msg.response.connect((response_id) => {
		    	        msg.destroy();
		    	}
		    );
        }
		msg.show();

        return msg;
	}

	public Dialog preferences(Window ? parent, PageDecorator page_decorator) {

		Dialog pref = new Dialog.with_buttons("Preferences", parent, DialogFlags.DESTROY_WITH_PARENT, "_Apply", ResponseType.ACCEPT, "_Cancel", ResponseType.REJECT);
		pref.set_default_size(400,400);
		pref.title = "Preferences";

		var ModeButton = new Granite.Widgets.ModeButton();
		ModeButton.append_text("Interface");
		ModeButton.append_text("Behaviour");
		ModeButton.set_active(0);

		var tabLayout = new Box(Orientation.HORIZONTAL, 5);
		tabLayout.pack_start(new Separator(Orientation.HORIZONTAL));
		tabLayout.pack_start(ModeButton, false, true, 0);
		tabLayout.pack_start(new Separator(Orientation.HORIZONTAL));

		var OuterLayout = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);
		OuterLayout.pack_start(tabLayout,false,true,0);

		Gtk.Box content = pref.get_content_area() as Gtk.Box;
		content.pack_start(OuterLayout,false,true,0);

		ListStore schemes = new ListStore(1,typeof(string));
		TreeIter iter;


		foreach (string id in SourceStyleSchemeManager.get_default().get_scheme_ids()) {
			schemes.append(out iter);
			schemes.set(iter, 0, id, -1);
		}
		ComboBox schemeComboBox = new ComboBox.with_model(schemes);

		Gtk.CellRendererText renderer = new Gtk.CellRendererText ();
		schemeComboBox.pack_start (renderer, true);
		schemeComboBox.add_attribute (renderer, "text", 0);
		schemeComboBox.active = 0;


		/*
		        schemeComboBox.changed.connect(()=> {
		                schemeComboBox.get_active_iter (out iter);
		                        schemes.get_value (iter, 0, out val1);
		        }); */

		OuterLayout.pack_start(schemeComboBox, false, true, 0);

		pref.show_all();

		if (pref.run() == ResponseType.ACCEPT) {

			Gtk.TreePath path = new Gtk.TreePath.from_string (schemeComboBox.get_active().to_string());
			bool tmp = schemes.get_iter (out iter, path);
			Value colorScheme;
			schemes.get_value(iter, 0, out colorScheme);
			page_decorator.color_scheme = (string)colorScheme;

			this.preferencesChanged();
		}
		else {

		}

		pref.close();

		return pref;
	}



	/*
	   This function is the starting attempt to make my own source view class. Might be interesting to pursue later on.
	 */
	public Box SourceView(TextBuffer ? buffer, TextBuffer ? linebuffer) {
		Box layout = new Box(Orientation.HORIZONTAL, 0);
		ScrolledWindow pane1 = new ScrolledWindow(null,null);
		ScrolledWindow pane2 = new ScrolledWindow(null,null);

		TextView lines = new TextView.with_buffer(linebuffer);

		buffer.set_modified(true);



		TextView source = new TextView.with_buffer(buffer);
		source.buffer.paste_done.connect_after( (clipboard) => {
			        warning("pasted");

			}
		);
		lines.width_request = 5;
		lines.set_editable(false);
		lines.set_cursor_visible(false);
		lines.set_right_margin(5);


		pane1.add(lines);
		pane2.add(source);

		layout.pack_start(pane1, false, false);
		layout.pack_start(pane2);



		return layout;
	}

	public signal void preferencesChanged();

}
}