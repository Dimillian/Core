/*
 SDL - Simple DirectMedia Layer
 Copyright (C) 1997-2009 Sam Lantinga
 
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 
 Sam Lantinga
 slouken@libsdl.org
 */

#include "SDL_uikitopengles.h"
#include "SDL_uikitopenglview.h"
#include "SDL_uikitappdelegate.h"
#include "SDL_uikitwindow.h"
#include "jumphack.h"
#include "SDL_sysvideo.h"
#include "SDL_loadso.h"
#include <dlfcn.h>

#ifdef IDOSBOX
#import "QuartzCore/CALayer.h"
#import "SDL_uikitviewcontroller.h"
#import "SDL_uikitnavigationcontroller.h"
#endif

static int UIKit_GL_Initialize(_THIS);

void *
UIKit_GL_GetProcAddress(_THIS, const char *proc)
{	
	/* Look through all SO's for the proc symbol.  Here's why:
	   -Looking for the path to the OpenGL Library seems not to work in the iPhone Simulator.
	   -We don't know that the path won't change in the future.
	*/
    return SDL_LoadFunction(RTLD_DEFAULT, proc);
}

/*
	note that SDL_GL_Delete context makes it current without passing the window
*/
int UIKit_GL_MakeCurrent(_THIS, SDL_Window * window, SDL_GLContext context)
{
	
	if (context) {
		SDL_WindowData *data = (SDL_WindowData *)window->driverdata;
		[data->view setCurrentContext];
	}
	else {
		[EAGLContext setCurrentContext: nil];
	}
		
    return 0;
}

int
UIKit_GL_LoadLibrary(_THIS, const char *path)
{
	/* 
		shouldn't be passing a path into this function 
		why?  Because we've already loaded the library
		and because the SDK forbids loading an external SO
	*/
    if (path != NULL) {
		SDL_SetError("iPhone GL Load Library just here for compatibility");
		return -1;
    }
    return 0;
}

extern void SDL_UIKit_UpdateBatteryMonitoring(void);

void UIKit_GL_SwapWindow(_THIS, SDL_Window * window)
{
    #ifdef SDL_POWER_UIKIT
    // Check once a frame to see if we should turn off the battery monitor.
    SDL_UIKit_UpdateBatteryMonitoring();
    #endif

	SDL_WindowData *data = (SDL_WindowData *)window->driverdata;
	
	if (nil == data->view) {
		return;
	}
	[data->view swapBuffers];
	/* since now we've got something to draw
	   make the window visible */
	[data->uiwindow makeKeyAndVisible];

	/* we need to let the event cycle run, or the OS won't update the OpenGL view! */
	SDL_PumpEvents();
	
}

SDL_GLContext UIKit_GL_CreateContext(_THIS, SDL_Window * window)
{
	SDL_uikitopenglview *view;
	SDL_WindowData *data = (SDL_WindowData *) window->driverdata;
    UIScreen *uiscreen = (UIScreen *) window->display->driverdata;
	UIWindow *uiwindow = data->uiwindow;

    /* construct our view, passing in SDL's OpenGL configuration data */
#ifdef IDOSBOX
    view = [[SDL_uikitopenglview alloc] initWithFrame: CGRectMake(0, 0, 640, 400) \
									retainBacking: _this->gl_config.retained_backing \
									rBits: _this->gl_config.red_size \
									gBits: _this->gl_config.green_size \
									bBits: _this->gl_config.blue_size \
									aBits: _this->gl_config.alpha_size \
									depthBits: _this->gl_config.depth_size];
#else
    view = [[SDL_uikitopenglview alloc] initWithFrame: [uiwindow bounds] \
                                        retainBacking: _this->gl_config.retained_backing \
                                                rBits: _this->gl_config.red_size \
                                                gBits: _this->gl_config.green_size \
                                                bBits: _this->gl_config.blue_size \
                                                aBits: _this->gl_config.alpha_size \
                                            depthBits: _this->gl_config.depth_size];
#endif
	
	data->view = view;
    
#ifdef IDOSBOX
    view.contentMode = UIViewContentModeScaleAspectFit;
    [[view layer] setMagnificationFilter:kCAFilterNearest];
    
    SDL_uikitviewcontroller *viewController = [[SDL_uikitviewcontroller alloc] initWithSDLView:view];
    SDL_uikitnavigationcontroller *navigationController = [[SDL_uikitnavigationcontroller alloc] initWithRootViewController:viewController];
    [uiwindow setRootViewController:navigationController];
    
    [SDLUIKitDelegate sharedAppDelegate].view = view;
    [SDLUIKitDelegate sharedAppDelegate].viewController = viewController;
    [SDLUIKitDelegate sharedAppDelegate].navigationController = navigationController;
    
    [viewController release];
    [navigationController release];
#else
	/* add the view to our window */
    [uiwindow addSubview: view ];
#endif
	/* Don't worry, the window retained the view */
	[view release];
	
	if ( UIKit_GL_MakeCurrent(_this, window, view) < 0 ) {
        UIKit_GL_DeleteContext(_this, view);
        return NULL;
    }
		
	return view;
}

void UIKit_GL_DeleteContext(_THIS, SDL_GLContext context)
{
	/* the delegate has retained the view, this will release him */
	SDL_uikitopenglview *view = (SDL_uikitopenglview *)context;
	/* this will also delete it */
	[view removeFromSuperview];
	
	return;
}


