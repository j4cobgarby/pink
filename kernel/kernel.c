/*
 * =====================================================================================
 *
 *       Filename:  kernel.c
 *
 *    Description:  The kernel entry point.
 *
 *        Created:  06/05/18 20:40:30
 *       Compiler:  gcc
 *
 *         Author:  Jacob Garby (), thyself@jacobgarby.co.uk
 *
 * =====================================================================================
 */

#include <stdint.h>
#include "io.h"

void main() {
    char* vidmem = (char*) 0xb8000;
    *vidmem = 'X';
    return;
}
