#ifdef __linux__
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#endif

struct WAH { int x,y,width,height; };

extern "C" WAH gwa() {
    WAH area = {0,0,-1,-1};

#ifdef __linux__
    Display* dpy = XOpenDisplay(nullptr);
    if (dpy) {
        Window root = DefaultRootWindow(dpy);
        Atom netWorkarea = XInternAtom(dpy, "_NET_WORKAREA", True);
        if (netWorkarea != None) {
            Atom type;
            int format;
            unsigned long nitems, bytes_after;
            unsigned char* prop = nullptr;
            if (XGetWindowProperty(dpy, root, netWorkarea, 0, 4, False, XA_CARDINAL,
                                   &type, &format, &nitems, &bytes_after, &prop) == Success && prop) {
                unsigned long* data = reinterpret_cast<unsigned long*>(prop);
                area.x = data[0];
                area.y = data[1];
                area.width = data[2];
                area.height = data[3];
                XFree(prop);
            }
        }
        XCloseDisplay(dpy);
    }
#endif

    return area;
}