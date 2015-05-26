/* MainWindow.c generated by valac 0.26.2, the Vala compiler
 * generated from MainWindow.vala, do not modify */

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

#include <glib.h>
#include <glib-object.h>
#include <granite.h>
#include <gtk/gtk.h>
#include <gio/gio.h>
#include <stdlib.h>
#include <string.h>


#define 4CHAN_TYPE_APP_WINDOW (4chan_app_window_get_type ())
#define 4CHAN_APP_WINDOW(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), 4CHAN_TYPE_APP_WINDOW, 4ChanAppWindow))
#define 4CHAN_APP_WINDOW_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), 4CHAN_TYPE_APP_WINDOW, 4ChanAppWindowClass))
#define 4CHAN_IS_APP_WINDOW(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), 4CHAN_TYPE_APP_WINDOW))
#define 4CHAN_IS_APP_WINDOW_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), 4CHAN_TYPE_APP_WINDOW))
#define 4CHAN_APP_WINDOW_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), 4CHAN_TYPE_APP_WINDOW, 4ChanAppWindowClass))

typedef struct _4ChanAppWindow 4ChanAppWindow;
typedef struct _4ChanAppWindowClass 4ChanAppWindowClass;
typedef struct _4ChanAppWindowPrivate 4ChanAppWindowPrivate;
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))
#define _g_free0(var) (var = (g_free (var), NULL))
#define _g_error_free0(var) ((var == NULL) ? NULL : (var = (g_error_free (var), NULL)))

struct _4ChanAppWindow {
	GraniteApplication parent_instance;
	4ChanAppWindowPrivate * priv;
	GtkWindow* window;
};

struct _4ChanAppWindowClass {
	GraniteApplicationClass parent_class;
};

struct _4ChanAppWindowPrivate {
	GtkBox* layout;
	GraniteWidgetsDynamicNotebook* tabs;
	GtkFileChooserDialog* openDialog;
	GraniteWidgetsAboutDialog* AboutDialog;
	GtkMenu* cogMenu;
	GData* cogMenuItems;
	GtkActionGroup* main_actions;
	GtkUIManager* ui;
};


static gpointer 4chan_app_window_parent_class = NULL;

GType 4chan_app_window_get_type (void) G_GNUC_CONST;
#define 4CHAN_APP_WINDOW_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), 4CHAN_TYPE_APP_WINDOW, 4ChanAppWindowPrivate))
enum  {
	4CHAN_APP_WINDOW_DUMMY_PROPERTY
};
4ChanAppWindow* 4chan_app_window_new (void);
4ChanAppWindow* 4chan_app_window_construct (GType object_type);
static void _gtk_main_quit_gtk_widget_destroy (GtkWidget* _sender, gpointer self);
gint 4chan_app_window_main (gchar** args, int args_length1);
static void 4chan_app_window_finalize (GObject* obj);


static void _gtk_main_quit_gtk_widget_destroy (GtkWidget* _sender, gpointer self) {
#line 54 "/home/exile/4chan/src/MainWindow.vala"
	gtk_main_quit ();
#line 85 "MainWindow.c"
}


