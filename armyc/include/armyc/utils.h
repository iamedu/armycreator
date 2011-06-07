#ifndef _UTILS_H
#define _UTILS_H

#include <Chiles/ChTypes.h>

#define asr32(x,y) asr(x,y,32)
#define ror32(x,y) ror(x,32,y)
#define count32(x) count(x,32)

Word get_bits(UWord, Word, Word);
UWord set_bits(UWord, Word, Word, UWord);
Word ror(Word, Word, Word);
Word asr(Word, Word, Word);
Word count(Word, Word);
Word SignExtend(Word, Word);
Word SignExtend30(Word, Word);
Word AddCarryFrom(Word,Word,Word *);
Word OverflowFrom(Word, Word, Word);
Word SubWithBorrow(Word,Word,Word *);
Word msb_position(Word);
void Mul64(Word,Word,Word *,Word *);

#endif

