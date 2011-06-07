#ifndef _CHILES_ITERATOR_H
#define _CHILES_ITERATOR_H

#include <Chiles/ChObject.h>

@protocol Iterator
-(BOOL)hasNext;
-(ChObject *)next;
@end

#endif

