#include <dlfcn.h>

#define CYCRIPT_PORT 8556
static void (*CYListenServer)(short port) = 0;

%ctor
{
	NSLog(@"cycriptListener");

	void *cycript = dlopen("/usr/lib/libcycript.dylib", RTLD_LAZY);
	if (!cycript) {
		NSLog(@"ERROR: cycriptListener failed to load /usr/lib/libcycript.dylib");
		return;
	}

	CYListenServer = (void (*)(short))dlsym(cycript, "CYListenServer");
	if (!CYListenServer) {
		NSLog(@"ERROR: cycriptListener failed to find CYListenServer");
		return;
	}

	CYListenServer(CYCRIPT_PORT);
	NSLog(@"cycriptListener port %d", CYCRIPT_PORT);
}