4ChanAppWindow* 4chan_app_window_construct (GType object_type) {
	4ChanAppWindow * self = NULL;
	GtkWindow* _tmp0_ = NULL;
	GtkWindow* _tmp1_ = NULL;
	GtkWindow* _tmp2_ = NULL;
	GtkWindow* _tmp3_ = NULL;
	GtkWindow* _tmp4_ = NULL;
	gchar* _tmp5_ = NULL;
	GError * _inner_error_ = NULL;
#line 42 "/home/exile/4chan/src/MainWindow.vala"
	self = (4ChanAppWindow*) granite_application_construct (object_type);
#line 44 "/home/exile/4chan/src/MainWindow.vala"
	g_application_set_application_id ((GApplication*) self, "apps.4chan");
#line 45 "/home/exile/4chan/src/MainWindow.vala"
	g_application_set_flags ((GApplication*) self, G_APPLICATION_HANDLES_COMMAND_LINE);
#line 49 "/home/exile/4chan/src/MainWindow.vala"
	_tmp0_ = (GtkWindow*) gtk_window_new (GTK_WINDOW_TOPLEVEL);
#line 49 "/home/exile/4chan/src/MainWindow.vala"
	g_object_ref_sink (_tmp0_);
#line 49 "/home/exile/4chan/src/MainWindow.vala"
	_g_object_unref0 (self->window);
#line 49 "/home/exile/4chan/src/MainWindow.vala"
	self->window = _tmp0_;
#line 52 "/home/exile/4chan/src/MainWindow.vala"
	_tmp1_ = self->window;
#line 52 "/home/exile/4chan/src/MainWindow.vala"
	gtk_window_set_title (_tmp1_, "4Chan Browser");
#line 53 "/home/exile/4chan/src/MainWindow.vala"
	_tmp2_ = self->window;
#line 53 "/home/exile/4chan/src/MainWindow.vala"
	gtk_window_set_default_size (_tmp2_, 600, 600);
#line 54 "/home/exile/4chan/src/MainWindow.vala"
	_tmp3_ = self->window;
#line 54 "/home/exile/4chan/src/MainWindow.vala"
	g_signal_connect ((GtkWidget*) _tmp3_, "destroy", (GCallback) _gtk_main_quit_gtk_widget_destroy, NULL);
#line 59 "/home/exile/4chan/src/MainWindow.vala"
	_tmp4_ = self->window;
#line 59 "/home/exile/4chan/src/MainWindow.vala"
	gtk_window_set_position (_tmp4_, GTK_WIN_POS_CENTER);
#line 60 "/home/exile/4chan/src/MainWindow.vala"
	_tmp5_ = g_strdup ("text-x-generic-template");
#line 60 "/home/exile/4chan/src/MainWindow.vala"
	_g_free0 (((GraniteApplication*) self)->app_icon);
#line 60 "/home/exile/4chan/src/MainWindow.vala"
	((GraniteApplication*) self)->app_icon = _tmp5_;
#line 134 "MainWindow.c"
	{
		GtkWindow* _tmp6_ = NULL;
#line 63 "/home/exile/4chan/src/MainWindow.vala"
		_tmp6_ = self->window;
#line 63 "/home/exile/4chan/src/MainWindow.vala"
		gtk_window_set_icon_from_file (_tmp6_, "../data/icon.png", &_inner_error_);
#line 63 "/home/exile/4chan/src/MainWindow.vala"
		if (G_UNLIKELY (_inner_error_ != NULL)) {
#line 143 "MainWindow.c"
			goto __catch0_g_error;
		}
	}
	goto __finally0;
	__catch0_g_error:
	{
		GError* e = NULL;
		GError* _tmp7_ = NULL;
		const gchar* _tmp8_ = NULL;
#line 62 "/home/exile/4chan/src/MainWindow.vala"
		e = _inner_error_;
#line 62 "/home/exile/4chan/src/MainWindow.vala"
		_inner_error_ = NULL;
#line 66 "/home/exile/4chan/src/MainWindow.vala"
		_tmp7_ = e;
#line 66 "/home/exile/4chan/src/MainWindow.vala"
		_tmp8_ = _tmp7_->message;
#line 66 "/home/exile/4chan/src/MainWindow.vala"
		g_warning ("MainWindow.vala:66: %s", _tmp8_);
#line 62 "/home/exile/4chan/src/MainWindow.vala"
		_g_error_free0 (e);
#line 165 "MainWindow.c"
	}
	__finally0:
#line 62 "/home/exile/4chan/src/MainWindow.vala"
	if (G_UNLIKELY (_inner_error_ != NULL)) {
#line 62 "/home/exile/4chan/src/MainWindow.vala"
		g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
#line 62 "/home/exile/4chan/src/MainWindow.vala"
		g_clear_error (&_inner_error_);
#line 62 "/home/exile/4chan/src/MainWindow.vala"
		return NULL;
#line 176 "MainWindow.c"
	}
#line 42 "/home/exile/4chan/src/MainWindow.vala"
	return self;
#line 180 "MainWindow.c"
}


4ChanAppWindow* 4chan_app_window_new (void) {
#line 42 "/home/exile/4chan/src/MainWindow.vala"
	return 4chan_app_window_construct (4CHAN_TYPE_APP_WINDOW);
#line 187 "MainWindow.c"
}


/**
 * Much like other programming langauges such as Java, we will define our main
 * execution loop as a static method.
 */
