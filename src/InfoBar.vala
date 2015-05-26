using Gtk;
using Granite.Widgets;

namespace Codewall {

public class InfoBar : Gtk.InfoBar {

	private Label text;
	private SeparatorToolItem separator;
	private Button _button;

	private Box content;
	private Button closebutton;

	public InfoBar() {
		this.init();
		this.build();
    this.connections();
	}

    public weak Button button {
        get{ return this._button; }
        set{ this._button = value; }
    }
    
   private void connections() {
    this.closebutton.clicked.connect(() => { 
      this.hide();
    } );
   }

	private void init() {
    this.text = new Label("");
    this._button = new Button();
		this.content = this.get_content_area() as Gtk.Box;
		this.separator = new SeparatorToolItem();
		this.separator.set_draw(false);
		this.separator.set_expand(true);
	  this.closebutton = new Button();
	  Image close = new Image.from_icon_name("window-close",IconSize.BUTTON);
	  close.set_pixel_size(16);
	  this.closebutton.set_image(close);
	  this.closebutton.set_relief(ReliefStyle.NONE);
	  //this.closebutton.set_label("X");
 
	}
	
	public void set_text(string label) {
	  this.text.set_label(label);
	}

	private void build() {
		this.content.pack_start(this.text, false, false);
	  this.content.pack_start(this.separator, true, true);
		this.content.pack_start(this._button, false, false);
    this.content.pack_start(this.closebutton,false,false);
	}

    public void set_properties(string message, string? btnText = null, bool showClose = true, MessageType type = MessageType.INFO) {
        this.text.set_label(message);
        
        if (btnText != null) {
          this._button.set_label(btnText);
                  this._button.no_show_all = false;
          this._button.set_visible(true);
          
        } else {
          this._button.no_show_all = true;
          this._button.set_visible(false);
        }
        this.closebutton.set_visible(showClose);
          
        this.set_message_type(type);
        this.show();
    }


 

    public void hide() {
        this.no_show_all = true;
        this.set_visible(false);
    }

    public void dismiss() {
        this.hide();
      
    }

    private void show() {
        this.no_show_all = false;
        this.set_visible(true);
        this.show_all();
    }
   

}

}