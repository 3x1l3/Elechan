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
using Granite.Widgets;


namespace CodeWall {

public class Page : ScrolledWindow {

	private SourceBuffer _buffer;
	private SourceView _view;
	public string title;
	private string _filepath = "";
	private Tab _parent;
	private string _lastSavedBuffer;
	private bool saveableFlag = false;

	private AppWindow ? mainWindow = null;

	//Keeping track of when things are saved.
	private bool counterStarted = false;
	private int secondsBetweenSaves = 5;


	public Page(Tab ? parent=null, string ? buffer = "", string ? title = "") {
		this._parent = parent;
		this._buffer = new SourceBuffer(null);
		this._buffer.begin_not_undoable_action();
		this._buffer.text = buffer;
		this._view = new SourceView.with_buffer(this._buffer);
		this._lastSavedBuffer = buffer;
		this._buffer.end_not_undoable_action();
		this.title = title;

		this.add(this._view);

		this.connections();
	}



	public SourceView view {
		get { return _view; }
		set { this._view = value; }
	}

	public SourceBuffer buffer {
		get { return _buffer; }
		set { this._buffer = value; }
	}
	public Tab parent {
		get { return _parent; }
		set { this._parent = value; }
	}
	public string lastSavedBuffer {
		get { return _lastSavedBuffer; }
		set { this._lastSavedBuffer = value; }
	}
	public string filepath {
		get { return _filepath; }
		set {

			this._filepath = value;

		}
	}

	private bool saveDialog() {
		if (this.filepath == "") {
			Utilities util = new Utilities();
			FileChooserDialog saveDialog = util.dialog(null, Utilities.SAVEDIALOG);
			if (saveDialog.run() == ResponseType.ACCEPT) {

        var tempfilepath = saveDialog.get_filename();
        if (FileUtils.test(tempfilepath, GLib.FileTest.EXISTS)) {
          var confirm = Utilities.drawMessageDialog("File exists already. Overwrite?", MessageType.WARNING, ButtonsType.OK_CANCEL);
        
          if (confirm.run() == ResponseType.CANCEL) {
            
            confirm.close();
            saveDialog.destroy();
            return false;
          }
          confirm.close();
        }

				this.filepath = saveDialog.get_filename();
				string[] chunks = saveDialog.get_filename().split("/");
				this.parent.label = chunks[chunks.length-1];
				this._lastSavedBuffer = this._buffer.text;
				this.saveableFlag = false;

			}

			saveDialog.close();
		}
		return true;
	}
	public bool save() {
		return this.saveDialog() && this.write();

	}
	public string test() {
		return "This scope";
	}
	public bool write() {

		if (this._filepath != "") {


			try {
				FileUtils.set_contents(this._filepath, this._buffer.text);
				this.saved(true);
				return true;
			}
			catch (FileError e) {
				this.parent.label = "Unsaved Document";

				AppWindow.infobar.set_properties("Could not save file at "+this._filepath, "Save to different location?", true, MessageType.WARNING);
				this._filepath = "";

				ulong handler = AppWindow.infobar.button.clicked.connect((obj)=>{

					        if (this.save()) {
					                AppWindow.infobar.hide();
						}

					}
				                );
				AppWindow.infobar.disconnect(handler);
				//GLib.error("%s", e.message);

			}



		}

		return false;
	}

	public bool hasFilePath() {
		return this._filepath != "";
	}

	public void reloadFile() {
		if (this.hasFilePath()) {
			string tmp = "";

			this._view.place_cursor_onscreen();
			TextMark mark = this._buffer.get_insert();

			TextIter iter;
			TextIter iter2;
			this._buffer.get_iter_at_mark(out iter, mark);
			int line_num = iter.get_line();
			warning(iter.get_line().to_string());

			if (FileUtils.get_contents(this._filepath, out tmp)) {

				this._buffer.text = tmp;


			}

			this.formatted(line_num);


		}
	}

	private void bufferChanged_c() {
		if (this._buffer.text != this._lastSavedBuffer && this.saveableFlag == false) {
			this.saveableFlag = true;
			this.saveable(true);

		}

		if (!this.counterStarted) {
			this.counterStarted = true;
			Timeout.add(this.secondsBetweenSaves * 1000, auto_action
			);
		}

	}

	private bool auto_action() {
		warning("auto action");

		if (FileUtils.test(this._filepath, GLib.FileTest.EXISTS)) {
			this.write();
		}
		else {
			AppWindow.infobar.set_properties("Looks like the file you are trying to save to no longer exists", "Save to different location?", true, MessageType.WARNING);
			warning("file doesnt exist");
			this._filepath = "";
			ulong handler = AppWindow.infobar.button.clicked.connect((obj)=>{

				        if (this.save()) {
				                AppWindow.infobar.hide();
					}

				}
			                );
			AppWindow.infobar.disconnect(handler);

		}

		this.counterStarted = false;
		return false;
	}

	private void formatted_action(int currentLine) {
		TextIter iter;
		this._buffer.get_start_iter(out iter);
		this._buffer.get_iter_at_line(out iter, currentLine);
		this._buffer.place_cursor(iter);
		this._view.scroll_to_mark(this._buffer.get_insert(), 0.0, true, 0, 0.5);
		warning(iter.get_line().to_string());
	}

	public void connections() {

		this._buffer.changed.connect(bufferChanged_c);
		this.formatted.connect_after(formatted_action);

	}

	public signal void saveable(bool savea);
	public signal void saved(bool val);
	public signal void formatted(int currentLine);


	/*
	   Customization lines. These will be set in the preferences of the application later.


	   view.set_show_line_numbers(true);
	   view.set_show_right_margin(true);
	   view.set_auto_indent(true);
	   view.set_highlight_current_line(true);



	          view.show_completion.connect(() => {
	       warning("Completion requested");
	   });

	 */


}

}