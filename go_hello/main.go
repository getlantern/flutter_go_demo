package main

/*
#include <stdlib.h>
*/
import "C"
import "unsafe"

//export HelloWorld
func HelloWorld() *C.char {
	return C.CString("Hello from Go!")
}

//export FreeString
func FreeString(s *C.char) {
	C.free(unsafe.Pointer(s))
}

func main() {}