gint 4chan_app_window_main (gchar** args, int args_length1) {
	gint result = 0;
	4ChanAppWindow* app = NULL;
	4ChanAppWindow* _tmp0_ = NULL;
	gint status = 0;
	4ChanAppWindow* _tmp1_ = NULL;
	gchar** _tmp2_ = NULL;
	gint _tmp2__length1 = 0;
	gint _tmp3_ = 0;
	gint _tmp4_ = 0;
#line 86 "/home/exile/4chan/src/MainWindow.vala"
	gtk_init (&args_length1, &args);
#line 87 "/home/exile/4chan/src/MainWindow.vala"
	_tmp0_ = 4chan_app_window_new ();
#line 87 "/home/exile/4chan/src/MainWindow.vala"
	app = _tmp0_;
#line 90 "/home/exile/4chan/src/MainWindow.vala"
	_tmp1_ = app;
#line 90 "/home/exile/4chan/src/MainWindow.vala"
	_tmp2_ = args;
#line 90 "/home/exile/4chan/src/MainWindow.vala"
	_tmp2__length1 = args_length1;
#line 90 "/home/exile/4chan/src/MainWindow.vala"
	_tmp3_ = granite_application_run ((GraniteApplication*) _tmp1_, _tmp2_, _tmp2__length1);
#line 90 "/home/exile/4chan/src/MainWindow.vala"
	status = _tmp3_;
#line 92 "/home/exile/4chan/src/MainWindow.vala"
	_tmp4_ = status;
#line 92 "/home/exile/4chan/src/MainWindow.vala"
	if (_tmp4_ == 1) {
#line 94 "/home/exile/4chan/src/MainWindow.vala"
		gtk_main ();
#line 227 "MainWindow.c"
	}
#line 97 "/home/exile/4chan/src/MainWindow.vala"
	result = status;
#line 97 "/home/exile/4chan/src/MainWindow.vala"
	_g_object_unref0 (app);
#line 97 "/home/exile/4chan/src/MainWindow.vala"
	return result;
#line 235 "MainWindow.c"
}


int main (int argc, char ** argv) {
#if !GLIB_CHECK_VERSION (2,35,0)
	g_type_init ();
#endif
#line 85 "/home/exile/4chan/src/MainWindow.vala"
	return 4chan_app_window_main (argv, argc);
#line 245 "MainWindow.c"
}


static void 4chan_app_window_class_init (4ChanAppWindowClass * klass) {
#line 26 "/home/exile/4chan/src/MainWindow.vala"
	4chan_app_window_parent_class = g_type_class_peek_parent (klass);
#line 26 "/home/exile/4chan/src/MainWindow.vala"
	g_type_class_add_private (klass, sizeof (4ChanAppWindowPrivate));
#line 26 "/home/exile/4chan/src/MainWindow.vala"
	G_OBJECT_CLASS (klass)->finalize = 4chan_app_window_finalize;
#line 256 "MainWindow.c"
}


static void 4chan_app_window_instance_init (4ChanAppWindow * self) {
#line 26 "/home/exile/4chan/src/MainWindow.vala"
	self->priv = 4CHAN_APP_WINDOW_GET_PRIVATE (self);
#line 27 "/home/exile/4chan/src/MainWindow.vala"
	self->window = NULL;
#line 265 "MainWindow.c"
}


static void 4chan_app_window_finalize (GObject* obj) {
	4ChanAppWindow * self;
#line 26 "/home/exile/4chan/src/MainWindow.vala"
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, 4CHAN_TYPE_APP_WINDOW, 4ChanAppWindow);
#line 27 "/home/exile/4chan/src/MainWindow.vala"
	_g_object_unref0 (self->window);
#line 28 "/home/exile/4chan/src/MainWindow.vala"
	_g_object_unref0 (self->priv->layout);
#line 30 "/home/exile/4chan/src/MainWindow.vala"
	_g_object_unref0 (self->priv->tabs);
#line 32 "/home/exile/4chan/src/MainWindow.vala"
	_g_object_unref0 (self->priv->openDialog);
#line 33 "/home/exile/4chan/src/MainWindow.vala"
	_g_object_unref0 (self->priv->AboutDialog);
#line 34 "/home/exile/4chan/src/MainWindow.vala"
	_g_object_unref0 (self->priv->cogMenu);
#line 38 "/home/exile/4chan/src/MainWindow.vala"
	_g_object_unref0 (self->priv->main_actions);
#line 39 "/home/exile/4chan/src/MainWindow.vala"
	_g_object_unref0 (self->priv->ui);
#line 26 "/home/exile/4chan/src/MainWindow.vala"
	G_OBJECT_CLASS (4chan_app_window_parent_class)->finalize (obj);
#line 291 "MainWindow.c"
}


GType 4chan_app_window_get_type (void) {
	static volatile gsize 4chan_app_window_type_id__volatile = 0;
	if (g_once_init_enter (&4chan_app_window_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (4ChanAppWindowClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) 4chan_app_window_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (4ChanAppWindow), 0, (GInstanceInitFunc) 4chan_app_window_instance_init, NULL };
		GType 4chan_app_window_type_id;
		4chan_app_window_type_id = g_type_register_static (GRANITE_TYPE_APPLICATION, "4ChanAppWindow", &g_define_type_info, 0);
		g_once_init_leave (&4chan_app_window_type_id__volatile, 4chan_app_window_type_id);
	}
	return 4chan_app_window_type_id__volatile;
}



