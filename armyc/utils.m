#import <armyc/ARMCore.h>
#import <armyc/utils.h>

Word get_bits(UWord instruction, Word pos, Word length){
	int i;
	Word bitmask = 0;
	Word backup_bitmask = 0;
	Word temp;
	for(i=0;i<length;i++){
		bitmask |= 1 << i;
	}
	backup_bitmask = bitmask;
	bitmask <<= pos;
	temp = instruction & bitmask;
	temp >>= pos;
	temp &= backup_bitmask;
	return temp;
}


UWord set_bits(UWord instruction, Word pos, Word length, UWord value){
	int i;
	UWord bitmask = 0;
	for(i = 0; i < length; i++ )
		bitmask |= 1 << i;
	value & bitmask;
	instruction &= ~(bitmask << pos);
	instruction |= (value << pos);
	return instruction;	
}

Word cond(ARMCore *core, UWord inst){
	Word something = get_bits(inst, 28, 4);
	Word n,z,c,v;
	switch(something){
		case 0:
			z = get_bits([core cpsr], 30, 1);
			return z == 1;
		break;
		case 1:
			z = get_bits([core cpsr], 30, 1);	
			return z == 0; 
		break;
		case 2:
			c = get_bits([core cpsr], 29, 1);	
			return c == 1; 
		break;
		case 3:
			c = get_bits([core cpsr], 29, 1);	
			return c == 0; 
		break;
		case 4:
			n = get_bits([core cpsr], 31, 1);	
			return n == 1; 
		break;
		case 5:
			n = get_bits([core cpsr], 31, 1);	
			return n == 0; 
		break;
		case 6:
			v = get_bits([core cpsr], 28, 1);	
			return v == 1; 
		break;
		case 7:
			v = get_bits([core cpsr], 28, 1);	
			return v == 0; 
		break;
		case 8:
			z = get_bits([core cpsr], 30, 1);	
			c = get_bits([core cpsr], 29, 1);	
			if(c==1 && z==0)
				return 1;
			return 0; 
		break;
		case 9:
			z = get_bits([core cpsr], 30, 1);	
			c = get_bits([core cpsr], 29, 1);	
			if(c==0 || z==1)
				return 1;
			return 0; 
		break;
		case 10:
			n = get_bits([core cpsr], 31, 1);	
			v = get_bits([core cpsr], 28, 1);	
			return n == v; 
		break;
		case 11:
			n = get_bits([core cpsr], 31, 1);	
			v = get_bits([core cpsr], 28, 1);	
			return n != v; 
		break;
		case 12:
			n = get_bits([core cpsr], 31, 1);	
			z = get_bits([core cpsr], 30, 1);	
			v = get_bits([core cpsr], 28, 1);	
			return (z==0 && n==v);
		break;
		case 13:
			n = [core statusFor:status_n];
			z = [core statusFor:status_z];
			v = [core statusFor:status_v];
			return(z == 1 || n != v);
		break;
		case 14:
			return 1; 
		break;
		case 15:
		break;
	}
}

Word ror(Word val, Word n, Word x) {
	Word a, b, c, d;
	a = val;
	b = a >> x;
	c = a << (n - x);
	c &= 0xffffffff;
	d = b | c;
	return d;
}

Word asr(Word val, Word x, Word n) {
	Word msb;
	msb = get_bits(val, n-1, 1);
	val >>= x;
	val = set_bits(val, n-1, 1, msb);
	return val;
}

Word count(Word val, Word n) {
	int i;
	Word bitmask = 1;
	Word c = 0;
	for(i = 0; i < n; i++){
		if(bitmask & val)
			c++;		
		bitmask <<= 1;
	}
	return c;
}

Word SignExtend(Word data, Word n) {
	if( n == 8 )
		if( get_bits(data, 7, 1) ) 
			data |= 0xffffff00;
	else if( n == 16 )
		if( get_bits(data, 15, 1) )
			data |= 0xffff0000;
	else if( n == 24 )
		if( get_bits(data, 23, 1) )
			data |= 0xff000000;
	return data;
	
}

Word SignExtend30(Word data, Word n) {
	if( n == 8 ) {
                if( get_bits(data, 7, 1) )
                        data |= 0x3fffff00;
        } else if( n == 16 ) {
                if( get_bits(data, 15, 1) )
                        data |= 0x3fff0000;
        } else if( n == 24 ) {
                if( get_bits(data, 23, 1) ) {
                        data |= 0x3f000000;
		}
	}
        return data;
}
Word AddCarryFrom(Word a, Word b, Word *carry) {
	Word num;
        Word i;
        Word c = 0;
        for(i = 0; i < 32; i++) {
                num = get_bits(a,i,1) + get_bits(b,i,1) + c;
                if(num >= 2) {
                        c    = 1;
                } else {
                        c = 0;
                }
        }
        *carry = c;
        return a + b;

}

Word OverflowFrom(Word m, Word s, Word r){

	if(get_bits(m, 31, 1) != get_bits(s, 31, 1))
		return 0;

	return (get_bits(m, 31, 1) != get_bits(r, 31, 1));
}
Word SubWithBorrow(Word a, Word b, Word *borrow) {
        Word num;
        Word substract;
        Word i;
        Word c = 0;
        for(i = 0; i < 32; i++) {
                substract = get_bits(b,i,1) + c;
                num = get_bits(a,i,1) - substract;
                if(num == -2) {
                        c   = 1;
                } else if(num == -1) {
                        c   = 1;
                } else {
                        c = 0;
                }
        }
        *borrow = c;
        return a - b;
}

Word msb_position(Word valor) {
	Word i;
	for( i = 31; i >= 0; i--)
		if( get_bits(valor, i, 1) )
			break;
	return i;
}	

void Mul64(Word n1,Word n2,Word *Hi,Word *Lo){
	Word i;
	Word bit;
	Word tempHi;
	Word temp;
	Word j;
	for(i=0;i<32;i++)
	{
		bit = get_bits(n1,i,1);
		if(bit == 1)
		{
			if(i==0)
				*Lo = *Lo + n2;
			else{
				temp = 0;
				for(j=0;j<i;j++)
				{
					tempHi = set_bits(temp,i-j,1,get_bits(n2,31-j,1));
				}
				*Hi = *Hi + tempHi;
				n2 =  n2 << i;
				*Lo = *Lo + n2;
			}
				
		}
	}
}
