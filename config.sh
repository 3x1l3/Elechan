# Dependencies needed
# cmake
# gtk+-3.0
# granite
# libsoup2.4-dev
# libjson-glib-dev
# vala

#installs cmake
apt-get install cmake libgranite-dev valac libsoup2.4-dev libjson-glib-dev

# Sym link required libraries until i figure out how to get CMAKE to use the vala0.26 directory.
# maybe just mv and symlink the vala directory?
#ln -s /usr/share/vala-0.26/vapi/libsoup2.4.vapi /usr/share/vala/vapi/
#ln -s /usr/share/vala-0.26/vapi/json-glib-1.0.vapi /usr/share/vala/vapi/

# sym link the new vala version. Might have to reinstall packages if builds dont work.
ln -s /usr/share/vala-0.26/ /usr/share/vala

#Installs depenencies for gtksource view
apt-get install libgtksourceview-3.0-dev

#Installs dependencies for gtk+3.0 and granite
apt-get install libgranite-dev

#install vala compiler
apt-get install valac



# How to compile
#cd ./build
#cmake -DCMAKE_INSTALL=/usr ../


